//import 'package:best_flutter_ui_templates/appTheme.dart';
import 'package:flutter/material.dart';
import 'animation.dart';
import 'homelist.dart';
import '../../styles/styles.dart';
import 'authentication.dart';
import 'package:flutter/animation.dart';
class MyHomePage extends StatefulWidget {

  final VoidCallback callBack;
  final AnimationController animationController;
  final Animation animation;
  MyHomePage({Key key, this.callBack,
    this.animationController,
    this.animation}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;
//  List<HomeList> homeList = HomeList.homeList;

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);


    super.initState();
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
//          Padding(
//            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
//            child: appBar(),
//          ),
          Expanded(
            child: FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox();
                } else {
                  return  AnimatedBuilder(
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
              },
            ),
          )
        ],
      ),
    );
  }
//
//  Widget appBar() {
//    return SizedBox(
//      height: AppBar().preferredSize.height,
//      child: Row(
//        children: <Widget>[
//          Padding(
//            padding: EdgeInsets.only(top: 8, left: 8),
//            child: Container(
//              width: AppBar().preferredSize.height - 8,
//              height: AppBar().preferredSize.height - 8,
//              color: Colors.white,
//              child: Material(
//                color: Colors.transparent,
//                child: InkWell(
//                  borderRadius:
//                  new BorderRadius.circular(AppBar().preferredSize.height),
//                  child: Icon(
//                    Icons.menu,
//                    color: Colors.black
//                  ),
//                  onTap: () {},
//                ),
//              ),
//            ),
//          ),
//          Expanded(
//            child: Center(
//              child: Padding(
//                padding: const EdgeInsets.only(top: 4),
//                child: Text(
//                  "flutter ui",
//                  style: new TextStyle(
//                    fontSize: 22,
//                    color: Colors.black,
//                    fontWeight: FontWeight.w700,
//                  ),
//                ),
//              ),
//            ),
//          ),
//          Padding(
//            padding: EdgeInsets.only(top: 8, right: 8),
//            child: Container(
//              width: AppBar().preferredSize.height - 8,
//              height: AppBar().preferredSize.height - 8,
//              color: Colors.white,
//              child: Material(
//                color: Colors.transparent,
//                child: InkWell(
//                  borderRadius:
//                  new BorderRadius.circular(AppBar().preferredSize.height),
//                  child: Icon(
//                    multiple ? Icons.dashboard : Icons.view_agenda,
//                    color: Colors.black,
//                  ),
//                  onTap: () {
//                    setState(() {
//                      multiple = !multiple;
//                    });
//                  },
//                ),
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
}
