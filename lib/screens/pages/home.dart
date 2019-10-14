import 'dart:io';

import 'package:flutter/cupertino.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:online_grocery/screens/pages/updateProfile.dart';
import 'package:online_grocery/styles/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:async_loader/async_loader.dart';
import 'dart:ui';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {

  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
  new GlobalKey<AsyncLoaderState>();


  bool profileUpdate = false;
  var uid;
  String name, email, contactNumber, photo;
  String _uploadedFileURL;
  var userData;
  bool loading = false,
      loadingLogOut = false,
      isLoadingUpdateData = false,
      isImageUploading = false;
  bool accountUpdate = true;




  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getString("uid");
    });    Firestore.instance
        .collection('users')
        .document(uid)
        .get()
        .then((DocumentSnapshot) {
      print('${DocumentSnapshot.data['name'].toString()}');
      print('${DocumentSnapshot.data['conatctNumber'].toString()}');
      print('${DocumentSnapshot.data['email'].toString()}');
      print('${DocumentSnapshot.data['photo'].toString()}');
      setState(() {
        prefs.setString("name", DocumentSnapshot.data['name'].toString());
        prefs.setString(
            "conatctNumber", DocumentSnapshot.data['conatctNumber'].toString());
        prefs.setString("email", DocumentSnapshot.data['email'].toString());
        prefs.setString("photo", DocumentSnapshot.data['photo'].toString());
        name= prefs.getString("name");
        email=prefs.getString("email");
        contactNumber = prefs.getString("conatctNumber");
        print('contact number  $contactNumber');
        photo = prefs.getString("photo");
      });

    });
  }

  @override
  void initState() {
//    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    var _asyncLoader = new AsyncLoader(
      key: _asyncLoaderState,
      initState: () async => await getUserData(),
      renderLoad: () => new CircularProgressIndicator(),
      renderError: ([error]) =>
      new Text('Sorry, there was an error loading...'),
      renderSuccess: ({data}) => SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
        child:  Container(
          margin: EdgeInsets.only(top:25.0),
          width: screenWidth,
          height: screenHeight,
          child: Column(
//        crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top:10.0, bottom: 20.0),
                  width: 120.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    backgroundImage: photo != null ? NetworkImage(photo) : 
                      NetworkImage("https://firebasestorage.googleapis.com/v0/b/flutterfirebase-332a7.appspot.com/o/scaled_magazine-unlock-05-2.3.1383-_9B10AD863990C92341A252F96BF7F1EC.jpg?alt=media&token=eba24196-182a-41ab-be47-daa9623a697c"),
                  )
              ),

              Text('Name', style: hintStyleblackPR(),),
              Text( name ==  null ? '' : name, style: hintStyleboldtextPSBopacity(),),
              Padding(padding: EdgeInsets.only(top:20.0)),
              Text('Email', style: hintStyleblackPR(),),
              Text(email ==  null ? '' : email, style: hintStyleboldtextPSBopacity(),),
              Padding(padding: EdgeInsets.only(top:20.0)),
              Text('Contact Number', style: hintStyleblackPR(),),
              Text(contactNumber ==  null ? '' : contactNumber, style: hintStyleboldtextPSBopacity(),),
            ],
          ),
        ),
      ));



    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: green,
        title: Text('Welcome $name', textAlign: TextAlign.center, style: hintStylewhitetextPSB(),),
        iconTheme: IconThemeData(color: green),
        centerTitle: true,
      ),
      body: _asyncLoader,


      bottomNavigationBar:  Container(
        width:screenWidth-70.0,
        height: 45.0,
        margin: EdgeInsets.only(bottom:20.0, left: 40.0, right: 40.0),
        decoration: BoxDecoration(
//            color: Color(0xFF0C0D0E),
        color: green,
            borderRadius: BorderRadius.circular(25.0)
        ),
        child: RawMaterialButton(onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
                  builder: (BuildContext context) => UpdateProfile(),
            ),
          );
        }, child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(' Update', style: hintStylewhitetextPSB(),),

          ],
        )
        ),
      ),
    );

  }


}
