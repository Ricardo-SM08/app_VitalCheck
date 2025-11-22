import 'package:flutter/material.dart';

class BienvenidaLogo extends StatefulWidget {
  const BienvenidaLogo({super.key});

  @override
  State<BienvenidaLogo> createState() => _BienvenidaLogoState();
}

class _BienvenidaLogoState extends State<BienvenidaLogo> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
          Padding(
            padding: const EdgeInsets.only(top: 60, bottom: 50),
            child: 
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0), 
                child: Image.asset(
                  'assets/images/logo.png', 
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              )
          )
      ],
    );
  }
}