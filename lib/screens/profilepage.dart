import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:doctoragileapp/api.dart';
import 'package:doctoragileapp/color.dart';
import 'package:doctoragileapp/triage/aptmntriage.dart';

import 'package:doctoragileapp/upcomingappntmnt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profilepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<Profilepage> {
  String _email;
  String _password;
  final formkey = new GlobalKey<FormState>();
  FormType _formtype = FormType.login;
  TextEditingController updatemail = new TextEditingController();
  TextEditingController userpassword = new TextEditingController();
  TextEditingController updateusername = new TextEditingController();
  TextEditingController updateimage = new TextEditingController();
  TextEditingController updatephone = new TextEditingController();
  TextEditingController updateaddress = new TextEditingController();
// TextEditingController updateenablenotification =new TextEditingController();
  bool updateenablenotification = false;

  bool validateandsave() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();

    _localuserid();
    isDisabled = false;
  }

  AlertDialog alert = AlertDialog(
    title: Text("Notice"),
    content: Text("go to login"),
  );

  void movetoRegister() {
    formkey.currentState.reset();
    setState(() {
      _formtype = FormType.register;
    });
  }

  void movetoLogin() {
    formkey.currentState.reset();
    setState(() {
      _formtype = FormType.login;
    });
  }

  bool isDisabled = false;
  bool _login = false;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: Container(
                 color: Colors.white,
            padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
            child: new RaisedButton(
                color: buttonColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(),
                 
                    side: BorderSide(color: Colors.black)),
                child: new Text(
                  'UPDATE ',
                  style: TextStyle(color: buttonTextColor, fontSize: 19),
                ),
                onPressed: () {
                
                  _updatedata();
                
                }),
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 1.1,
                color:buttonColor,
                child: Stack(
                  children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 0, left: 0),
                      child: Image(
                        height: 200.0,
                        // width: 400.0,
                        image: AssetImage('assets/Logo_BG.png'),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 200),
                      child: SingleChildScrollView(
child:
                       new Container(
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
                              )),
                          padding:
                              EdgeInsets.only(top: 30, left: 40, right: 40),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.pop(context);
                                        },
                                        child:
                                   
                                      Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            color: containerBorderColor),
                                        padding: EdgeInsets.only(top: 7),
                                        child: SvgPicture.asset(
                                          'assets/back.svg',
                                          color: iconColor,
                                        ),

                                        //  IconButton(icon: Icon(Icons.arrow_back), onPressed: null),
                                      ),),
                                      // SizedBox(
                                      //   width: 80,
                                      // ),
                                     Center(child: Text(
                                        'PROFILE',
                                        style: TextStyle(fontSize: 19),
                                      )),
                                      // SizedBox(
                                      //   width: 80,
                                      // ),
                                      GestureDetector(onTap: (){
                                        Navigator.pop(context);
                                      },
                                        child:
                                      Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            color: containerBorderColor),
                                        padding:
                                            EdgeInsets.only(top: 10, left: 8),
                                        child: SvgPicture.asset(
                                          'assets/close.svg',color: iconColor,
                                        ),

                                        //  IconButton(icon: Icon(Icons.arrow_back), onPressed: null),
                                      ),),
                                    ],
                                  )),
                              TextFormField(
                                controller: updateusername,
                                keyboardType: TextInputType.emailAddress,
                                decoration: new InputDecoration(
                                    labelText: "Username",
                                   fillColor: greyContainer,
                                    filled: true,
                                    border: new OutlineInputBorder(
                                      borderRadius: new BorderRadius.vertical(),
                                    )),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              new TextFormField(
                                enabled: false,
                                controller: updatemail,
                                keyboardType: TextInputType.emailAddress,
                                decoration: new InputDecoration(
                                    labelText: "Email",
                                    fillColor: greyContainer,
                                    filled: true,
                                    border: new OutlineInputBorder(
                                      borderRadius: new BorderRadius.vertical(),
                                    )),
                              ),

                           

                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                controller: updatephone,
                                autocorrect: true,
                                keyboardType: TextInputType.number,
                                maxLength: 15,
                                inputFormatters: <TextInputFormatter>[
                                  // WhitelistingTextInputFormatter.digitsOnly
                                ],
                                decoration: new InputDecoration(
                                    labelText: "Phone",
                                  fillColor: greyContainer,
                                    filled: true,
                                    border: new OutlineInputBorder(
                                      borderRadius: new BorderRadius.vertical(),
                                    )),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              _roleid !='103'?
                              Container( child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "Notification",
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    ),
                                    // SizedBox(width: 80),
                                    Switch(
                                        value: updateenablenotification,
                                        onChanged: (check) {
                                          setState(() {
                                            updateenablenotification = check;
                                          });
                                        }),
                                  ],
                                ),
                              ):Container(),

                             
                              SizedBox(height: 40),
                            ],
                          )),
                    ),
                
                    )   
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  String _idlocal;
  String _localupdateusername;
  String _localupdatephone;
  String _localupdateaddress;
  String _localupdateemaill;
  bool _localenable;

  String 
      _roleid;

  _localuserid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _idlocal = preferences.getString("id");
      _localupdateusername = preferences.getString("name");
    
      _localupdatephone = preferences.getString("phn");
      _localupdateaddress = preferences.getString("adrs");
      _localupdateemaill = preferences.getString("email");
      _localenable = preferences.getBool('enable');
    _roleid=preferences.getString("roleid");
    });
    updateusername = new TextEditingController(text: _localupdateusername);
    updatemail = new TextEditingController(text: _localupdateemaill);
    updatephone = new TextEditingController(text: _localupdatephone);
    updateaddress = new TextEditingController(text: _localupdateaddress);
    updateenablenotification = _localenable;
  }

  var userdata;
  bool savedataenable;
 _updatedata() async {
    
    final response = await http.post(apipath + '/updateDoctordata', body: {
      "username": updateusername.text,
      // "email": updatemail.text,
      "phone_number1": updatephone.text,
      // "address1": updateaddress.text,
      "user_id": _idlocal,
      "enable_notification": updateenablenotification.toString()
    }).then((result) async {
    
      print(result.body);
      setState(() {
        userdata = json.decode(result.body);
        
      });
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('name', userdata['username']);
 localStorage.setBool('enable', userdata["enable_notification"]);
localStorage.setString('phn', userdata["phone_number1"]);
localStorage.setString('email', userdata["email"]);

return
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Upcomingappointment()));

    });
  }
}
