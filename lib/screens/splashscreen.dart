import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:doctoragileapp/color.dart';
import 'package:doctoragileapp/screens/ballpulse.dart';
import 'package:doctoragileapp/screens/login.dart';
import 'package:doctoragileapp/screens/loading.dart';
import 'package:doctoragileapp/screens/rootpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return initScreen(context);
  }
String app_token;
  @override
  void initState() {
    super.initState();
    startTimer();
    
    // firebaseCloudMessaging_Listeners();
    //_firebaseMessaging.onTokenRefresh;
    // _firebaseMessaging.getToken().then((value)async {
    //   print(value);
    //   SharedPreferences _localstorage = await SharedPreferences.getInstance();

   
    //     _localstorage.setString('appidtoken', value);
    //   // setState(() {
    //   //   app_token = value;
    //   // });
    // });
    // getappid();
    
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");

    //     final notification = message['notification'];
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");

    //     final notification = message['data'];
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //   },
    // );
    // _firebaseMessaging.requestNotificationPermissions(
    //     const IosNotificationSettings(sound: true, badge: true, alert: true));
  }


 String app_tokenid;

  getappid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      app_tokenid = preferences.getString("appidtoken");
   
    });
   
 
  }
  startTimer() async {
    var duration = Duration(seconds: 3);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Rootpage(
         app_id: app_tokenid,
          )));
  }

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  initScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              color: backgroundColor,
              // height: 200,
              // width: 200,
              child: Image.asset('assets/Splash.png'),
            ),
            Text('Version - 1.1',style: TextStyle(color:textColor),)
            // Padding(padding: EdgeInsets.only(top: 140.0)),
            // Container(
            //   child: Center(
            //     child: Loading(
            //       indicator: BallPulseIndicator(),
            //       size: 70.0,
            //       color: themecolor,
            //     ),
            //   ),
            // ),
            // Padding(padding: EdgeInsets.only(top: 30.0)),
            // new Container()
          ],
        ),
      ),
    );
  }
}