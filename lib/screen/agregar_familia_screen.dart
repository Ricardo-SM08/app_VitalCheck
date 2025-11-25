import 'package:flutter/material.dart';
import 'package:vital_check1/screen/familia_screen.dart';
import 'package:vital_check1/services/supabase_service.dart'; // Importar servicio

class AgregarFamiliaScreen extends StatefulWidget {
  const AgregarFamiliaScreen({super.key});

  @override
  State<AgregarFamiliaScreen> createState() => _AgregarFamiliaScreenState();
}

class _AgregarFamiliaScreenState extends State<AgregarFamiliaScreen> {
  final _linkController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  // --- FUNCIÓN DE GESTIÓN (Crear o Añadir Miembro) ---
  Future<void> _handleAction() async {
    final input = _linkController.text.trim();

    // Validación básica
    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, escribe un nombre o correo.')),
      );
      return;
    }

    setState(() => _isLoading = true); // Activar carga

    String? error;

    // LÓGICA:
    // Si NO tiene '@', es NOMBRE DE FAMILIA para CREAR.
    // Si TIENE '@', es CORREO para INVITAR.

    if (!input.contains('@')) {
      // --- CASO 1: CREAR FAMILIA ---
      error = await SupabaseService.createFamily(context, input);

      if (error == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Familia "$input" creada con éxito!')),
        );
      }
    } else {
      // --- CASO 2: INVITAR MIEMBRO ---
      error = await SupabaseService.addMemberByEmail(context, input);

      if (error == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario "$input" añadido con éxito!')),
        );
      }
    }

    setState(() => _isLoading = false); // Desactivar carga

    // Si no hubo error, regresamos a la pantalla de Familia
    if (mounted && error == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FamiliaScreen()),
      );
    } else if (mounted && error != null) {
      // Mostrar error si falló
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $error')));
    }
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
            Navigator.pop(context); // Regresa a FamiliaScreen
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Gestión Familiar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                const Text(
                  'Escribe un nombre para CREAR una familia nueva.\nO escribe un correo (ej. usuario@mail.com) para AÑADIR a alguien a tu familia actual.',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                const Text(
                  'Nombre o Correo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _linkController, // Conectado al controlador
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Familia Pérez / juan@gmail.com',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 18.0,
                      horizontal: 15.0,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 80),

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
                    // Si está cargando, deshabilita el botón
                    onPressed: _isLoading ? null : _handleAction,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'PROCESAR',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
