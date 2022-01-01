import 'dart:async';
import 'dart:math';

import 'package:alarms_app/views/widgets/clock_painter.dart';
import 'package:flutter/material.dart';

class ClockWidget extends StatefulWidget {
  const ClockWidget({Key? key}) : super(key: key);

  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  DateTime _dateTime = DateTime.now();
  String textTime(String hour, String minute) {
    if (hour.length == 1) {
      hour = "0$hour";
    }
    if (minute.length == 1) {
      minute = "0$minute";
    }
    return "$hour:$minute";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _dateTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow:  [
                BoxShadow(
                  offset: Offset(0, 6),
                  blurRadius: 6,
                  color: Color(0xFF364564).withOpacity(0.14)
                )
              ]
            ),
            child: Transform.rotate(
              angle: -pi/2,
              child: CustomPaint(
                painter: ClockPainter(_dateTime),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
