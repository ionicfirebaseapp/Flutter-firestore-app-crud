import 'package:flutter/material.dart';
import 'package:online_grocery/screens/pages/home.dart';
import 'package:online_grocery/styles/styles.dart' as prefix0;
import '../../styles/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' show json;
import 'package:http/http.dart' as http;
import 'package:flutter/animation.dart';
import 'dart:math' as math;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AuthenticationPage extends StatefulWidget {
  final String popupType;
  AuthenticationPage({Key key, this.popupType}) : super(key: key);
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage>
    with TickerProviderStateMixin {
  Animation animation,
      delayedAnimation,
      muchDelayedAnimation,
      verymuchDelayedAnimation,
      mostDelayedAnimation,
      buttomAnimation,
      tabsAnimation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    popupType = widget.popupType;
    animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    animation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.easeInCubic));
    delayedAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.3, 1.0, curve: Curves.fastLinearToSlowEaseIn)));
    muchDelayedAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.4, 1.0, curve: Curves.fastLinearToSlowEaseIn)));
    verymuchDelayedAnimation = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.5, 1.0, curve: Curves.fastLinearToSlowEaseIn)));
    mostDelayedAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.6, 1.0, curve: Curves.easeInOutQuad)));
    buttomAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.6, 1.0, curve: Curves.easeOutBack)));
    tabsAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastLinearToSlowEaseIn));
    animationController.forward();
  }

  String popupType;

  final _loginKey = GlobalKey<FormState>();
  final _registrationKey = GlobalKey<FormState>();
  bool register = false;
  bool login = false;
  String password, loginPass, loginEmail;
  bool _value = false;
  bool loading = false;
  String email, name, phone;
  var authResult;

  var _alignment = Alignment.bottomCenter;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  final facebookLogin = FacebookLogin();

  fbLoginUser(
    id,
    name,
    email,
  ) async {
    var authData = {
      'facebookId': id,
      'name': name,
    };

    var data = json.encode(authData);

    print(json.encode(authData));

    print("facebook..............................$data");
  }

  static final FacebookLogin facebookSignIn = new FacebookLogin();

  String message = 'Log in/out by pressing the buttons below.';

  bool fbLog = false;

  putData(accessToken, data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      loading = true;
    });

    await fbLoginUser(accessToken.userId, data['name'], data['email'])
        .then((response) {
//      var resData = json.decode(response.body);

//      print('hhjjj  ${json.decode(response.body)}');

//      prefs.setString('token', resData['token']);

      // if (resData['response_code'] == 200) {

      print("data......................$data");

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
          (Route<dynamic> route) => false);

      // }
    });

    setState(() {
      loading = false;
    });
  }

  facebookLog(accessToken) async {
    await http
        .get(
            'https://graph.facebook.com/me?access_token=${accessToken.token}&fields=id,name,email,picture.type(large)')
        .then((res) {
      //    console.log('result ---' + JSON.stringify(res));

      //console.log('user image url==' + JSON.stringify(res.data.picture.data.url));

      String resp = res.body;

      var data = json.decode(resp);

      putData(accessToken, data);

      print('fb data---> $data');
    });
  }

  Future<Null> _facebookLogin() async {
    final FacebookLoginResult result = await facebookSignIn
        .logInWithReadPermissions(['public_profile, email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;

        print('token $accessToken');

        setState(() {
          fbLog = true;
        });

        await facebookLog(accessToken);

        break;

      case FacebookLoginStatus.cancelledByUser:
        print('cancel');

        await facebookSignIn.logOut();

        _showMessage('Logged out.');

        setState(() {
          fbLog = false;
        });

        _showMessage('Login cancelled by the user.');

        break;

      case FacebookLoginStatus.error:
        print('error');

        _showMessage('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');

        break;
    }
  }

  Future<Null> _facebookLogOut() async {
    await facebookSignIn.logOut();

    _showMessage('Logged out.');
  }

  void _showMessage(String message) {
    setState(() {
      message = message;
    });
  }

  LoginIn() async {
    // pref = await SharedPreferences.getInstance();
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (!_loginKey.currentState.validate() && _value != true) {
      return;
    } else {
      _loginKey.currentState.save();
      setState(() {
        loading = true;
      });
      _auth
          .signInWithEmailAndPassword(
        email: loginEmail,
        password: loginPass,
      )
          .then((user) {
        authResult = user;

        print("   jkgjijj   ${authResult.user.uid}");
        setState(() {
          pref.setString('uid', authResult.user.uid);
        });
        Toast.show("login successful", context,
            backgroundColor: Colors.teal,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
        //  Navigator.of(context).pushReplacementNamed(Recentchat.tag);
      }).catchError((e) {
        setState(() {
          loading = false;
        });
        Toast.show("Wrong Credentials", context,
            backgroundColor: Colors.teal,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);
        print(e);
      });
    }
  }

  registration() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!_registrationKey.currentState.validate()) {
      return;
    } else {
      _registrationKey.currentState.save();
      setState(() {
        loading = true;
      });
      FirebaseUser user = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((userNew) {
        authResult = userNew;
        print("$authResult");
        Firestore.instance
            .collection("users")
            .document(authResult.user.uid)
            .setData({
          'email': email,
          'name': name,
          'conatctNumber': phone
        }).then((responseData) {
//          Fluttertoast.showToast(
//              msg: "Registration Successfull",
//              toastLength: Toast.LENGTH_SHORT,
//              gravity: ToastGravity.BOTTOM,
//              timeInSecForIos: 1,
//              backgroundColor: Colors.red,
//              textColor: Colors.white,
//              fontSize: 16.0
//          );
          Toast.show("Registration Successfull", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          setState(() {});
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AuthenticationPage(
                      popupType: 'login',
                    )),
          );
        });
      }).catchError((e) {
        setState(() {
          loading = false;
        });
//        Fluttertoast.showToast(
//            msg: "$e, context",
//            toastLength: Toast.LENGTH_SHORT,
//            gravity: ToastGravity.BOTTOM,
//            timeInSecForIos: 1,
//            backgroundColor: Colors.red,
//            textColor: Colors.white,
//            fontSize: 16.0
//        );
        Toast.show("$e", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        print(e);
      });
    }
  }

  static final TwitterLogin twitterLogin = new TwitterLogin(
    consumerKey: 'MY137xVYVjAhTt51OImRBylMA',
    consumerSecret: 'UZNxQ6RFYctNSLpSb0f4agWfU4kBNDf8HRWukv5ValAqEzdt2x ',
  );

  String _message = 'Logged out.';

  void _login() async {
    final TwitterLoginResult result = await twitterLogin.authorize();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => HomePage(),
      ),
    );
    String newMessage;

    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        newMessage = 'Logged in! username: ${result.session.username}';
        break;
      case TwitterLoginStatus.cancelledByUser:
        newMessage = 'Login cancelled by user.';
        break;
      case TwitterLoginStatus.error:
        newMessage = 'Login error: ${result.errorMessage}';
        break;
    }

    setState(() {
      _message = newMessage;
    });
  }

  void _logout() async {
    await twitterLogin.logOut();

    setState(() {
      _message = 'Logged out.';
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: screenHeight,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('lib/assets/images/laptop.jpg'),
                              fit: BoxFit.fitHeight)),
                    ),
                    Container(
                      color: Colors.black38,
                      height: screenHeight,
                      width: screenWidth,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
////                    height: 160.0,
//                            child: Transform(
//                          transform: Matrix4.translationValues(
//                              animation.value * screenWidth, 0.0, 0.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    top: 80.0,
                                    bottom: 25.0,
                                    left: 30.0,
                                    right: 30.0),
                                alignment: Alignment.center,
