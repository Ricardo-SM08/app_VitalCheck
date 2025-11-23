import 'package:flutter/material.dart';
import 'package:vital_check1/screen/agregar_familia_screen.dart';
import 'package:vital_check1/screen/home_screen.dart';
import 'package:vital_check1/screen/indicadores_screen.dart';
import 'package:vital_check1/services/supabase_service.dart'; // Importar servicio

// --- Definición de Tipos de Datos ---
// Estructura simplificada para los datos que traeremos de Supabase
class MemberData {
  final String userId;
  final String name;
  final bool isAdmin;
  final List<Map<String, dynamic>>
  latestReadings; // Últimas lecturas del sensor

  MemberData({
    required this.userId,
    required this.name,
    required this.isAdmin,
    this.latestReadings = const [],
  });
}

// Widget auxiliar para simular el velocímetro (Sin cambios)
Widget _buildGaugeSimulator() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2.0),
    child: SizedBox(
      width: 40,
      height: 40,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueGrey.shade100,
          border: Border.all(color: Colors.blueGrey, width: 1),
        ),
        child: Center(
          child: const Icon(Icons.speed, size: 25, color: Colors.blueGrey),
        ),
      ),
    ),
  );
}

// Widget para la "Tarjeta" de cada persona
class _PersonCard extends StatelessWidget {
  final MemberData member; // Usamos el objeto de datos
  final VoidCallback onTap;

  const _PersonCard({required this.member, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Aquí puedes usar member.latestReadings para calcular el estado
    String status = member.latestReadings.isNotEmpty
        ? 'Última Temp: ${member.latestReadings.first['temperatura_celsius']}°C'
        : 'Sin datos recientes';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: const Color(0xFF333333),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 7,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${member.name} ${member.isAdmin ? "(Admin)" : ""}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                status,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFF004AAD), // Color de la marca
                    child: Icon(Icons.person, color: Colors.white, size: 35),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Aquí se pueden mapear los valores de member.latestReadings a los GaugeSimulators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildGaugeSimulator(),
                            _buildGaugeSimulator(),
                            _buildGaugeSimulator(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- CLASE PRINCIPAL ---
class FamiliaScreen extends StatefulWidget {
  const FamiliaScreen({super.key});

  @override
  State<FamiliaScreen> createState() => _FamiliaScreenState();
}

class _FamiliaScreenState extends State<FamiliaScreen> {
  late Future<List<MemberData>> _familyDataFuture;

  @override
  void initState() {
    super.initState();
    // Inicializa la carga de datos al iniciar la pantalla
    _familyDataFuture = _loadFamilyData();
  }

  // --- FUNCIÓN DE CARGA DE DATOS DESDE SUPABASE ---
  Future<List<MemberData>> _loadFamilyData() async {
    // ⚠️ Importante: Esto solo funcionará si el usuario tiene un perfil en la tabla 'usuarios'.
    try {
      // 1. Obtener la información de la familia del usuario logueado
      final List<Map<String, dynamic>> membersAndProfiles =
          await SupabaseService.fetchFamilyMembers(context);

      if (membersAndProfiles.isEmpty) {
        return []; // No hay miembros, o no hay familia creada.
      }

      // 2. Mapear los datos al formato MemberData
      return membersAndProfiles.map((member) {
        // Accedemos a los datos de la relación 'usuarios'
        final userProfile = member['usuarios'];

        // Simulación: No se trae la lectura real en este ejemplo para simplificar,
        // pero aquí se llamaría a otra función para traer la última lectura de cada userProfile['id']

        return MemberData(
          userId: member['id_usuario'],
          name: userProfile['nombre'] ?? 'Desconocido',
          isAdmin: member['es_administrador'] ?? false,
          // latestReadings: [Traer datos de registros_sensor aquí]
        );
      }).toList();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar datos familiares: ${e.toString()}'),
          ),
        );
      }
      return [];
    }
  }

  // Funciones de navegación (Sin cambios)
  void _navigateToIndicators(String name) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const IndicadoresScreen()),
    );
    print('Navegando a Indicadores de: $name');
  }

  void _navigateToAddPerson() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AgregarFamiliaScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF212121),
        elevation: 0,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        title: const Text(
          'Familia',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<MemberData>>(
        future: _familyDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final members = snapshot.data;

          // Caso 1: No hay miembros (o no hay familia)
          if (members == null || members.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No perteneces a ninguna familia.',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: _navigateToAddPerson,
                      child: const Text('Crear o Unirse a Familia'),
                    ),
                  ),
                ],
              ),
            );
          }

          // Caso 2: Mostrar la lista de miembros
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),

                // Mapear tarjetas de miembros
                ...members
                    .map(
                      (member) => _PersonCard(
                        member: member,
                        onTap: () => _navigateToIndicators(member.name),
                      ),
                    )
                    .toList(),

                const SizedBox(height: 30),

                // Botón "Agregar Persona"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFF333333),
                        foregroundColor: Colors.white,
                        side: const BorderSide(
                          color: Color(0xFF004AAD),
                          width: 3,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                      onPressed: _navigateToAddPerson,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Agregar Persona',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.add_circle_outline,
                            size: 40,
                            color: Color(0xFF004AAD),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
