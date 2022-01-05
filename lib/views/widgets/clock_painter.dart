import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class ClockPainter extends CustomPainter {
  final DateTime dateTime;
  final bool isRealtime;

  ClockPainter(this.dateTime, this.isRealtime);

  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    Offset center = Offset(centerX, centerY);
    Paint quarterTimePaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    Paint hoursMinutePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    Paint secondsPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // clock mark for 12, 3, 6, and 9
    canvas.drawLine(Offset(10, centerY), Offset(30, centerY), quarterTimePaint);
    canvas.drawLine(Offset(centerX * 2 - 30, centerY),
        Offset(centerX * 2 - 10, centerY), quarterTimePaint);
    canvas.drawLine(Offset(centerX, 10), Offset(centerX, 30), quarterTimePaint);
    canvas.drawLine(Offset(centerX, centerY * 2 - 30),
        Offset(centerX, centerY * 2 - 10), quarterTimePaint);

    // Hours position
    double hourX = centerX +
        size.width *
            0.2 *
            cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    double hourY = centerY +
        size.width *
            0.2 *
            sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    canvas.drawLine(center, Offset(hourX, hourY), hoursMinutePaint);

    // Minute Position
    double minuteX = centerX +
        size.width *
            0.3 *
            cos((dateTime.minute + dateTime.second / 60) * 6 * pi / 180);
    double minuteY = centerY +
        size.width *
            0.3 *
            sin((dateTime.minute + dateTime.second / 60) * 6 * pi / 180);
    canvas.drawLine(center, Offset(minuteX, minuteY), hoursMinutePaint);

    if (isRealtime) {
      // Second Position
      double secondX =
          centerX + size.width * 0.35 * cos(dateTime.second * 6 * pi / 180);
      double secondY =
          centerY + size.width * 0.35 * sin(dateTime.second * 6 * pi / 180);
      canvas.drawLine(center, Offset(secondX, secondY), secondsPaint);
    }

    // Draw center points
    Paint dotPainter = Paint()..color = Colors.black;
    canvas.drawCircle(center, 4, dotPainter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
