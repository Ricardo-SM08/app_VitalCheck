import 'package:flutter/material.dart';
import 'package:vital_check1/screen/familia_screen.dart';

class AgregarFamiliaScreen extends StatelessWidget {
  const AgregarFamiliaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF212121),
        elevation: 0,
        foregroundColor: Colors.white,
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
                  'Ingresa el link de la persona que deseas añadir',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                const Text(
                  'Link',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                const TextField(
                  style: TextStyle(color: Colors.black), 
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Pega el link aquí...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide.none, 
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 15.0),
                  ),
                  keyboardType: TextInputType.url,
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
                    onPressed: () {
                      Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => const FamiliaScreen(), 
                    ),
                  );
                    },
                    child: const Text(
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