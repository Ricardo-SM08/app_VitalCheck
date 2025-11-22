import 'package:flutter/material.dart';
import 'package:vital_check1/screen/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
              builder: (context) => const LoginScreen(), 
            ),
          );
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
                    fontWeight: FontWeight.bold 
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 30.0),
                child: Text(
                  'Crea una cuenta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const Text(
                'Nombre',
                style: TextStyle(fontSize: 18, color: Colors.white), 
              ),
              const SizedBox(height: 8.0),
              const TextField(
                style: TextStyle(color: Colors.white), 
                decoration: InputDecoration(
                  hintText: 'Ejemplo. Alejandro Aceves',
                  hintStyle: TextStyle(color: Colors.grey), 
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
                keyboardType: TextInputType.name,
              ),

              const SizedBox(height: 30.0), 

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
                'Contraseña',
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
                child: ElevatedButton(onPressed: () {
                    Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    );
                },
                  child: const Text('Registratarse', style: TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004AAD),
                    foregroundColor: Colors.white,
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