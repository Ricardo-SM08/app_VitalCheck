import 'package:flutter/material.dart';
import 'package:vital_check1/main.dart';
import 'package:vital_check1/screen/home_screen.dart';
import 'package:vital_check1/screen/bienvenida_screen.dart';

class AccesoScreen extends StatefulWidget {
  const AccesoScreen({super.key});

  @override
  State<AccesoScreen> createState() => _AccesoScreenState();
}

class _AccesoScreenState extends State<AccesoScreen> {
  // --- FUNCIÓN DE CERRAR SESIÓN ---
  Future<void> signOut() async {
    // Llama al método de cierre de sesión de Supabase
    await supabase.auth.signOut();

    // Redirige al usuario a la pantalla de bienvenida y limpia el historial de navegación
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const BienvenidaScreen(),
        ), // Redirige a Bienvenida
        (Route<dynamic> route) => false, // Elimina todas las rutas anteriores
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        // Cambiamos el botón "leading" (atrás) por el botón de Cerrar Sesión
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: signOut, // Llama a la función de cerrar sesión
        ),
        title: const Text('Acceso'),
        backgroundColor: const Color(0xFF1F1F1F),
        foregroundColor: Colors.white,
        // Eliminamos el botón de flecha que estaba en leading, ya que no debe regresar al login.
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 1. Título BIENVENIDO
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Text(
                  'BIENVENIDO',
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          // Botón INICIAR (Navega a HomeScreen)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 220,
                height: 80,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004AAD),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                  child: const Text('INICIAR', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
