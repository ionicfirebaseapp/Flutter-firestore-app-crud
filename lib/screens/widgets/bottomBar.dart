import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.only(bottom: 10.0, left: 110.0, right: 110.0),
//        width: 60.0,
      height: 4.0,
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.14),
          borderRadius: BorderRadius.circular(25.0)

      ),
    );
  }
}
