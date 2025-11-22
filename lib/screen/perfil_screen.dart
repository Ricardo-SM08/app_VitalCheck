import 'package:flutter/material.dart';
import 'package:vital_check1/screen/home_screen.dart';

// Widget auxiliar para construir cada opción del menú
class _MenuOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuOptionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        
        // El ícono a la izquierda
        leading: Icon(
          icon,
          color: Colors.white, // Íconos blancos
          size: 30,
        ),
        
        // El texto de la opción
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        
        // La flecha a la derecha
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definición de las opciones del menú
    final List<Map<String, dynamic>> menuOptions = [
      {'icon': Icons.settings, 'title': 'Configuración', 'action': () => print('Ir a Configuración')},
      {'icon': Icons.lock, 'title': 'Privacidad', 'action': () => print('Ir a Privacidad')},
      {'icon': Icons.help_outline, 'title': 'Ayuda', 'action': () => print('Ir a Ayuda')},
      {'icon': Icons.info_outline, 'title': 'Acerca de', 'action': () => print('Ir a Acerca de')},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121212), 
      
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        foregroundColor: Colors.white, 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
            context, 
            MaterialPageRoute(
              builder: (context) => const HomeScreen(), 
            ),
          );
        },
        ),
      ),

      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFF333333), 
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                  const SizedBox(width: 20),
                  
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nombre Usuario',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Familia (Admin)', 
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const Divider(color: Colors.grey, height: 1, thickness: 0.5),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 10),
                itemCount: menuOptions.length,
                itemBuilder: (context, index) {
                  final option = menuOptions[index];
                  return _MenuOptionTile(
                    icon: option['icon'] as IconData,
                    title: option['title'] as String,
                    onTap: option['action'] as VoidCallback,
                  );
                },
              ),
            ),

            // 3. Botón de Cerrar Sesión
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 40.0, top: 20.0),
              child: SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, 
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    print('Cerrar Sesión presionado');
                  },
                  child: const Text(
                    'CERRAR SESIÓN',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}