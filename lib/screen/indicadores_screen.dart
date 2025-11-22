import 'package:flutter/material.dart';
import 'package:vital_check1/screen/home_screen.dart';
// Asegúrate de que esta ruta de importación sea correcta en tu proyecto
import 'package:vital_check1/screen/sensor_detail_screen.dart'; 

// Color oscuro de fondo para la columna de sensores (similar al 0xFF333333)
const Color _sensorColumnBackground = Color(0xFF212121);
// Color del fondo principal (blanco) para la parte de los medidores
const Color _mainBackground = Colors.white; 

// Widget auxiliar para construir los botones de la izquierda
// CORRECCIÓN: Se añadió 'BuildContext context' y la lógica de navegación.
Widget _buildSensorButton(BuildContext context, String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    // CORRECCIÓN: Usamos InkWell para hacer el botón interactivo
    child: InkWell( 
      onTap: () {
        // Lógica de navegación a la nueva pantalla, pasando el nombre del sensor
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SensorDetailScreen(sensorName: label),
          ),
        );
      },
      child: Container(
        height: 100, // Altura del botón
        decoration: BoxDecoration(
          // La imagen del diseño original utiliza un gradiente claro. Si quieres el gris oscuro:
          color: const Color(0xFF333333), 
          borderRadius: BorderRadius.circular(15), 
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white, // Texto en blanco
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );
}

// Widget auxiliar para simular el velocímetro. 
Widget _buildGaugeSimulator() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: SizedBox(
      width: 120,
      height: 120,
      // Usamos el marcador de posición con imagen que habías definido
      child: Image.asset('assets/images/indicador.png'), // Asume que tienes el asset
    ),
  );
}


class IndicadoresScreen extends StatefulWidget {
  const IndicadoresScreen({super.key});

  @override
  State<IndicadoresScreen> createState() => _IndicadoresScreenState();
}

class _IndicadoresScreenState extends State<IndicadoresScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _mainBackground, 
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Flecha de retroceso 
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 35, color: Colors.black),
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
                    'Que tal estas?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 45), 
                ],
              ),
            ),

            Expanded(
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    padding: const EdgeInsets.only(left: 15.0, right: 20.0),
                    color: _sensorColumnBackground, 
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // CORRECCIÓN: Se pasa 'context'
                        _buildSensorButton(context, 'Sensor 1'),
                        _buildSensorButton(context, 'Sensor 2'),
                        _buildSensorButton(context, 'Sensor 3'),
                        _buildSensorButton(context, 'Sensor 4'),
                      ],
                    ),
                  ),
                  
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _buildGaugeSimulator(),
                          _buildGaugeSimulator(),
                          _buildGaugeSimulator(),
                          _buildGaugeSimulator(),
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