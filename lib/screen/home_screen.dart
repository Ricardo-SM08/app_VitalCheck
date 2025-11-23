import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vital_check1/screen/acceso_screen.dart';
import 'package:vital_check1/screen/familia_screen.dart';
import 'package:vital_check1/screen/indicadores_screen.dart';
import 'package:vital_check1/screen/lectura_screen.dart';
import 'package:vital_check1/screen/perfil_screen.dart';
// Importamos el nuevo servicio
import 'package:vital_check1/services/supabase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // La función signOut local ha sido eliminada y reemplazada por la llamada al servicio.

  // --- Diálogo de Confirmación de Salida de la App ---
  // Esta función no necesita el servicio, ya que solo maneja la salida de la aplicación (SystemNavigator.pop)
  Future<void> _showExitConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF333333),
          title: const Text(
            'Confirmación',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            '¿Seguro que desea salir de la aplicación?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                SystemNavigator.pop();
              },
              child: const Text('Aceptar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            // Regresa a AccesoScreen, manteniendo la sesión activa
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AccesoScreen()),
            );
          },
        ),
        title: const Text(
          'VitalCheck',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PerfilScreen()),
              );
            },
          ),
          // 🚪 Botón de Cierre de Sesión explícito (Llama al servicio)
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            // 🚨 USAMOS EL SERVICIO DE SUPABASE DIRECTAMENTE 🚨
            onPressed: () => SupabaseService.signOut(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 40.0, bottom: 20.0),
              child: Text(
                '¿Qué deseas hacer?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 20.0,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(
                  'assets/images/home.jpg',
                  width: 350,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            _buildButtonColumn(),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonColumn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              // Botón Iniciar Lectura (Aquí la LecturaScreen usará el servicio para guardar)
              Expanded(
                child: _buildActionButton(
                  text: 'Iniciar Lectura',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LecturaScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 20),
              // Botón Indicadores
              Expanded(
                child: _buildActionButton(
                  text: 'Indicadores',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const IndicadoresScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: <Widget>[
              // Botón Familia
              Expanded(
                child: _buildActionButton(
                  text: 'Familia',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FamiliaScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 20),
              // Botón Salir de la App
              Expanded(
                child: _buildActionButton(
                  text: 'Salir de la App',
                  onPressed: _showExitConfirmationDialog,
                  color: const Color(0xFF004AAD),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onPressed,
    double height = 100,
    Color color = const Color(0xFF004AAD),
  }) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
