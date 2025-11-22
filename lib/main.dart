import 'package:flutter/material.dart';
import 'package:vital_check1/screen/bienvenida_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1F1F1F),
          foregroundColor: Colors.white,
          title: Text('VitalCheck')),
        backgroundColor: const Color(0xFF121212),
        body: BienvenidaScreen()
      ),
    );
  }
}
