import 'package:flutter/material.dart';
import 'package:vital_check1/screen/home_screen.dart';
import 'package:vital_check1/screen/login_screen.dart';

class AccesoScreen extends StatefulWidget {
  const AccesoScreen({super.key});

  @override
  State<AccesoScreen> createState() => _AccesoScreenState();
}

class _AccesoScreenState extends State<AccesoScreen> {
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
        title: const Text('Acceso'), 
        backgroundColor: const Color(0xFF1F1F1F), 
        foregroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, 
        children: [
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
          
          // 2. Botón INICIAR
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
                  onPressed: (){
                    Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                    );
                  },
                  child: const Text(
                    'INICIAR', 
                    style: TextStyle(fontSize: 18)
                  ), 
                )
              )
            ],
          )
        ],
      ),
    );
  }
}