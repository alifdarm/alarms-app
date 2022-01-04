import 'dart:async';


import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alarm_app/controllers/alarm_provider.dart';
import 'package:flutter_alarm_app/utils/background_service.dart';
import 'package:flutter_alarm_app/utils/database.dart';
import 'package:flutter_alarm_app/utils/notification.dart';
import 'package:flutter_alarm_app/views/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as Env;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final NotificationHelper _notificationHelper = NotificationHelper();
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.dotenv.load(fileName: "assets/.env");
  await AndroidAlarmManager.initialize();
  // Register the UI isolate's SendPort to allow for communication from the
  // background isolate.
  BackgroundService.initializeIsolate();
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (_, __, ___) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AlarmProvider(DatabaseHelper())
          )
        ],
        child: MaterialApp(
          title: 'Alarm App',
          theme: ThemeData(
              primarySwatch: Colors.blue, fontFamily: 'SF-UI-Display'),
          home: HomePage(),
        ),
      );
    });
  }
}
