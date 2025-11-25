import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart'; // Librería Clásica (HC-05)
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Necesario si guardamos directo o usamos tipos
import 'package:vital_check1/screen/home_screen.dart';
import 'package:vital_check1/screen/indicadores_screen.dart'; // Para la redirección

class LecturaScreen extends StatefulWidget {
  const LecturaScreen({super.key});

  @override
  State<LecturaScreen> createState() => _LecturaScreenState();
}

class _LecturaScreenState extends State<LecturaScreen> {
  // --- Variables Bluetooth ---
  BluetoothConnection? connection;
  List<BluetoothDevice> _devicesList = [];
  bool _isConnecting = false;
  bool _isConnected = false;
  String _buffer = ''; // Buffer para datos fragmentados

  // --- Variables de Datos en Tiempo Real ---
  double _currentTemp = 0.0;
  int _currentHeartRate = 0;
  double _currentRespRate =
      0.0; // CAMBIO: Ahora representa Frecuencia Respiratoria (antes AccX)

  // --- Listas para Calcular Promedios ---
  final List<double> _tempReadings = [];
  final List<int> _heartReadings = [];
  final List<double> _respReadings = []; // CAMBIO: Lista para respiración

  // --- Temporizador ---
  Timer? _timer;
  int _secondsRemaining = 105; // Duración de 105 segundos
  bool _isReading = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _loadBondedDevices();
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (isConnected) {
      connection?.dispose();
    }
    super.dispose();
  }

  bool get isConnected => connection != null && connection!.isConnected;

  // 1. Permisos
  Future<void> _requestPermissions() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();
  }

  // 2. Cargar dispositivos vinculados
  Future<void> _loadBondedDevices() async {
    List<BluetoothDevice> devices = [];
    try {
      devices = await FlutterBluetoothSerial.instance.getBondedDevices();
    } catch (e) {
      debugPrint("Error al obtener dispositivos: $e");
    }
    if (mounted) {
      setState(() {
        _devicesList = devices;
      });
    }
  }

  // 3. Conectar e Iniciar Temporizador
  void _connect(BluetoothDevice device) async {
    setState(() => _isConnecting = true);

    try {
      BluetoothConnection newConnection = await BluetoothConnection.toAddress(
        device.address,
      );

      setState(() {
        connection = newConnection;
        _isConnected = true;
        _isConnecting = false;
        _isReading = true; // Empezamos a leer
      });

      // INICIAR EL TEMPORIZADOR DE 105 SEGUNDOS
      _startTimer();

      // Escuchar datos
      connection!.input!.listen(_onDataReceived).onDone(() {
        if (mounted) {
          setState(() => _isConnected = false);
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isConnecting = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('No se pudo conectar: $e')));
      }
    }
  }

  // --- LÓGICA DEL TEMPORIZADOR ---
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        // ¡Tiempo terminado!
        _finishReadingAndRedirect();
      }
    });
  }

  // --- FINALIZAR Y REDIRECCIONAR ---
  void _finishReadingAndRedirect() {
    _timer?.cancel();
    connection?.dispose(); // Desconectar Bluetooth

    // Calcular Promedios
    double avgTemp = 0.0;
    if (_tempReadings.isNotEmpty) {
      avgTemp = _tempReadings.reduce((a, b) => a + b) / _tempReadings.length;
    }

    int avgHeart = 0;
    if (_heartReadings.isNotEmpty) {
      avgHeart =
          (_heartReadings.reduce((a, b) => a + b) / _heartReadings.length)
              .round();
    }

    // CAMBIO: Calcular promedio de respiración
    double avgResp = 0.0;
    if (_respReadings.isNotEmpty) {
      avgResp = _respReadings.reduce((a, b) => a + b) / _respReadings.length;
    }

    // Redondear valores para pasar a la siguiente pantalla
    avgTemp = double.parse(avgTemp.toStringAsFixed(1));
    avgResp = double.parse(avgResp.toStringAsFixed(1));

    // Navegar a IndicadoresScreen pasando los datos
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => IndicadoresScreen(
            avgTemp: avgTemp,
            avgHeartRate: avgHeart,
            avgRespRate: avgResp,
            // NOTA: Asegúrate de agregar 'averageRespRate' al constructor de IndicadoresScreen
            // si quieres mostrar este dato allá. Si no, puedes pasar el valor o guardarlo aquí.
            // averageRespRate: avgResp,
          ),
        ),
      );
    }
  }

  // 4. Procesar datos
  void _onDataReceived(Uint8List data) {
    try {
      String incoming = utf8.decode(data);
      _buffer += incoming;

      if (_buffer.contains('\n')) {
        List<String> lines = _buffer.split('\n');
        for (int i = 0; i < lines.length - 1; i++) {
          _parseSensorString(lines[i].trim());
        }
        _buffer = lines.last;
      }
    } catch (e) {
      debugPrint("Error decodificando: $e");
    }
  }

  // Parsear formato "TEMP,RITMO,FREC_RESP,..." (Antes X,Y,Z)
  void _parseSensorString(String dataString) {
    if (dataString.isEmpty) return;
    List<String> parts = dataString.split(',');

    // Asumimos que el orden es: Temperatura, Ritmo Cardiaco, Frecuencia Respiratoria
    if (parts.length >= 3) {
      double t = double.tryParse(parts[0]) ?? 0.0;
      int h = int.tryParse(parts[1]) ?? 0;
      double r =
          double.tryParse(parts[2]) ??
          0.0; // Frecuencia Respiratoria (antes AccX)

      // Guardar en listas para el promedio
      if (t > 0) _tempReadings.add(t);
      if (h > 0) _heartReadings.add(h);
      if (r > 0) _respReadings.add(r);

      setState(() {
        _currentTemp = t;
        _currentHeartRate = h;
        _currentRespRate = r;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Lectura de Sensores"),
        backgroundColor: const Color(0xFF212121),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Panel Principal: Temporizador o Estado ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _isReading
                      ? Colors.green.withOpacity(0.1)
                      : const Color(0xFF333333),
                  borderRadius: BorderRadius.circular(20),
                  border: _isReading
                      ? Border.all(color: Colors.green, width: 2)
                      : null,
                ),
                child: Column(
                  children: [
                    if (_isConnected) ...[
                      const Text(
                        "ESCANEANDO...",
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "$_secondsRemaining s", // TIEMPO RESTANTE
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Tiempo Restante",
                        style: TextStyle(color: Colors.white54),
                      ),
                    ] else ...[
                      const Icon(
                        Icons.bluetooth_searching,
                        size: 60,
                        color: Colors.white54,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Selecciona tu dispositivo para iniciar",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --- Datos en Vivo ---
              if (_isConnected)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF333333),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildLiveValue(
                          "Temperatura",
                          "$_currentTemp °C",
                          Icons.thermostat,
                        ),
                        _buildLiveValue(
                          "Ritmo Cardíaco",
                          "$_currentHeartRate BPM",
                          Icons.favorite,
                        ),
                        // CAMBIO: Etiqueta e Ícono actualizados
                        _buildLiveValue(
                          "Frec. Respiratoria",
                          _currentRespRate.toStringAsFixed(1),
                          Icons.air,
                        ),
                      ],
                    ),
                  ),
                )
              // --- Lista de Dispositivos (Solo si no está conectado) ---
              else
                Expanded(
                  child: _devicesList.isEmpty
                      ? Center(
                          child: ElevatedButton(
                            onPressed: _loadBondedDevices,
                            child: const Text("Buscar Dispositivos"),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _devicesList.length,
                          itemBuilder: (context, index) {
                            final device = _devicesList[index];
                            return Card(
                              color: Colors.grey[900],
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: ListTile(
                                title: Text(
                                  device.name ?? "Desconocido",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  device.address,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                trailing: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF004AAD),
                                  ),
                                  onPressed: _isConnecting
                                      ? null
                                      : () => _connect(device),
                                  child: const Text(
                                    "Conectar",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiveValue(String label, String value, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF004AAD)),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
