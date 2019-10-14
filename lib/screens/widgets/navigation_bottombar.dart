import 'package:flutter/material.dart';
import 'bottomBar.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'shadow.dart';

class NavigationBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Container(
      height:90.0,
      child: Column(
        children: <Widget>[
          Shadow(),
          Container(
            height: 84.88,
            padding: EdgeInsets.only(top:30.0),
            decoration: BoxDecoration(
              color: Colors.white,
//              boxShadow: [
//                new BoxShadow(
//                  color: Colors.black.withOpacity(0.26),
//                  spreadRadius: 0.0,
//                  blurRadius: 0.0,
////              offset: const Offset(0.0, 1.0),
//                ),
//              ],
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
//                    SvgPicture.asset('lib/assets/icons/bag.svg', color: Color(0xFFb4b4b4),),
//                    SvgPicture.asset('lib/assets/icons/heart.svg', color: Color(0xFFb4b4b4),),
//                    SvgPicture.asset('lib/assets/icons/more.svg', color: Color(0xFFb4b4b4),),
//                    SvgPicture.asset('lib/assets/icons/account.svg', color: Color(0xFFb4b4b4),),

                  ],
                ),
                Padding(padding: EdgeInsets.only(top:15.0), child: BottomBar(),)
              ],
            ),
          )
        ],
      ),
    );
  }
}
