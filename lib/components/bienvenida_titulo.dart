import 'package:flutter/material.dart';

class BienvenidaTitulo extends StatefulWidget {
  const BienvenidaTitulo({super.key});

  @override
  State<BienvenidaTitulo> createState() => _BienvenidaTituloState();
}

class _BienvenidaTituloState extends State<BienvenidaTitulo> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('VitalCheck', style: TextStyle(color: Colors.white, fontSize: 40)),
      ],
    );
  }
}
