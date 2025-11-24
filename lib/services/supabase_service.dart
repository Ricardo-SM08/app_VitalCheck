import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vital_check1/main.dart'; // Para acceder a la variable global 'supabase'
import 'package:vital_check1/screen/bienvenida_screen.dart'; // Para la navegación de logout

class SupabaseService {
  // --- FUNCIÓN DE CERRAR SESIÓN ---
  // Ejecuta el signOut y maneja la navegación a la BienvenidaScreen.
  static Future<void> signOut(BuildContext context) async {
    await supabase.auth.signOut();

    // Si la sesión se cierra, navegamos a la pantalla de bienvenida.
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const BienvenidaScreen()),
        (Route<dynamic> route) => false, // Limpia el stack de navegación
      );
    }
  }

  static Future<String?> createFamily(
    BuildContext context,
    String familyName,
  ) async {
    try {
      final userId = supabase.auth.currentUser!.id;

      // 1. Insertar en la tabla 'familias' y devolver el registro creado (select)
      final response = await supabase
          .from('familias')
          .insert({'nombre_familia': familyName, 'creador_id': userId})
          .select()
          .single(); // Obtenemos un solo resultado

      // 2. Obtener el ID de la nueva familia
      final newFamilyId = response['id'];

      // 3. Añadir al creador como administrador en 'miembros_familia'
      await supabase.from('miembros_familia').insert({
        'id_familia': newFamilyId,
        'id_usuario': userId,
        'es_administrador': true,
        'invitacion_aceptada': true,
      });

      return null; // Null significa éxito (sin errores)
    } catch (e) {
      return e.toString(); // Devuelve el mensaje de error
    }
  }

  // --- FUNCIÓN DE INSERCIÓN DE DATOS DE SENSORES ---
  // Usada por LecturaScreen.dart (no está en HomeScreen, pero es parte del servicio).
  static Future<void> insertSensorData(BuildContext context) async {
    try {
      final userId = supabase.auth.currentUser!.id;

      // Valores simulados de los sensores
      const temperatura = 37.0;
      const ritmoCardiaco = 75;
      const accX = 0.8;
      const accY = 0.5;
      const accZ = 0.2;

      await supabase.from('registros_sensor').insert({
        'id_usuario': userId,
        'frecuencia_cardiaca': ritmoCardiaco,
        'temperatura_celsius': temperatura,
        'aceleracion_x': accX,
        'aceleracion_y': accY,
        'aceleracion_z': accZ,
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Datos de sensor insertados! (Vía Service)'),
          ),
        );
      }
    } on PostgrestException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('⚠️ Error DB/RLS (Service): ${e.message}')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error inesperado (Service): ${e.toString()}'),
          ),
        );
      }
    }
  }

  static Future<List<Map<String, dynamic>>> fetchFamilyMembers(
    BuildContext context,
  ) async {
    try {
      final userId = supabase.auth.currentUser!.id;

      // Consulta avanzada (JOIN implícito):
      // 1. Busca la familia a la que pertenece el usuario logueado (RLS se encarga de esto)
      // 2. Luego selecciona todos los miembros de esa(s) familia(s)
      // 3. Hace un join con la tabla 'usuarios' (profiles) para obtener el nombre
      final data = await supabase
          .from('miembros_familia')
          // Selecciona todos los campos de miembros_familia, y luego el nombre del perfil
          .select('id_usuario, es_administrador, usuarios(nombre, email)')
          .neq('invitacion_aceptada', false); // Solo miembros activos

      return data;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar miembros: ${e.toString()}')),
        );
      }
      // En caso de error (ej. usuario sin perfil), devuelve una lista vacía
      return [];
    }
  }
}
