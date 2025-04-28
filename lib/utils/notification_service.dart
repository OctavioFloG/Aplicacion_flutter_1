import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final notificationPlugin = FlutterLocalNotificationsPlugin();

  // Initialize notification plugin
  Future<void> initialize() async {
    // Configuración de Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuración de iOS
    // const DarwinInitializationSettings initializationSettingsIOS =
    //     DarwinInitializationSettings(
    //   requestAlertPermission: true,
    //   requestBadgePermission: true,
    //   requestSoundPermission: true,
    // );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsIOS,
    );

    // Inicializar plugin y zonas horarias
    await notificationPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();

    // Solicitar permisos explícitamente
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    if (!kIsWeb) {
      // Solicitar permisos para Android 13 (API level 33) y superior
      final platform = notificationPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (platform != null) {
        await platform.requestNotificationsPermission();
        await platform.requestExactAlarmsPermission();
      }
    }
  }

  // Setup de los detalles de la notificación
  NotificationDetails notificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'schedule_venta_id',
        'Venta Notification',
        channelDescription: 'Notificación de venta programada',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        icon: '@mipmap/ic_launcher',
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        color: Colors.green,
        visibility: NotificationVisibility.public,
      ),
      // iOS: const DarwinNotificationDetails(
      //   presentAlert: true,
      //   presentBadge: true,
      //   presentSound: true,
      // ),
    );
  }

  // Mostrar la notificación
  Future<void> scheduleVentaNotification(
    int idVenta,
    String titulo,
    String descripcion,
    DateTime fechaEntrega,
  ) async {
    // Calcular fecha 2 días antes
    final fechaNotificacion = fechaEntrega.subtract(const Duration(days: 2));
    
    // Solo programar si la fecha es futura
    if (fechaNotificacion.isAfter(DateTime.now())) {
      await notificationPlugin.zonedSchedule(
        idVenta,
        titulo,
        descripcion,
        tz.TZDateTime.from(fechaNotificacion, tz.local),
        notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  // Método de prueba para notificación rápida
  // Future<void> testNotification() async {
  //   try {
  //     final fechaNotificacion = DateTime.now().add(const Duration(minutes: 1));
      
  //     // Inicializar antes de programar la notificación
  //     await initialize();
      
  //     await notificationPlugin.zonedSchedule(
  //       0,
  //       'Notificación de Prueba',
  //       'Esta es una notificación de prueba (1 minuto)',
  //       tz.TZDateTime.from(fechaNotificacion, tz.local),
  //       notificationDetails(),
  //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //     );
      
  //     // Usar debugPrint en lugar de escribir en archivo
  //     debugPrint('✅ Notificación programada exitosamente');
  //     debugPrint('📅 Fecha programada: ${fechaNotificacion.toString()}');
  //   } catch (e, stackTrace) {
  //     // Logging mejorado de errores
  //     debugPrint('❌ Error al programar la notificación:');
  //     debugPrint('Error: $e');
  //     debugPrint('Stack trace: $stackTrace');
  //   }
  // }
}
