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
    if (input.isEmpty) {
      return;
    }

    setState(() => _isLoading = true);

    String? error;

    // Si el input parece un nombre (no un correo), intentamos crear la familia.
    if (!input.contains('@') && !input.contains('.')) {
      // Intentar crear una nueva familia
      // ⚠️ ESTO DEBE SER IMPLEMENTADO EN SupabaseService
      // error = await SupabaseService.createFamily(context, input);

      // TEMPORAL: Simulación de creación de familia
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Intentando crear familia: "$input"...')),
      );
    } else {
      // Si parece un correo, intentar añadir a alguien por email a una familia existente
      // ⚠️ ESTO DEBE SER IMPLEMENTADO EN SupabaseService
      // Obtener el ID de la familia actual (debes buscarlo primero)
      // error = await SupabaseService.addMemberByEmail(context, familyId, input);

      // TEMPORAL: Simulación de agregar miembro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Intentando invitar a: "$input"...')),
      );
    }

    setState(() => _isLoading = false);

    // Navegar de vuelta a la lista familiar después de la acción
    if (mounted && error == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FamiliaScreen()),
      );
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
                  'Agregar Persona',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                const Text(
                  'Ingresa el nombre para crear una familia o el correo del miembro que deseas añadir.',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                const Text(
                  'Nombre / Correo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _linkController, // Conectado
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Nombre de la familia o correo@ejemplo.com',
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
                    onPressed: _isLoading
                        ? null
                        : _handleAction, // Llama a la función de gestión
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'AÑADIR',
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