//                  width: 216.9,
                                height: 45.0,
                                decoration: BoxDecoration(
//                            color: green,
//                          color: Color(0xFF645DB3),
                                    borderRadius: BorderRadius.circular(50.0)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 45.0,
                                      width: 110.0,
                                      margin: EdgeInsets.only(left: 5.0),
                                      decoration: BoxDecoration(
                                          color: popupType == 'login'
                                              ? green
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(25.0)),
                                      child: RawMaterialButton(
                                        onPressed: () {
                                          if (popupType == 'login') {
                                            setState(() {
                                              animationController.value;
                                            });
                                          } else {
                                            setState(() {
                                              delayedAnimation.value;
                                            });
                                          }
                                          setState(() {
                                            register = false;
                                            popupType = 'login';
                                          });
                                        },
                                        child: Text('Login',
                                            style: popupType == 'login'
                                                ? hintStyleWhitemediumPR()
                                                : hintStylesmBlackmediumPR()),
                                      ),
                                    ),
//                                 Transform(transform:  Matrix4.translationValues(tabsAnimation.value* screenWidth, 0.0, 0.0), child:
//                          new PhysicalShape(
//                            color: green,
//                            elevation: 16.0,
//                            clipper: TabClipper(
//                                radius: Tween(begin: 0.0, end: 1.0)
//                                    .animate(CurvedAnimation(
//                                    parent: animationController,
//                                    curve: Curves.fastOutSlowIn))
//                                    .value *
//                                    38.0), child:
//                                 Container(
//                                   height: 45.0,
//                                   width: 110.0,
//                                   margin: EdgeInsets.only(left: 5.0),
//                                   decoration: BoxDecoration(
//                                       color:  popupType == 'login'  ?    green: Colors.white,
//                                       borderRadius: BorderRadius.circular(25.0)
//                                   ),
//                                   child: RawMaterialButton(onPressed: (){
//                                     setState(() {
//                                       register = false;
//                                       popupType = 'login';
//                                     });
//                                   }, child: Text('Login', style: popupType == 'login' ? hintStyleWhitemediumPR() : hintStylesmBlackmediumPR()),),
//                                 ),)),
                                    Padding(
                                        padding: EdgeInsets.only(left: 10.0)),
                                    Container(
                                      height: 45.0,
                                      width: 110.0,
                                      margin: EdgeInsets.only(right: 5.0),
                                      decoration: BoxDecoration(
                                          color: popupType == 'signup'
                                              ? green
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(25.0)),
                                      child: RawMaterialButton(
                                        onPressed: () {
                                          setState(() {
                                            register = true;
                                            popupType = 'signup';
                                          });
                                        },
                                        child: Text('Register',
                                            style: popupType == 'signup'
                                                ? hintStyleWhitemediumPR()
                                                : hintStylesmBlackmediumPR()),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  height: screenHeight - 150,
                                  width: screenWidth,
                                  child: popupType == 'login'
                                      ? LoginForm()
                                      : RegistrationForm())
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
        });
  }

  Widget LoginForm() {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
        height: screenHeight,
        padding: EdgeInsets.only(top: 20.0),
        margin: EdgeInsets.only(top: 10.0),
//        decoration: BoxDecoration(
//          color: Color(0xFFF7F7F7),
//          borderRadius: new BorderRadius.only(topRight: const Radius.circular(33.0)),
//        ),
        child: Form(
          key: _loginKey,
          child: Column(
            children: <Widget>[
//              Transform(
//                transform: Matrix4.translationValues(
//                    animation.value * screenWidth, 0.0, 0.0),
//                child:
                Container(
                  width: 275,
                  margin: EdgeInsets.only(top: 0.0),
                  padding: EdgeInsets.only(left: 20.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0))),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: hintStylewhiteTextPM(),
                      border: InputBorder.none,
//                  suffixIcon: Image.asset('lib/assets/icons/phone.png')
                    ),
                    style: hintStylewhiteTextPM(),
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: green,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      loginEmail = value;
                    },
                  ),
                ),
