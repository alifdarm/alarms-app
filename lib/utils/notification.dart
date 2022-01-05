import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_alarm_app/models/alarm.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;
  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();
  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) {
      if (payload != null) {
        print('notification payload ' + payload);
        selectNotificationSubject.add(payload);
      }
    });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      Alarm alarm) async {
    var _channelId = "1";
    var _channelName = "channel_01";
    var _channelDescription = "Alarms";

    var titleNotification = 'Alarms App';

    var androidPlatformChannelSpecifies = AndroidNotificationDetails(
        _channelId, _channelName,
        importance: Importance.max,
        priority: Priority.high, 
        ticker: 'ticker',
        visibility: NotificationVisibility.public,
        enableVibration: true,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('notification')
    );
    var iOSPlatformChannelSpecifies = IOSNotificationDetails();
    var platformChannelSpecifies = NotificationDetails(
        android: androidPlatformChannelSpecifies,
        iOS: iOSPlatformChannelSpecifies);
    await flutterLocalNotificationsPlugin.show(
        0, titleNotification, 'Alarm is Ringing. . .', platformChannelSpecifies,
        payload: json.encode(alarm.toJson()));
  }

  void configureSeelectNotificationSubject(BuildContext context)  {
    selectNotificationSubject.stream.listen((String payload) async {
      var data = Alarm.fromJson(json.decode(payload));
      await showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text("Alarm Messages"),
                content: Text("Lorem Ipsum dolor sit amet"),
              ));
    });
  }
}
