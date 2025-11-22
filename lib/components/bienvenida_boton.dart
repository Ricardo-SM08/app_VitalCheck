import 'package:flutter/material.dart';
// Asegúrate de que esta ruta de importación sea correcta para tu proyecto
import 'package:vital_check1/screen/login_screen.dart'; 

class BienvenidaBoton extends StatefulWidget {
  const BienvenidaBoton({super.key});

  @override
  State<BienvenidaBoton> createState() => _BienvenidaBotonState();
}

class _BienvenidaBotonState extends State<BienvenidaBoton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50), 
          child: SizedBox(
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: const Text(
                'Comenzar', 
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}