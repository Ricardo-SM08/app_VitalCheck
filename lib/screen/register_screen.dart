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
      // REGISTRO en el sistema de autenticación de Supabase (auth.users)
      final AuthResponse response = await supabase.auth.signUp(
        email: _emailController.text,
        password: _passwordController.text,
        data: {
          'nombre': _nameController.text,
        }, // guardar nombre en metadatos de auth
      );

      // CREACIÓN DE PERFIL en la tabla 'usuarios'
      if (response.user != null) {
        final user = response.user!;

        await supabase.from('usuarios').insert({
          'id': user.id,
          'nombre': _nameController.text,
        });

        // Mensaje de éxito y navegación a LoginScreen
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registro exitoso. ¡Inicia sesión!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } else {
          throw Exception(
            'Registro Auth existoso, pero la sesion no se establecio correctamente.',
          );
        }
      }
    } on AuthException catch (e) {
      // Manejo de errores específicos de autenticación (ej. email ya existe o contraseña débil)
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error de Auth: ${e.message}')));
      }
    } catch (e) {
      // Manejo de otros errores (red, error en la inserción del perfil, etc.)
      debugPrint('-- ERROR INESPERADO (SQL/DB)');
      debugPrint(e.toString());
      debugPrint('--------------------------');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error revise la terminal para el mensaje de DB'),
          ),
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
