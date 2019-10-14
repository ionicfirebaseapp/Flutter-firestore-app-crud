import 'dart:io';

import 'package:flutter/material.dart';
import 'package:online_grocery/screens/pages/home.dart';
import 'package:online_grocery/styles/styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:async_loader/async_loader.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> with TickerProviderStateMixin {

  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
  new GlobalKey<AsyncLoaderState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  static File _imageFile;

  takeImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = image;
      print('Image Path $_imageFile');
    });
    print("TakeImage  $_imageFile");
  }

  selectImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = image;
      print('Image Path $_imageFile');
    });
    print("SelectImage  $_imageFile");
  }

  _updateData() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      return;
    } else if (_imageFile != null) {
      form.save();
      print("ajdc djcn");
      setState(() {
        isLoadingUpdateData = true;
      });
      String fileName = path.basename(_imageFile.path);
      StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
      print(uploadTask);

      var taskSnapshot =
      await (await uploadTask.onComplete).ref.getDownloadURL();

      var imagUrl = taskSnapshot.toString();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Firestore.instance.collection('users').document(uid).updateData({
        'conatctNumber': contactNumber,
        'email': email,
        'name': name,
        'photo': imagUrl
      }).then((update) {
         setState(() {
           prefs.setString('name', name);
           prefs.setString('conatctNumber', contactNumber);
           prefs.setString('email', email);
           prefs.setString('photo', imagUrl);
         });

         Navigator.push(
           context,
           MaterialPageRoute(
             builder: (context) => HomePage(),
           ),
         );
//        if (accountUpdate) {
//          showDialog<Null>(
//            context: context,
//            barrierDismissible: false, // user must tap button!
//            builder: (BuildContext context) {
//              return new AlertDialog(
//                title: new Text('Updated'),
//                content: new SingleChildScrollView(
//                  child: new ListBody(
//                    children: <Widget>[
//                      new Text('Your Profile has been updated!!'),
//                    ],
//                  ),
//                ),
//                actions: <Widget>[
//                  new FlatButton(
//                    child: new Text('okay'),
//                    onPressed: () {
//                      setState(() {
//                        prefs.setString('name', name);
//                        prefs.setString('conatctNumber', contactNumber.toString());
//                        prefs.setString('email', email);
//                        prefs.setString('photo', photo);
//                      });
//                      Navigator.of(context).pop();
//                      Toast.show("your Information Sucessfully Updated", context,
//                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
//                    },
//                  ),
//                ],
//              );
//            },
//          );
//        }
        setState(() {
          isLoadingUpdateData = false;
        });
      }).catchError((e) {
        Toast.show("$e", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        print(e);
        setState(() {
          isLoadingUpdateData = false;
        });
      });
    }
  }


  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: InkWell(
          onTap: () {
            takeImage();
            Navigator.of(context).pop(false);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.camera_alt, size: 18.0, color: Colors.black),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
              ),
              Text(
                "Select Camera",
                style: hintStylesmalltextPSB(),
              ),
            ],
          ),
        ),
        content: InkWell(
          onTap: () {
            selectImage();
            Navigator.of(context).pop(false);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.image, size: 18.0, color: Colors.black),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
              ),
              Text("Select Gallery", style: hintStylesmalltextPSB()),
            ],
          ),
        ),
      ),
    ) ??
        false;
  }

  @override
  void initState() {
    getUserData();
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
        child:
        SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.only(top:40.0),
              width: screenWidth,
              child: Column(
                children: <Widget>[
                  Form(key: _formKey,
                      child:  Column(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Container(
                                  height: 120.0,
                                  width: 120.0,
                              margin: EdgeInsets.only(bottom: 10.0),
                              decoration: new BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                                  child: _imageFile == null
                                      ? photo != null
                                      ? CircleAvatar(
                                    backgroundImage: NetworkImage(photo),
                                  ) : new CircleAvatar(
                                      backgroundImage: new AssetImage(
                                          'lib/assets/images/login.png'))
                                      : new CircleAvatar(
                                    backgroundImage: new FileImage(_imageFile),
//                                radius: 80.0,
                                  ),
                                ),
                                Positioned(
                                  right: 2.0,
                                  bottom: 2.0,
                                  child: Container(
                                    height: 40.0,
                                    width: 40.0,
                                    child: new FloatingActionButton(
                                      foregroundColor: Colors.black,
                                      backgroundColor: Colors.white,
                                      onPressed: () => _onWillPop(),
                                      tooltip: 'Photo',
                                      child: new Icon(Icons.camera_alt),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 275,
                              margin: EdgeInsets.only(top:20.0, bottom: 0.0),
                              padding: EdgeInsets.only(left: 20.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color:blacktext.withOpacity(0.55)),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0)
                                  )
                              ),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: '$name',
                                  hintStyle: hintStyleboldtextPSBopacity(),
                                  border: InputBorder.none,
                                ),
                                initialValue: '${name == null ? "" : name}',
                                validator: (String value) {
                                  final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
                                  if (value.isEmpty || !nameExp.hasMatch(value)) {
                                    return 'Please enter your name';
                                  }
                                },
                                onSaved: (String value) {
                                  name = value;
                                },
                                style: hintStyleboldtextPSBopacity(),
                                cursorColor: green,
                              ),
                            ),
                            Container(
                              width: 275,
                              margin: EdgeInsets.only(top:20.0),
                              padding: EdgeInsets.only(left: 20.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color:  blacktext.withOpacity(0.55)),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0)
                                  )
                              ),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: '$contactNumber',
                                  hintStyle: hintStyleboldtextPSBopacity(),
                                  border: InputBorder.none,
                                ),
                                initialValue: '${contactNumber == null ? "" : contactNumber}',
                                validator: (String value) {
                                  if (value.length != 10)
                                    return 'Mobile Number must be of 10 digit';
                                  else
                                    return null;
                                },
                                onSaved: (String value) {
                                  contactNumber = value;
                                },
                                style: hintStyleboldtextPSBopacity(),
                                keyboardType: TextInputType.numberWithOptions(),
                                cursorColor: green,
                              ),
                            ),
                            Container(
                              width: 275,
                              margin: EdgeInsets.only(top:20.0),
                              padding: EdgeInsets.only(left: 20.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color:  blacktext.withOpacity(0.55)),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0)
                                  )
                              ),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: '$email',
                                  hintStyle: hintStyleboldtextPSBopacity(),
                                  border: InputBorder.none,
                                ),
                                initialValue: '${email == null ? "" : email}',
                                validator: (String value) {
                                  if (value.isEmpty ||
                                      !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                          .hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                },
                                onSaved: (String value) {
                                  email = value;
                                },
                                style: hintStyleboldtextPSBopacity(),
                                cursorColor: green,
                              ),
                            ),
                          ]
                      )
                  )

                ],
              )
          ),
        )
      ));
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: green,
        title: Text('Welcome $name', textAlign: TextAlign.center, style: hintStylewhitetextPSB(),),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body:_asyncLoader,
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

//          Navigator.push(
//            context,
//            MaterialPageRoute(
//                  builder: (BuildContext context) => HomePage(),
//            ),
//          );
        }, child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: _updateData,

              child: Text('Submit and Update', style: hintStylewhitetextPSB(),),
            ),
            new Padding(
                padding:
                new EdgeInsets.only(left: 5.0, right: 5.0)),
            isLoadingUpdateData
                ? new Image.asset(
              'lib/assets/icons/spinner.gif',
              width: 19.0,
              height: 19.0,
            )
                : new Text(''),
          ],
        )
        ),
      ),
    );

  }


}
