import 'package:flutter/material.dart';
import 'package:doctoragileapp/screens/login.dart';
import 'package:doctoragileapp/triage/aptmntriage.dart';
import 'package:doctoragileapp/upcomingappntmnt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Rootpage extends StatefulWidget {
  final String app_id;
  Rootpage({this.app_id});
  @override
  _RootpageState createState() => _RootpageState();
}
enum AuthStatus { notsignIn, signIn }
class _RootpageState extends State<Rootpage> {
    AuthStatus authStatus = AuthStatus.notsignIn;
     SharedPreferences localStorage ;
String token='';
bool signin=false;
bool signout=false;
     void _getdata()async{
       localStorage = await SharedPreferences.getInstance();
       setState(() {
         authStatus = localStorage.getString("token") == null ? AuthStatus.notsignIn : AuthStatus.signIn;
        // token = localStorage.getString("token");
// user = preferences.getString("adrs");
       });
     }
    //   if(useremail.text.length==0 || _phone.text.length==0 || _name.text.length==0 || userpassword.text.length==0 || !useremail.text.contains("@"))
    // {
    //   return;
    // }
     @override
  void initState() {
   super.initState();
    _getdata();
  }
  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signIn;
    });
  }

  void _signOut() {
    setState(() {
      authStatus = AuthStatus.notsignIn;
    });
  }
  @override
  Widget build(BuildContext context) {

     switch (authStatus) {
      case AuthStatus.notsignIn:
        return new Loginpage(
                token_appid: widget.app_id
      
        );
      case AuthStatus.signIn:
        return new
           Upcomingappointment();
        //     Testit(
        //   auth: widget.auth,
        //   onSignedOut: _signOut,
        // );
    }
  
  }
}