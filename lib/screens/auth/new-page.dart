import 'package:flutter/material.dart';
import '../../styles/styles.dart';
import 'package:flutter/animation.dart';
import 'authentication.dart';


class NewPage extends StatefulWidget{
  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> with TickerProviderStateMixin{

  AnimationController animationController;
  Animation animation, opacity, delayedAnimation, muchDelayedAnimation, verymuchDelayedAnimation, mostDelayedAnimation;

  @override
  void initState(){
    super.initState();

    animationController = AnimationController(duration: Duration(seconds: 2), vsync: this);
    animation =   Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: animationController, curve: Curves.fastLinearToSlowEaseIn));
    delayedAnimation =   Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: animationController, curve:Interval(0.3, 1.0, curve: Curves.fastLinearToSlowEaseIn)));
    muchDelayedAnimation =   Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: animationController, curve:Interval(0.4, 1.0, curve: Curves.fastLinearToSlowEaseIn)));
    verymuchDelayedAnimation =   Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: animationController, curve:Interval(0.5, 1.0, curve: Curves.fastLinearToSlowEaseIn)));
    mostDelayedAnimation =   Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: animationController, curve:Interval(0.6, 1.0, curve: Curves.fastLinearToSlowEaseIn)));
        opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          0.0,
          0.100,
          curve: Curves.ease,
        ),
      ),
    );
    animationController.forward();
  }
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return

      AnimatedBuilder(animation: animationController,
        builder: (BuildContext context, Widget child){
      return Scaffold(
        body: Container(
            alignment: Alignment.center,
            child:  Transform (transform: new Matrix4.translationValues(
                 animation.value, 0.0, 0.0), child:

                Container(
                  width: screenWidth,
                  padding: EdgeInsets.only(top: 200.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('lib/assets/icons/logo.png'),
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
            )),
      );
    });
  }
}
