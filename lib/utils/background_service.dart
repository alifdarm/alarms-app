import 'dart:isolate';

import 'dart:ui';

import 'package:flutter_alarm_app/main.dart';
import 'package:flutter_alarm_app/models/alarm.dart';
import 'package:flutter_alarm_app/utils/notification.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static SendPort? uiSendPort;
  static String _isolateName = 'isolate';
  static BackgroundService? _helper;

  BackgroundService._createObject();

  factory BackgroundService() {
    if (_helper == null) {
      _helper = BackgroundService._createObject();
    }
    return _helper!;
  }

  static void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    final NotificationHelper _notificationHelper = NotificationHelper();
    print('alarm Fired');
    await _notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, Alarm(123, DateTime.now(), "periodic", true));

    // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    uiSendPort?.send(null);
  }
}
