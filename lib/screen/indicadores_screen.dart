import 'package:flutter/material.dart';
import 'package:vital_check1/screen/home_screen.dart';
import 'package:vital_check1/screen/sensor_detail_screen.dart';

// Color oscuro de fondo para la columna de sensores
const Color _sensorColumnBackground = Color(0xFF212121);
// Color del fondo principal
const Color _mainBackground = Colors.white;

class IndicadoresScreen extends StatefulWidget {
  // Variables para recibir los datos
  final double? avgTemp;
  final int? avgHeartRate;
  final double? avgRespRate; // NUEVO: Para frecuencia respiratoria

  const IndicadoresScreen({
    super.key,
    this.avgTemp,
    this.avgHeartRate,
    this.avgRespRate, // Opcional
  });

  @override
  State<IndicadoresScreen> createState() => _IndicadoresScreenState();
}

class _IndicadoresScreenState extends State<IndicadoresScreen> {
  // Widget para los botones de sensores
  Widget _buildSensorButton(
    BuildContext context,
    String label,
    IconData icon,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SensorDetailScreen(sensorName: label),
            ),
          );
        },
        child: Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF333333),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 5,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 30),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ), // Ajusté tamaño fuente
                textAlign: TextAlign.center,
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para simular el velocímetro
  Widget _buildGaugeSimulator(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 8),
            ),
            child: Center(
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Preparar textos
    final String tempText = widget.avgTemp != null
        ? "${widget.avgTemp} °C"
        : "--";
    final String heartText = widget.avgHeartRate != null
        ? "${widget.avgHeartRate} BPM"
        : "--";
    final String respText = widget.avgRespRate != null
        ? "${widget.avgRespRate}"
        : "--";

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 91, 89, 89),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 35,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                  ),
                  const Text(
                    'Resultados',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 45),
                ],
              ),
            ),

            Expanded(
              child: Row(
                children: [
                  // COLUMNA IZQUIERDA: Botones (AHORA SON 3)
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    color: _sensorColumnBackground,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSensorButton(
                          context,
                          'Temperatura',
                          Icons.thermostat,
                          tempText,
                        ),
                        _buildSensorButton(
                          context,
                          'Ritmo Cardíaco',
                          Icons.favorite,
                          heartText,
                        ),
                        _buildSensorButton(
                          context,
                          'Frec. Respiratoria',
                          Icons.air,
                          respText,
                        ),
                      ],
                    ),
                  ),

                  // COLUMNA DERECHA: Gráficos (AHORA SON 3)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildGaugeSimulator("Temp", tempText, Colors.orange),
                          _buildGaugeSimulator("Ritmo", heartText, Colors.red),
                          _buildGaugeSimulator("Resp", respText, Colors.blue),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
