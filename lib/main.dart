import 'package:flutter/material.dart';
import 'package:flutter_alarm_app/views/home_page.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (_, __, ___) {
      return GetMaterialApp(
        title: 'Alarm App',
        theme:
            ThemeData(primarySwatch: Colors.blue, fontFamily: 'SF-UI-Display'),
        home: HomePage(),
      );
    });
  }
}
