import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:vital_check1/screen/bienvenida_screen.dart'; // Pantalla inicial
import 'package:vital_check1/screen/acceso_screen.dart'; // Pantalla principal

//Importacion temporal para el funcionamiento sin acceso a la DB

// import 'package:vital_check1/screen/home_screen.dart';

// Variable global para usar supabase en toda la app
final supabase = Supabase.instance.client;

void main() async {
  // 1. Inicialización de Flutter y DotEnv
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // 2. Inicialización de Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // Muestra un indicador de carga mientras verifica la sesión
  Widget _currentBody = const Center(
    child: CircularProgressIndicator(color: Color(0xFF004AAD)),
  );

  @override
  void initState() {
    super.initState();
    //_bypassAuthCheck();

    //Temopralmente se muestra HomeScreen para desarrollo sin DB
    // Llama a la función para verificar el estado de autenticación
    _checkAuthState();
  }

  /*--- FUNCIÓN TEMPORAL PARA SALTAR LA AUTENTICACIÓN ---

  void _bypassAuthCheck() {
    // Muestra HomeScreen directamente
    _currentBody = const HomeScreen();
    if (mounted) {
      setState(() {});
    }
  }*/

  // --- LÓGICA DE VERIFICACIÓN Y REDIRECCIÓN ---
  void _checkAuthState() {
    // Verifica el estado actual de la sesión.
    final user = supabase.auth.currentUser;

    if (user != null) {
      // Usuario logueado: Ir a AccesoScreen.
      _currentBody = const AccesoScreen();
    } else {
      // No logueado: Ir a BienvenidaScreen.
      _currentBody = const BienvenidaScreen();
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VitalCheck',
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      // Muestra la estructura de Scaffold con el contenido dinámico
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1F1F1F),
          foregroundColor: Colors.white,
          title: const Text('VitalCheck'),
        ),
        backgroundColor: const Color(0xFF121212),
        body: _currentBody,
      ),
    );
  }
}
