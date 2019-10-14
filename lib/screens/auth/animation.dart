import 'package:flutter/material.dart';
import 'homelist.dart';
import '../../styles/styles.dart';
import 'authentication.dart';
//import 'popularCourseListView.dart';

class AnimationPage extends StatelessWidget {
  final String popupType;


//  final HomeList listData;
  final VoidCallback callBack;
  final AnimationController animationController;
  final Animation animation;

  const AnimationPage(
      {Key key,
        this.callBack,
        this.animationController,
        this.popupType,
        this.animation})
      : super(key: key);
  @override


  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return 
      
      AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 90 * (1.0 - animation.value), 0.0),

       child:
       Container(
         width: screenWidth,
         padding: EdgeInsets.only(top: 200.0),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           children: <Widget>[
             Image.asset('lib/assets/icons/logo.jpg'),
             Container(
               margin: EdgeInsets.only(bottom: 20.0, top: 100.0),
               width:screenWidth-90,
               height: 45.0,
               decoration: BoxDecoration(
                   color: green,
                   borderRadius: BorderRadius.circular(25.0)
               ),
               child: RawMaterialButton(onPressed: (){
                 Navigator.push(
                   context,
                   MaterialPageRoute(
                     builder: (BuildContext context) => AuthenticationPage(popupType: 'login',),
                   ),
                 );
               }, child: Text('LOGIN', style: hintStylewhitetextPSB(),),),
             ),
             Container(
               width:screenWidth-90.0,
               height: 45.0,
               decoration: BoxDecoration(
                   color: Color(0xFF0C0D0E),
                   borderRadius: BorderRadius.circular(25.0)
               ),
               child: RawMaterialButton(onPressed: (){
                 Navigator.push(
                   context,
                   MaterialPageRoute(
                     builder: (BuildContext context) => AuthenticationPage(popupType: 'signup'),
                   ),
                 );
               }, child: Text('SIGNUP', style: hintStylewhitetextPSB(),),),
             )
           ],
         ),
       ),
          ),
        );
      },
    );
  }


}
