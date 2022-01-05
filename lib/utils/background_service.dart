import 'dart:isolate';

import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_alarm_app/controllers/alarm_provider.dart';
import 'package:flutter_alarm_app/main.dart';
import 'package:flutter_alarm_app/models/alarm.dart';
import 'package:flutter_alarm_app/utils/database.dart';
import 'package:flutter_alarm_app/utils/notification.dart';
import 'package:provider/provider.dart';

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
    final AlarmProvider provider = AlarmProvider(DatabaseHelper());
    print('alarm Fired');
    print("ISI LIST ALARM ${provider.alarms}");
    // final alarms = provider.alarms
    //     .where((element) =>
    //         element.alarmId == DateTime.now().hour * 60 + DateTime.now().minute).toList();
    final ringingAlarm = await provider.getAlarmById(DateTime.now().hour * 60 + DateTime.now().minute);

    if (ringingAlarm.scheduleType == "one_shot") {
      await _notificationHelper.showNotification(
          flutterLocalNotificationsPlugin, ringingAlarm);
      ringingAlarm.isRinged = false;
      await provider.updateAlarm(ringingAlarm);
    } else {
      await _notificationHelper.showNotification(
          flutterLocalNotificationsPlugin, ringingAlarm);
      print("Its periodic");
    }

    // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    uiSendPort?.send(null);
  }
}
