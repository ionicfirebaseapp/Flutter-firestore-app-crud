//import 'package:flutter/material.dart';
//import '../../styles/styles.dart';
//import 'authentication.dart';
//import 'loginForm.dart';
//import 'registrationForm.dart';
//
//class WelcomePage extends StatefulWidget {
//  static String tag = 'welcome-page';
//  WelcomePage({Key key}) : super(key: key);
//
//  @override
//  _WelcomePageState createState() => new _WelcomePageState();
//}
//
//class _WelcomePageState extends State<WelcomePage> {
//  @override
//
//  Widget build(BuildContext context) {
//    var screenWidth = MediaQuery.of(context).size.width;
//    var screenHeight = MediaQuery.of(context).size.height;
//    return Scaffold(
////      backgroundColor: Color(0xFFf7f7f7),
//      body:
//      Container(
//        width: screenWidth,
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          crossAxisAlignment: CrossAxisAlignment.center,
//          children: <Widget>[
//          Image.asset('lib/assets/icons/logo.jpg'),
//
//          ],
//        ),
//      ),
//      bottomNavigationBar: Container(
//        height: 180.0,
////        color: primary,
//        child: Column(
//          children: <Widget>[
//            Container(
//              margin: EdgeInsets.only(bottom: 20.0, top: 40.0),
//              width:screenWidth-90,
//              height: 45.0,
//              decoration: BoxDecoration(
//                  color: green,
//                  borderRadius: BorderRadius.circular(25.0)
//              ),
//              child: RawMaterialButton(onPressed: (){
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                    builder: (BuildContext context) => AuthenticationPage(),
//                  ),
//                );
//              }, child: Text('LOGIN', style: hintStylewhitetextPSB(),),),
//            ),
//            Container(
//              width:screenWidth-90.0,
//              height: 45.0,
//              decoration: BoxDecoration(
//                  color: Color(0xFF0C0D0E),
//                  borderRadius: BorderRadius.circular(25.0)
//              ),
//              child: RawMaterialButton(onPressed: (){
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                    builder: (BuildContext context) => AuthenticationPage(),
//                  ),
//                );
//              }, child: Text('SIGN UP', style: hintStylewhitetextPSB(),),),
//            )
//          ],
//        ),
//      ),
//    );
//
//  }
//
//}


import 'package:flutter/material.dart';
import 'dart:async';

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({Key key, this.buttonController}): buttonSqueezeanimation = new Tween(
    begin: 320.0,
    end: 70.0,
  ).animate(
    new CurvedAnimation(
      parent: buttonController,
      curve: new Interval(
        0.0,
        0.150,
      ),
    ),
  ),
        buttomZoomOut = new Tween(
          begin: 70.0,
          end: 1000.0,
        )
            .animate(
          new CurvedAnimation(
            parent: buttonController,
            curve: new Interval(
              0.550,
              0.999,
              curve: Curves.bounceOut,
            ),
          ),
        ),
        containerCircleAnimation = new EdgeInsetsTween(
          begin: const EdgeInsets.only(bottom: 50.0),
          end: const EdgeInsets.only(bottom: 0.0),
        )
            .animate(
          new CurvedAnimation(
            parent: buttonController,
            curve: new Interval(
              0.500,
              0.800,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  final AnimationController buttonController;
  final Animation<EdgeInsets> containerCircleAnimation;
  final Animation buttonSqueezeanimation;
  final Animation buttomZoomOut;

  Future<Null> _playAnimation() async {
    try {
      await buttonController.forward();
      await buttonController.reverse();
    } on TickerCanceled {}
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return new Padding(
      padding: buttomZoomOut.value == 70
          ? const EdgeInsets.only(bottom: 50.0)
          : containerCircleAnimation.value,
      child: new InkWell(
          onTap: () {
            _playAnimation();
          },
          child: new Hero(
            tag: "fade",
            child: buttomZoomOut.value <= 300
                ? new Container(
                width: buttomZoomOut.value == 70
                    ? buttonSqueezeanimation.value
                    : buttomZoomOut.value,
                height:
                buttomZoomOut.value == 70 ? 60.0 : buttomZoomOut.value,
                alignment: FractionalOffset.center,
                decoration: new BoxDecoration(
                  color: const Color.fromRGBO(247, 64, 106, 1.0),
                  borderRadius: buttomZoomOut.value < 400
                      ? new BorderRadius.all(const Radius.circular(30.0))
                      : new BorderRadius.all(const Radius.circular(0.0)),
                ),
                child: buttonSqueezeanimation.value > 75.0
                    ? new Text(
                  "Sign In",
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.3,
                  ),
                )
                    : buttomZoomOut.value < 300.0
                    ? new CircularProgressIndicator(
                  value: null,
                  strokeWidth: 1.0,
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      Colors.white),
                )
                    : null)
                : new Container(
              width: buttomZoomOut.value,
              height: buttomZoomOut.value,
              decoration: new BoxDecoration(
                shape: buttomZoomOut.value < 500
                    ? BoxShape.circle
                    : BoxShape.rectangle,
                color: const Color.fromRGBO(247, 64, 106, 1.0),
              ),
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    buttonController.addListener(() {
      if (buttonController.isCompleted) {
        Navigator.pushNamed(context, "/home");
      }
    });
    return new AnimatedBuilder(
      builder: _buildAnimation,
      animation: buttonController,
    );
  }
}