import 'package:flutter/material.dart';
import '../../styles/styles.dart';

class Titles extends StatefulWidget {
  final String title;
  Titles(
      {Key key,
        this.title})
      : super(key: key);
  @override
  _TitlesState createState() => _TitlesState();
}

class _TitlesState extends State<Titles> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 1.0,
            width: 55.0,
            decoration: BoxDecoration(
              color: Colors.black
            ),
          ),
          Container(
            height: 4.0,
            width: 4.0,
            margin: EdgeInsets.only(left: 5.0, right: 5.0),
            decoration: BoxDecoration(
                color: Colors.black,
              shape: BoxShape.circle
            ),
          ),
          Text(widget.title, style: hintStyletextPM(),),
          Container(
            height: 4.0,
            width: 4.0,
            margin: EdgeInsets.only(left: 5.0, right: 5.0),
            decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle
            ),
          ),
          Container(
            height: 1.0,
            width: 55.0,
            decoration: BoxDecoration(
                color: Colors.black
            ),
          ),
        ],
      ),
    );
  }
}
