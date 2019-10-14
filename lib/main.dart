import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/auth/welcome_page.dart';
import 'styles/styles.dart';
import 'screens/auth/homescreen.dart';
import 'screens/auth/new-page.dart';

void main() async {
  runApp(new MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//    systemNavigationBarColor: Colors.blue,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light

  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final routes = <String, WidgetBuilder>{
//    WelcomePage.tag: (context) => WelcomePage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
//        accentColor: primary,
        cursorColor: Colors.black,
//        backgroundColor: primary,
        unselectedWidgetColor: Colors.grey,
      ),
      home: NewPage(),
      routes: routes,
    );
  }
}
