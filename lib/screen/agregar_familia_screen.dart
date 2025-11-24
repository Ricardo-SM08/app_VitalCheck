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
    // Si NO tiene '@', asumimos que es un NOMBRE DE FAMILIA para crear.
    // Si TIENE '@', asumimos que es un CORREO para invitar.

    if (!input.contains('@')) {
      // --- CASO 1: CREAR FAMILIA ---
      // Llamamos a la función real del servicio
      error = await SupabaseService.createFamily(context, input);

      if (error == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Familia "$input" creada con éxito!')),
        );
      }
    } else {
      // --- CASO 2: INVITAR MIEMBRO (Pendiente de implementar en servicio) ---
      // Por ahora mostramos un mensaje temporal
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invitación a "$input" enviada (Simulado)')),
        );
      }
      // error = await SupabaseService.inviteMember(context, input); // Futuro
    }

    setState(() => _isLoading = false); // Desactivar carga

    // Si no hubo error, regresamos a la pantalla de Familia para ver los cambios
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
                  'Crear Familia',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                const Text(
                  'Ingresa el nombre para crear tu familia.',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                const Text(
                  'Nombre de la Familia',
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
                    hintText: 'Ej. Familia Pérez',
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
                  // Cambiado a 'text' porque es para nombres principalmente ahora
                  keyboardType: TextInputType.text,
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
                    // Si está cargando, deshabilita el botón. Si no, llama a _handleAction
                    onPressed: _isLoading ? null : _handleAction,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'CREAR',
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
