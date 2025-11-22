import 'package:flutter/material.dart';
import 'package:vital_check1/main.dart';
import 'package:vital_check1/screen/acceso_screen.dart';
import 'package:vital_check1/screen/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white), 
          onPressed: () {
            Navigator.pushReplacement(
            context, 
            MaterialPageRoute(
              builder: (context) => const MainApp(), 
            ),
          );
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
                    fontWeight: FontWeight.bold 
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 30.0),
                child: Text(
                  'Ingresa a tu cuenta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const Text(
                'Correo Electronico',
                style: TextStyle(fontSize: 18, color: Colors.white), 
              ),
              const SizedBox(height: 8.0), 
              const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'ejemplo@correo.com',
                  hintStyle: TextStyle(color: Colors.grey), 
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 30.0), 

              const Text(
                'Contrasena',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 8.0),
              const TextField(
                style: TextStyle(color: Colors.white), 
                obscureText: true, 
                decoration: InputDecoration(
                  hintText: 'Ingresa tu contraseña',
                  hintStyle: TextStyle(color: Colors.grey), 
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
              ),

              const SizedBox(height: 50.0),

              SizedBox(
                height: 50, 
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => const AccesoScreen(),
                      ),
                    );
                  },
                  child: const Text('Iniciar Sesion', style: TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004AAD), 
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0), 
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50.0), 

              const Text(
                'Ya tienes cuenta?',
                style: TextStyle(fontSize: 18, color: Colors.white), 
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 15.0), 

              SizedBox(
                height: 50,
                child: OutlinedButton(onPressed: () {
                    Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                    );
                },
                  child: const Text('Registratate', style: TextStyle(fontSize: 20)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF004AAD), 
                    side: const BorderSide(color: Color(0xFF004AAD), width: 2), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0), 
                    ),
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