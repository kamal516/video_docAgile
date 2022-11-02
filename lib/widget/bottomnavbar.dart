import 'package:doctoragileapp/color.dart';
import 'package:flutter/material.dart';
import 'package:doctoragileapp/screens/chatlistscreen.dart';
import 'package:doctoragileapp/theme2.dart';
import 'package:doctoragileapp/triage/aptmntriage.dart';
import 'package:doctoragileapp/screens/login.dart';
import 'package:doctoragileapp/upcomingappntmnt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar();
  }
}

class BottomNavigationBar extends StatefulWidget {
  const BottomNavigationBar({
    Key key,
  }) : super(key: key);

  @override
  _BottomNavigationBarState createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBar> {
  bool _eventScreen;
  bool _homeScreen;
  bool _serviceScreen;
  bool _chatScreen;
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        child: new Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF61697c)),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          colors: [buttonColor, buttonColor],
        ),
      ),
      height: 80,
      child: Row(
        // mainAxisSize: MainAxisSize.max,
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton(
            color: buttonColor,
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              _homeScreen = preferences.getBool("HomePage");
              if (_homeScreen != true) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Upcomingappointment()));
              } else {
                return;
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //  SvgPicture.asset('assets/homeicon.svg',),
                Icon(
                  Icons.home_outlined,
                  color: buttonTextColor,
                  size: 28.0,
                ),
                Text(
                  "HOME",
                  style: TextStyle(color: buttonTextColor,fontSize: 12),
                ),
              ],
            ),
          ),
          RaisedButton(
              color: buttonColor,
              onPressed: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                _eventScreen = preferences.getBool("EventPage");
                if (_eventScreen != true) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => EventSelect()));
                } else {
                  return;
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 25.0,
                    color: buttonTextColor,
                  ),
                  //Image.asset('assets/Appointment.png'),

                  // SvgPicture.asset('assets/appointment.svg'),
                  Text("CALENDAR", style: TextStyle(color: buttonTextColor,fontSize: 12)),
                ],
              )),
          RaisedButton(
            color: buttonColor,
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              _serviceScreen = preferences.getBool("ServicePage");
              if (_serviceScreen != true) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Categoryset()));
              } else {
                return;
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/Triage.png'),
                // SvgPicture.asset('assets/service.svg'),
                Text("SERVICES", style: TextStyle(color: buttonTextColor,fontSize: 12)),
              ],
            ),
          ),
          // Container(
          //  height: 50,
          //   width: 50,
          //   child:
          RaisedButton(
            color: buttonColor,
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              _chatScreen = preferences.getBool("ChatPage");
              if (_chatScreen != true) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Chatscreen()));
              } else {
                return;
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/Chat.png'),
                Text("CHAT", style: TextStyle(color: buttonTextColor,fontSize: 12)),
              ],
            ),
          )
          // )
        ],
      ),
    ));
  }
}