//              ),
//              Transform(
//                transform: Matrix4.translationValues(
//                    animation.value * screenWidth, 0.0, 0.0),
//                child:
                Container(
                  width: 275,
                  margin: EdgeInsets.only(
                    top: 15.0,
                  ),
                  padding: EdgeInsets.only(left: 20.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0))),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: hintStylewhiteTextPM(),
                      border: InputBorder.none,
                    ),
                    style: hintStylewhiteTextPM(),
                    obscureText: true,
                    cursorColor: green,
                    validator: (String value) {
                      if (value.isEmpty || value.length < 6) {
                        return 'Password should be 6 digit long';
                      }
                    },
                    onSaved: (String value) {
                      loginPass = value;
                    },
                  ),
//                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 5.0, right: 5.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              setState(() {
                                _value = !_value;
                              });
                            },
                            child: Container(
                                margin:
                                    EdgeInsets.only(right: 15.0, left: 40.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xFFBBC2C3), width: 1.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: _value
                                      ? Icon(
                                          Icons.check,
                                          size: 15.0,
                                          color: prefix0.whiteText,
                                        )
                                      : Icon(
                                          Icons.check,
                                          size: 15.0,
                                          color: Colors.black.withOpacity(0.0),
                                        ),
                                )),
                          ),
                          Text(
                            'Remember me',
                            style: hintStylewhitesmalltextPM(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: RawMaterialButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot Password?',
                        style: hintStylewhitesmalltextPM(),
                      ),
                    ))
                  ],
                ),
              ),
