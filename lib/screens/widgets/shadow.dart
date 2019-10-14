import 'package:flutter/material.dart';

class Shadow extends StatefulWidget {
  @override
  _ShadowState createState() => _ShadowState();
}

class _ShadowState extends State<Shadow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.0,
      decoration: BoxDecoration(boxShadow: [
        new BoxShadow(
            color: Color(0xFF518CDB).withOpacity(0.33),
            blurRadius: 30.0,
            spreadRadius: 20.0),
      ]),
    );
  }
}