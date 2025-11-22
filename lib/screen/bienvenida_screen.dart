import 'package:flutter/material.dart';
import 'package:vital_check1/components/bienvenida_boton.dart';
import 'package:vital_check1/components/bienvenida_logo.dart';
import 'package:vital_check1/components/bienvenida_titulo.dart';

class BienvenidaScreen extends StatefulWidget {
  const BienvenidaScreen({super.key});

  @override
  State<BienvenidaScreen> createState() => _BienvenidaScreenState();
}

class _BienvenidaScreenState extends State<BienvenidaScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BienvenidaLogo(),
        BienvenidaTitulo(),
        BienvenidaBoton()
      ],
    );
  }
}