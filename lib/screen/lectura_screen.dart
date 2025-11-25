import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart'; // Librería Clásica
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vital_check1/main.dart'; // Para acceder a supabase
import 'package:vital_check1/screen/home_screen.dart';

class LecturaScreen extends StatefulWidget {
  const LecturaScreen({super.key});

  @override
  State<LecturaScreen> createState() => _LecturaScreenState();
}

class _LecturaScreenState extends State<LecturaScreen> {
  // --- Variables Bluetooth Clásico ---
  BluetoothConnection? connection;
  List<BluetoothDevice> _devicesList = [];
  bool _isConnecting = false;
  bool _isConnected = false;

  // Buffer para acumular datos parciales del HC-05
  String _buffer = '';

  // --- Variables de Datos ---
  double _temp = 0.0;
  int _heartRate = 0;
  double _accX = 0.0;
  double _accY = 0.0;
  double _accZ = 0.0;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _loadBondedDevices(); // Cargar dispositivos ya vinculados en el teléfono
  }

  @override
  void dispose() {
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

  // 2. Cargar dispositivos vinculados (La forma más fácil con HC-05)
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

  // 3. Conectar al HC-05
  void _connect(BluetoothDevice device) async {
    setState(() => _isConnecting = true);

    try {
      // Intentar conectar
      BluetoothConnection newConnection = await BluetoothConnection.toAddress(
        device.address,
      );

      setState(() {
        connection = newConnection;
        _isConnected = true;
        _isConnecting = false;
      });

      // Escuchar datos entrantes
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

  // 4. Procesar datos del Stream
  // El HC-05 envía bytes que pueden llegar fragmentados.
  // Acumulamos en un buffer hasta encontrar un salto de línea.
  void _onDataReceived(Uint8List data) {
    try {
      String incoming = utf8.decode(data);
      _buffer += incoming; // Acumular

      // Si hay un salto de línea, procesamos el mensaje completo
      if (_buffer.contains('\n')) {
        List<String> lines = _buffer.split('\n');

        // Procesamos todas las líneas completas excepto la última si está incompleta
        for (int i = 0; i < lines.length - 1; i++) {
          _parseSensorString(lines[i].trim());
        }

        // Guardamos el resto (fragmento incompleto) para la siguiente vuelta
        _buffer = lines.last;
      }
    } catch (e) {
      debugPrint("Error decodificando: $e");
    }
  }

  // Parsear el formato "TEMP,RITMO,X,Y,Z"
  void _parseSensorString(String dataString) {
    if (dataString.isEmpty) return;

    // Ejemplo esperado: "36.5,78,0.12,0.05,9.8"
    List<String> parts = dataString.split(',');

    if (parts.length >= 5) {
      setState(() {
        _temp = double.tryParse(parts[0]) ?? _temp;
        _heartRate = int.tryParse(parts[1]) ?? _heartRate;
        _accX = double.tryParse(parts[2]) ?? _accX;
        _accY = double.tryParse(parts[3]) ?? _accY;
        _accZ = double.tryParse(parts[4]) ?? _accZ;
      });
    }
  }

  // 5. Guardar en Supabase
  Future<void> insertSensorData() async {
    try {
      final userId = supabase.auth.currentUser!.id;

      await supabase.from('registros_sensor').insert({
        'id_usuario': userId,
        'frecuencia_cardiaca': _heartRate,
        'temperatura_celsius': _temp,
        'aceleracion_x': _accX,
        'aceleracion_y': _accY,
        'aceleracion_z': _accZ,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Datos guardados en Supabase!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Conexión HC-05"),
        backgroundColor: const Color(0xFF212121),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        actions: [
          if (_isConnected)
            IconButton(
              icon: const Icon(Icons.bluetooth_connected, color: Colors.green),
              onPressed: () {}, // Indicador visual
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // --- Panel de Datos ---
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF333333),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Datos en Tiempo Real",
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    const Divider(color: Colors.grey),
                    _buildDataRow("Temperatura", "$_temp °C", Icons.thermostat),
                    _buildDataRow("Ritmo", "$_heartRate BPM", Icons.favorite),
                    _buildDataRow(
                      "Aceleración X",
                      _accX.toStringAsFixed(2),
                      Icons.speed,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --- Lista de Dispositivos o Botones ---
              if (!_isConnected) ...[
                const Text(
                  "Dispositivos Vinculados:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "(Vincula El HC-05 desde la configuración Bluetooth del teléfono)",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 10),

                Expanded(
                  child: _devicesList.isEmpty
                      ? Center(
                          child: ElevatedButton(
                            onPressed: _loadBondedDevices,
                            child: const Text("Refrescar Lista"),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _devicesList.length,
                          itemBuilder: (context, index) {
                            final device = _devicesList[index];
                            return Card(
                              color: Colors.grey[800],
                              child: ListTile(
                                title: Text(
                                  device.name ?? "Desconocido",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  device.address,
                                  style: const TextStyle(color: Colors.white54),
                                ),
                                trailing: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF004AAD),
                                  ),
                                  onPressed: _isConnecting
                                      ? null
                                      : () => _connect(device),
                                  child: Text(
                                    _isConnecting ? "..." : "Conectar",
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ] else ...[
                const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bluetooth_audio,
                          size: 100,
                          color: Color(0xFF004AAD),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Recibiendo datos del HC-05...",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: insertSensorData,
                    child: const Text(
                      "GUARDAR EN NUBE",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      connection?.dispose();
                      setState(() => _isConnected = false);
                    },
                    child: const Text(
                      "DESCONECTAR",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF004AAD), size: 24),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
