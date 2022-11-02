import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:doctoragileapp/api.dart';
import 'package:doctoragileapp/color.dart';

import 'package:doctoragileapp/screens/forgot.dart';
import 'package:doctoragileapp/screens/signup.dart';
import 'package:doctoragileapp/triage/aptmntriage.dart';

import 'package:doctoragileapp/upcomingappntmnt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginpage extends StatefulWidget {
  final String  token_appid;
  Loginpage({this.token_appid});
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

enum FormType { login, register }

class _QuestionScreenState extends State<Loginpage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _firstPress = true;
  TextEditingController useremail = new TextEditingController();
  TextEditingController userpassword = new TextEditingController();
  bool _login = false;
  String _password;
  String _email;
  String checkpassword;
  FormType _formtype = FormType.login;
  var data;
FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    super.initState();
  
 if (Platform.isIOS) {
      _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    }); 
      _firebaseMessaging.getToken().then((val)async {
                  print('Token: '+val);
                      SharedPreferences _localstorage = await SharedPreferences.getInstance();

      _localstorage.setString('appidtoken', val);
       getappid();
                });
     _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

      
      },
        //  onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

       
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    }
    
    // _firebaseMessaging.getToken().then((val) {
    //               print('Token: '+val);
    //             });
  
     
else if(Platform.isAndroid){
  _firebaseMessaging.getToken().then((value) async {
      print(value);
      SharedPreferences _localstorage = await SharedPreferences.getInstance();

      _localstorage.setString('appidtoken', value);
      //getappid();
      getappid();
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        final notification = message['notification'];
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        final notification = message['data'];
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
}
  
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    // _firebaseMessaging.getToken().then((value)async {
    //   print(value);
    //   SharedPreferences _localstorage = await SharedPreferences.getInstance();

   
    //     _localstorage.setString('appidtoken', value);
    //   // setState(() {
    //   //   app_token = value;
    //   // });
    //   getappid();
    // });
    
    

    
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
   
 print(app_tokenid);
  }

  _loginset() async {
    await http.post(apipath + '/doctorLogin',
      
        body: {
          'email':useremail.text,
         'appToken':app_tokenid,
      //   widget.token_appid ,
       //  widget.token_appid == null? "": widget.token_appid,
          'password': userpassword.text,
        }).then((result) async {
      print(result.body);
      data = jsonDecode(result.body);
      if (data['error'] == 'User does not exist') {
        return null;
      } else if (data['error'] == 'Something went Wrong..!!') {
        return null;
      } else {
        setState(() {
          _login = true;
        });
        var body = json.decode(result.body);
        SharedPreferences localStorage = await SharedPreferences.getInstance();

        localStorage.setString('id', body['user_id'].toString());
        localStorage.setString('roleid', body['role_id'].toString());
        localStorage.setString('token', body['token']);
        localStorage.setString('name', body['username']);
        localStorage.setString('desc', body['description']);
        localStorage.setString('phn', body['phone_number1']);
        localStorage.setString('adrs', body['address1']);
        localStorage.setString('email', body['email']);
        localStorage.setBool('enable', body['enable_notification']);
localStorage.setString('institute_id', body['institute_id'].toString());
        localStorage = await SharedPreferences.getInstance();
        if (localStorage.getString("token") != null) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
              builder: (BuildContext context) => Upcomingappointment()),
              ( Route<dynamic> route) => false);
          }
        }
      } 
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 1.0,
            color: Colors.black,
            child: Stack(
              children: <Widget>[
               Padding(
                  padding: EdgeInsets.only(top: 0, left: 0),
                  child: Image(
                    height: 250.0,
                    width: 400.0,
                    image: AssetImage('assets/Logo_new.png'),
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 250,bottom: 10),
                  child: new Container(
                      decoration: new BoxDecoration(
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.black,
                              blurRadius: 20.0,
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(40.0),
                            topRight: const Radius.circular(40.0),
                            bottomLeft: const Radius.circular(40.0),
                            bottomRight: const Radius.circular(40.0),
                          )),
                      padding: EdgeInsets.only(top: 10, left: 40, right: 40),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                         padding: EdgeInsets.only( bottom: 0),
                            child: Center(child:Text(
                              'SIGNIN',
                              style: TextStyle(fontSize: 25, color: buttonColor),
                            )),
                          ),
                          Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    controller: useremail,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: new InputDecoration(
                                        labelText: 'Email',
                                  filled: true,
                                        fillColor: greyContainer,
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.vertical(),
                                        )),
                                    validator: (val) {
                                      if (val.length == 0)
                                        return "Please enter email";
                                      else if (!val.contains("@"))
                                        return "Please enter valid email";
                                      else if (val != data['username']) {
                                        return "Please enter correct email";
                                      } else
                                        return null;
                                    },
                                    onSaved: (val) => _email = val,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  new TextFormField(
                                      obscureText: true,
                                      controller: userpassword,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: new InputDecoration(
                                        labelText: 'Password',
                                   filled: true,
                                        fillColor: greyContainer,
                                        border: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.vertical()),
                                      ),
                                      validator: (value) {
                                        if (value.length == 0) {
                                          return "Please enter password";
                                        } 
                                        else if (value.length <= 5)
                                          return "Your password should be more then 6 char long";
                                        else if (value != data['password']) {
                                          return "Please enter correct password";
                                        } else
                                          return null;
                                      },
                                      onSaved: (value) => _password = value),
                                ],
                              )
                            ),
                       
                         
                          if (_formtype == FormType.login)
                            Container(
                              child: new RaisedButton(
                                  color: buttonColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(),
                                      // borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.black)),
                                  child: new Text(
                                    'LOGIN',
                                    style: TextStyle(
                                        color: buttonTextColor, fontSize: 19),
                                  ),
                                  onPressed: () {
                                    _loginset();
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      _scaffoldKey.currentState
                                          .showSnackBar(new SnackBar(
                                        content: new Text(
                                            "email:$_email Password: $_password"),
                                        )
                                      );
                                    }
                                  }),
                                ),
                            Container(
                                    child: FlatButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                              builder: (context) =>
                                              ResetPassword()
                                             )
                                          );
                                        },
                                        child:Center(child: Text('Forgot password?',
                                          style: TextStyle(
                                          color: buttonColor,
                                          fontSize: 14)) )     
                                 )),
                        
                         ],
                       )
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}