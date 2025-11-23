import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vital_check1/main.dart';
import 'package:vital_check1/screen/acceso_screen.dart';
import 'package:vital_check1/screen/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // --- 1. Controladores y Estado ---
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- Función de Inicio de Sesión con Supabase ---
  Future<void> loginUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Intenta iniciar sesión con email y contraseña
      final AuthResponse response = await supabase.auth.signInWithPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Si hay un usuario en la respuesta, fue exitoso.
      if (response.user != null && mounted) {
        // ÉXITO: Navegar a la pantalla de acceso
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AccesoScreen()),
        );
      }
    } on AuthException catch (e) {
      // Manejo de errores de autenticación (ej. credenciales inválidas)
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
      }
    } catch (e) {
      // Manejo de otros errores (red, etc.)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ocurrió un error inesperado.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Desactiva el estado de carga
        });
      }
    }
  }

  // --- Construcción del Widget (con Controladores y Botón) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Inicio de Sesión'),
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
                  'Inicio de Sesion',
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
                  'Ingresa a tu cuenta',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
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
                'Contrasena',
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

              // --- BOTÓN INICIAR SESIÓN ---
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  // Llama a la función de login y se deshabilita si está cargando
                  onPressed: _isLoading ? null : loginUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004AAD),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        ) // Indicador de carga
                      : const Text(
                          'Iniciar Sesion',
                          style: TextStyle(fontSize: 20),
                        ),
                ),
              ),

              const SizedBox(height: 50.0),

              // ... (Botón de registro) ...
              const Text(
                '¿No tienes cuenta?', // Corregida la pregunta
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 15.0),

              SizedBox(
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const RegisterScreen(), // Navega a Register
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF004AAD),
                    side: const BorderSide(color: Color(0xFF004AAD), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  child: const Text(
                    'Regístrate',
                    style: TextStyle(fontSize: 20),
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
