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

  // --- NUEVO: OBTENER EL ID DE LA FAMILIA DEL USUARIO ACTUAL ---
  // (Asumimos que el usuario solo gestiona una familia por ahora para simplificar)
  static Future<int?> getCurrentUserFamilyId() async {
    try {
      final userId = supabase.auth.currentUser!.id;

      // Buscamos en miembros_familia donde el usuario es admin
      final response = await supabase
          .from('miembros_familia')
          .select('id_familia')
          .eq('id_usuario', userId)
          .eq('es_administrador', true)
          .limit(1)
          .maybeSingle();

      if (response != null) {
        return response['id_familia'] as int;
      }
      return null;
    } catch (e) {
      debugPrint('Error obteniendo ID familia: $e');
      return null;
    }
  }

  // --- NUEVO: AÑADIR MIEMBRO POR CORREO ---
  static Future<String?> addMemberByEmail(
    BuildContext context,
    String email,
  ) async {
    try {
      // 1. Obtener el ID de la familia del administrador actual
      final familyId = await getCurrentUserFamilyId();

      if (familyId == null) {
        return "No eres administrador de ninguna familia o no has creado una.";
      }

      // 2. Buscar el usuario por correo en la tabla 'usuarios'
      // ⚠️ REQUISITO: Tu tabla 'usuarios' debe tener la columna 'email'.
      // Si no la tiene, esta consulta fallará.
      final userResponse = await supabase
          .from('usuarios')
          .select('id')
          .eq(
            'email',
            email,
          ) // Asegúrate que la columna se llame 'email' en la DB
          .maybeSingle();

      if (userResponse == null) {
        return "No se encontró ningún usuario con el correo $email";
      }

      final newMemberId = userResponse['id'];

      // 3. Insertar en miembros_familia
      await supabase.from('miembros_familia').insert({
        'id_familia': familyId,
        'id_usuario': newMemberId,
        'es_administrador': false, // Los invitados son miembros normales
        'invitacion_aceptada': true, // Aceptación automática para este ejemplo
      });

      return null; // Éxito
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        return "Este usuario ya pertenece a la familia.";
      }
      return "Error de base de datos: ${e.message}";
    } catch (e) {
      return e.toString();
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
      // Consulta corregida: Eliminamos 'email' del select si tu tabla usuarios no lo tiene
      // Si ya agregaste la columna email a la tabla usuarios, puedes poner: usuarios(nombre, email)
      final data = await supabase
          .from('miembros_familia')
          .select('id_usuario, es_administrador, usuarios(nombre,email)')
          .neq('invitacion_aceptada', false);

      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      debugPrint('Error al cargar miembros: $e');
      return [];
    }
  }
}
