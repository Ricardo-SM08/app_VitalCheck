import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vital_check1/main.dart'; // Para acceder a supabase
import 'package:vital_check1/screen/home_screen.dart';

class LecturaScreen extends StatefulWidget {
  const LecturaScreen({super.key});

  @override
  State<LecturaScreen> createState() => _LecturaScreenState();
}

class _LecturaScreenState extends State<LecturaScreen> {
  // --- FUNCIÓN DE INSERCIÓN DE DATOS DE SENSORES ---
  Future<void> insertSensorData() async {
    try {
      // 🚨 Obtener el ID del usuario actual.
      // ⚠️ Esto podría fallar si estás haciendo bypass de login y no hay sesión.
      final userId = supabase.auth.currentUser!.id;

      // Valores simulados de los sensores (idealmente, obtenidos de la lectura real)
      const temperatura = 37.0;
      const ritmoCardiaco = 75;
      const accX = 0.8;
      const accY = 0.5;
      const accZ = 0.2;

      await supabase.from('registros_sensor').insert({
        'id_usuario': userId,
        'frecuencia_cardiaca': ritmoCardiaco,
        'temperatura_celsius': temperatura,
        'aceleracion_x': accX,
        'aceleracion_y': accY,
        'aceleracion_z': accZ,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Lectura guardada con éxito!')),
        );
      }
    } on PostgrestException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('⚠️ Error DB/RLS al guardar: ${e.message}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ Error inesperado: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Iniciar Lectura',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF333333),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        'Realizando Lectura...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004AAD),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  // 🚨 Conexión de la función de Inserción
                  onPressed: () async {
                    // 1. Insertar datos en la base de datos
                    await insertSensorData();

                    // 2. Regresar a la pantalla de inicio
                    if (mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Detener',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
