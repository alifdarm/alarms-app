import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_alarm_app/views/widgets/clock_painter.dart';

class ClockWidget extends StatefulWidget {
  const ClockWidget({Key? key, this.isRealtime = true, this.dateTime})
      : super(key: key);
  final bool isRealtime;
  final DateTime? dateTime;
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
    super.initState();
    print(_dateTime.toIso8601String());
    if (widget.isRealtime) {
      Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          _dateTime = DateTime.now();
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dateTime != null) {
      _dateTime = widget.dateTime!;
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 6),
                      blurRadius: 6,
                      color: Color(0xFF364564).withOpacity(0.14))
                ]),
            child: Transform.rotate(
              angle: -pi / 2,
              child: CustomPaint(
                painter: ClockPainter(_dateTime, widget.isRealtime),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
