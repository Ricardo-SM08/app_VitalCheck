import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vital_check1/main.dart';
import 'package:vital_check1/screen/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // --- Controladores y Estado ---
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- Función de Registro (SignUp) y Creación de Perfil ---
  Future<void> signUpUser() async {
    // 1. Validar que los campos no estén vacíos
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _nameController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, complete todos los campos.'),
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. REGISTRO en el sistema de autenticación de Supabase (auth.users)
      final AuthResponse response = await supabase.auth.signUp(
        email: _emailController.text,
        password: _passwordController.text,
        data: {'nombre': _nameController.text},
      );

      // CREACIÓN DE PERFIL en la tabla 'usuarios'
      if (response.user != null) {
        final user = response.user!;

        try {
          // Intenta insertar el perfil
          await supabase.from('usuarios').insert({
            'id': user.id,
            'nombre': _nameController.text,
          });
        } on PostgrestException catch (e) {
          // 🚨 NUEVA LÓGICA: Captura el error de CLAVE DUPLICADA (23505)
          if (e.code == '23505') {
            debugPrint(
              'Perfil ya existente (23505): Continuando con la navegación.',
            );
            // Si el perfil ya existe, no es un error fatal. Simplemente seguimos.
          } else {
            // Si es otro error de DB, lo relanzamos
            rethrow;
          }
        }

        // 2. Mensaje de éxito y navegación a LoginScreen (Paso final)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registro exitoso. ¡Inicia sesión!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      }
    } on AuthException catch (e) {
      // Manejo de errores específicos de autenticación
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error de Auth: ${e.message}')));
      }
    } catch (e) {
      // Manejo de errores generales/DB (incluyendo cualquier PostgrestException que rethrow)
      debugPrint('-- ERROR FATAL (SQL/DB) --');
      debugPrint(e.toString());
      debugPrint('---------------------------');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear perfil: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // --- Construcción del Widget ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            // Regresa a la pantalla anterior (LoginScreen o BienvenidaScreen)
            Navigator.pop(context);
          },
        ),
        title: const Text('Registro'),
        backgroundColor: const Color(0xFF1F1F1F),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 40.0),
                child: Text(
                  'Regístrate',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 30.0),
                child: Text(
                  'Crea una cuenta',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),

              // --- CAMPO NOMBRE ---
              const Text(
                'Nombre',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _nameController, // << CONECTADO
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Ejemplo. Alejandro Aceves',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                keyboardType: TextInputType.name,
              ),

              const SizedBox(height: 30.0),

              // --- CAMPO CORREO ---
              const Text(
                'Correo Electronico',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _emailController, // << CONECTADO
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'ejemplo@correo.com',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 30.0),

              // --- CAMPO CONTRASEÑA ---
              const Text(
                'Contraseña',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _passwordController, // << CONECTADO
                style: const TextStyle(color: Colors.white),
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Ingresa tu contraseña',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),

              const SizedBox(height: 50.0),

              // --- BOTÓN REGISTRARSE ---
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  // Llama a la función de registro y se deshabilita si está cargando
                  onPressed: _isLoading ? null : signUpUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004AAD),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Registrarse',
                          style: TextStyle(fontSize: 20),
                        ),
                ),
              ),

              const SizedBox(height: 50.0),
            ],
          ),
        ),
      ),
    );
  }
}