//              Transform(
//                transform: Matrix4.translationValues(
//                    buttomAnimation.value * screenWidth, 0.0, 0.0),
//                child:
                Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 30.0),
                    width: 275.0,
                    height: 49.0,
                    decoration: BoxDecoration(
//                    border: Border.all(color: green, width: 2.0),
                        color: green,
                        borderRadius: BorderRadius.circular(23.0)),
                    child: RawMaterialButton(
                      onPressed: LoginIn,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'LOGIN',
                            style: hintStylewhitetextPSB(),
                          ),
                          new Padding(
                              padding:
                              new EdgeInsets.only(left: 5.0, right: 5.0)),
                          loading
                              ? new Image.asset(
                            'lib/assets/icons/spinner.gif',
                            width: 19.0,
                            height: 19.0,
                          )
                              : new Text(''),
                        ],
                      )
                    )
                ),
//              ),
//              Container(
//                width: buttonZoomOutAnimation.value,
//                height: buttonZoomOutAnimation.value,
//                alignment: buttonBottomCenterAnimation.value,
//                decoration: new BoxDecoration(
//                    color: buttonBottomCenterAnimation.value,
//                    shape: buttonZoomOutAnimation.value < 500 ? BoxShape.circle : BoxShape.rectangle
//                ),
//                child: new Icon(
//                  Icons.add,
//                  size: buttonZoomOutAnimation.value < 50 ? buttonZoomOutAnimation.value : 0.0,
//                  color: Colors.white,
//                ),
//              ),
              Text(
                'Or Connect With:',
                style: hintStylesmallwhitePR(),
              ),
//              Text('Connect With:'),
//              Transform(
//                transform: Matrix4.translationValues(
//                    muchDelayedAnimation.value * screenHeight, 0.0, 0.0),
//                child:
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: _facebookLogin,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            FontAwesomeIcons.facebookF,
                            color: Colors.grey.shade700,
                            size: 20.0,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => _handleSignIn(),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            FontAwesomeIcons.googlePlusG,
                            color: Colors.grey.shade700,
                            size: 20.0,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: _login,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            FontAwesomeIcons.twitter,
                            color: Colors.grey.shade700,
                            size: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
