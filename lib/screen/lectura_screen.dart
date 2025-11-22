import 'package:flutter/material.dart';
import 'package:vital_check1/screen/home_screen.dart';

class LecturaScreen extends StatefulWidget {
  const LecturaScreen({super.key});

  @override
  State<LecturaScreen> createState() => _LecturaScreenState();
}

class _LecturaScreenState extends State<LecturaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), 

      body: SafeArea( 
        child: Padding(
          padding: const EdgeInsets.all(20.0), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Iniciar Lectura',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30), 

              Expanded( 
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF333333), 
                    borderRadius: BorderRadius.circular(20), 
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround, 
                    children: <Widget>[
                      const Text(
                        'Realizando Lectura...', 
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30), 

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
                  onPressed: () {
                    Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(), 
                    ),
                  );
                  },
                  child: const Text(
                    'Detener',
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
    );
  }
}