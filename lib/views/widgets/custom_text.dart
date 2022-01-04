import 'package:flutter/material.dart';

class NormalText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final FontWeight weight;
  const NormalText(
    {Key? key, 
      required this.text, 
      this.color = Colors.black, 
      required this.size, 
      this.weight = FontWeight.normal
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: weight
      ),
    );
  }
}