//              )
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                children: <Widget>[
//                  FlatButton(onPressed:  _facebookLogin, child:  Image.asset('lib/assets/icons/fb.png', color: green),),
//                  FlatButton(onPressed: () => _handleSignIn(), child: Image.asset('lib/assets/icons/google.png',  color:green,)),
//                  FlatButton( onPressed: _login,child: Image.asset('lib/assets/icons/twitter.png', color: green,),)
//                ],
//              ),
//              FlatButton(
//                onPressed: () => CreateUser()
//                    .then((FirebaseUser user) => print(user))
//                    .catchError((e) => print(e)),
//                child: Text('Signin with Email'),
//                color: Colors.blue,
//              ),
            ],
          ),
        ));
  }

  Widget RegistrationForm() {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Form(
        key: _registrationKey,
        child: Column(
          children: <Widget>[
            Transform(
              transform: Matrix4.translationValues(
                  delayedAnimation.value * screenWidth, 0.0, 0.0),
              child: Container(
                width: 275,
                padding: EdgeInsets.only(left: 20.0),
                margin: EdgeInsets.only(top: 20.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0))),
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Name',
                      hintStyle: hintStylewhiteTextPM(),
                      border: InputBorder.none,
                      suffixIcon: Icon(
                        Icons.face,
                        color: Colors.white,
                      )),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter the name';
                    }
                    return null;
                  },
                  onSaved: (String value) {
                    name = value;
                  },
                  style: hintStylewhiteTextPM(),
                  cursorColor: green,
                ),
              ),
            ),
            Transform(
              transform: Matrix4.translationValues(
                  muchDelayedAnimation.value * screenWidth, 0.0, 0.0),
              child: Container(
                width: 275,
                margin: EdgeInsets.only(top: 15.0),
                padding: EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0))),
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Phone Number',
                      hintStyle: hintStylewhiteTextPM(),
                      border: InputBorder.none,
                      suffixIcon: Icon(
                        Icons.phone,
                        color: Colors.white,
                      )),
                  style: hintStylewhiteTextPM(),
                  keyboardType: TextInputType.numberWithOptions(),
                  cursorColor: green,
                  validator: (value) {
                    if (value.isEmpty || value.length < 10) {
                      return 'Please enter 10 digit number';
                    }
                    return null;
                  },
                  onSaved: (String value) {
                    phone = value;
                  },
                ),
              ),
            ),
            Transform(
              transform: Matrix4.translationValues(
                  verymuchDelayedAnimation.value * screenWidth, 0.0, 0.0),
              child: Container(
                width: 275,
                margin: EdgeInsets.only(top: 15.0),
                padding: EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0))),
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: hintStylewhiteTextPM(),
                      border: InputBorder.none,
                      suffixIcon: Icon(
                        Icons.remove_red_eye,
                        color: Colors.white,
                      )),
                  style: hintStylewhiteTextPM(),
                  cursorColor: green,
                  obscureText: true,
                  validator: (String value) {
                    if (value.isEmpty || value.length < 6) {
                      return 'Password should be 6 digit long';
                    }
                  },
                  onSaved: (String value) {
                    password = value;
                  },
                ),
              ),
            ),
            Transform(
              transform: Matrix4.translationValues(
                  mostDelayedAnimation.value * screenWidth, 0.0, 0.0),
              child: Container(
                width: 275,
                margin: EdgeInsets.only(top: 15.0),
                padding: EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0))),
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: 'email',
                      hintStyle: hintStylewhiteTextPM(),
                      border: InputBorder.none,
                      suffixIcon: Icon(
                        Icons.email,
                        color: Colors.white,
                      )),
                  style: hintStylewhiteTextPM(),
                  cursorColor: green,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'email invalid';
                    }
                  },
                  onSaved: (String value) {
                    email = value;
                  },
                ),
              ),
            ),
            Transform(
              transform: Matrix4.translationValues(
                  buttomAnimation.value * screenWidth, 0.0, 0.0),
              child: Container(
                  margin: EdgeInsets.only(top: 30.0, bottom: 20.0),
                  width: 275.0,
                  height: 49.0,
                  decoration: BoxDecoration(
                      color: green, borderRadius: BorderRadius.circular(23.0)),
                  child: RawMaterialButton(
                    onPressed: registration,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'REGISTER ',
                          style: hintStylewhitetextPSB(),
                        ),
                        new Padding(
                            padding:
                            new EdgeInsets.only(left: 5.0, right: 5.0)),
                        loading
                            ? new Image.asset(
                          'lib/assets/icons/spinner.gif',
                          width: 19.0,
                          height: 19.0,
                        )
                            : new Text(''),
                      ],
                    )
                  )),
            )

//                              Padding(padding: EdgeInsets.only(top:40.0), child:  BottomBar(),)
          ],
        ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn().then((res) {
        print("$res");
        Firestore.instance.collection("users").document(res.id).setData({
          "name": res.displayName,
          "email": res.email,
          "image": res.photoUrl,
          "phone": ""
        }).then((user) {
          print("Logged In Succesfully ");
          Navigator.pop(context);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => HomePage(),
            ),
          );
        }).catchError((e) {});
      }).catchError((e) {});
    } catch (error) {
      print(error);
    }
  }

  Future<FirebaseUser> CreateUser() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }
}

class TabClipper extends CustomClipper<Path> {
  final double radius;
  TabClipper({this.radius = 38.0});

  @override
  Path getClip(Size size) {
    final path = Path();

    final v = radius * 2;
    path.lineTo(0, 0);
    path.arcTo(Rect.fromLTWH(0, 0, radius, radius), degreeToRadians(180),
        degreeToRadians(90), false);
    path.arcTo(
        Rect.fromLTWH(
            ((size.width / 2) - v / 2) - radius + v * 0.04, 0, radius, radius),
        degreeToRadians(270),
        degreeToRadians(70),
        false);

    path.arcTo(Rect.fromLTWH((size.width / 2) - v / 2, -v / 2, v, v),
        degreeToRadians(160), degreeToRadians(-140), false);

    path.arcTo(
        Rect.fromLTWH((size.width - ((size.width / 2) - v / 2)) - v * 0.04, 0,
            radius, radius),
        degreeToRadians(200),
        degreeToRadians(70),
        false);
    path.arcTo(Rect.fromLTWH(size.width - radius, 0, radius, radius),
        degreeToRadians(270), degreeToRadians(90), false);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TabClipper oldClipper) => true;

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}
