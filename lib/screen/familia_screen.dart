import 'package:flutter/material.dart';
import 'package:vital_check1/screen/agregar_familia_screen.dart';
import 'package:vital_check1/screen/home_screen.dart';
import 'package:vital_check1/screen/indicadores_screen.dart'; 

// Widget auxiliar para simular el velocímetro (Sin cambios)
Widget _buildGaugeSimulator() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2.0), 
    child: SizedBox(
      width: 40, 
      height: 40,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueGrey.shade100, 
          border: Border.all(color: Colors.blueGrey, width: 1), 
        ),
        child: Center(
          // Se asume el uso de una imagen, si da error, usa el Icono
          // child: Image.asset('assets/images/indicador.png'), 
          child: const Icon(Icons.speed, size: 25, color: Colors.blueGrey), 
        ),
      ),
    ),
  );
}

// Widget para la "Tarjeta" de cada persona (Sin cambios)
class _PersonCard extends StatelessWidget {
  final String personName;
  final VoidCallback onTap; 

  const _PersonCard({required this.personName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: InkWell(
        onTap: onTap, 
        borderRadius: BorderRadius.circular(15), 
        child: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: const Color(0xFF333333), 
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 7,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                personName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white, size: 35),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildGaugeSimulator(),
                        _buildGaugeSimulator(),
                        _buildGaugeSimulator(),
                        _buildGaugeSimulator(),
                        _buildGaugeSimulator(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FamiliaScreen extends StatefulWidget {
  const FamiliaScreen({super.key});

  @override
  State<FamiliaScreen> createState() => _FamiliaScreenState();
}

class _FamiliaScreenState extends State<FamiliaScreen> {
  // Funciones de navegación (Sin cambios)
  void _navigateToIndicators(String name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const IndicadoresScreen(), 
      ),
    );
    print('Navegando a Indicadores de: $name');
  }
  void _navigateToAddPerson() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AgregarFamiliaScreen(), 
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), 
      appBar: AppBar(
        backgroundColor: const Color(0xFF212121), 
        elevation: 0,
        foregroundColor: Colors.white, 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(
                builder: (context) => const HomeScreen(), 
              ),
            );
         },
        ),

        title: const Text(
          'Familia',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView( 
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20), 

            // Tarjetas de personas
            _PersonCard(
              personName: 'Persona 1',
              onTap: () => _navigateToIndicators('Persona 1'),
            ),
            _PersonCard(
              personName: 'Persona 2',
              onTap: () => _navigateToIndicators('Persona 2'),
            ),

            const SizedBox(height: 30), 

            // Botón "Agregar Persona"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                height: 120, 
                width: double.infinity,
                child: OutlinedButton( 
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFF333333), 
                    foregroundColor: Colors.white, 
                    side: const BorderSide(color: Color(0xFF004AAD), width: 3), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  onPressed: _navigateToAddPerson, 
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Agregar Persona',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.add_circle_outline, size: 40, color: Color(0xFF004AAD)), 
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), 
          ],
        ),
      ),
    );
  }
}