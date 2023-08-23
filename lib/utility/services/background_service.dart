import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_service.dart';

class BackgroundService {
  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
        initialNotificationTitle: "Goal Tracking App",
        autoStartOnBoot: true,
        initialNotificationContent: "Running In Background",
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );

    if ((await service.isRunning()) != true) {
      service.startService();
    }
  }

  static bool onIosBackground(ServiceInstance service) {
    WidgetsFlutterBinding.ensureInitialized();
    DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {
        onStart(service);
      },
    );
    return true;
  }

  @pragma('vm:entry-point')
  static Future<void> onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();
    if (service is AndroidServiceInstance) {
      service.setAsForegroundService();
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });
      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }
    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    await NotificationService.initialize();
    Timer.periodic(
      const Duration(seconds: 30),
      (timer) async {
        await NotificationService.process();
        service.invoke(
          'update',
          {
            "current_date": DateTime.now().toIso8601String(),
          },
        );
      },
    );
  }
}
