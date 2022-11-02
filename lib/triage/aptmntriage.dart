import 'dart:convert';
import 'package:doctoragileapp/widget/bottomnavbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:doctoragileapp/api.dart';
import 'package:doctoragileapp/color.dart';
import 'package:doctoragileapp/doctorlist.dart';
import 'package:doctoragileapp/theme2.dart';
import 'package:doctoragileapp/screens/login.dart';
import 'package:doctoragileapp/screens/menuscreen.dart';
import 'package:doctoragileapp/screens/showappointment.dart';

import 'package:doctoragileapp/upcomingappntmnt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class EventSelect extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<EventSelect> {
  CalendarController _controller;
   Map<DateTime, List<dynamic>> _events;
  Map<DateTime, List> dotappointments;
  List<dynamic> _selectedEvents;
  TextEditingController _eventController;
  TextEditingController _date;
  TextEditingController _description;
  SharedPreferences prefs;
  TextEditingController _username = new TextEditingController();
  TextEditingController _adress = new TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _eventController = TextEditingController();
    _description = TextEditingController();
  dotappointments = {};
    _selectedEvents = [];
    // initPrefs();
    gettoken();
  _getScreen();
  }
bool _homeScreen=false;
bool _chatScreen=false;
bool _serviceScreen=false;
bool _eventScreen;
_getScreen()async{
SharedPreferences preferences = await SharedPreferences.getInstance();
setState(() {
_eventScreen=true;
});
preferences.setBool("HomePage", _homeScreen);
preferences.setBool("ChatPage", _chatScreen);
preferences.setBool("ServicePage", _serviceScreen);
preferences.setBool("EventPage", _eventScreen);
}
  String _name(dynamic user) {
    return user['client_name'];
  }

  String _address(dynamic user) {
    return user['client_address1'];
  }

  String _issue(dynamic user) {
    return user['issue'];
  }

  String _tokenid;
  gettoken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _userid = preferences.getString("id");
      _tokenid = preferences.getString("token");
    });
      _appointmentybyMonth();
  }


  final String apiUrl = apipath + '/appointment';
  

  Future<List<dynamic>> fetchUsers() async {
    var result = await http.get(apiUrl);
    print(result.body);
    return json.decode(result.body);
  }
 
DateTime dateTime = DateTime.now();
  String _userid;
  var currentdate =  DateTime.now();
  List appointmentbydate = [];
  var data;
  Future<List> _dateappointment() async {
    final response = await http.post(apipath + '/getAppointmentForDoctorApp', body: {
      "date": DateFormat("yMd").format(_controller.selectedDay),
      "user_id": _userid,
          'timezone': dateTime.timeZoneName
    }).then((result) {
      if (result.body == '"No"') {
        if( 
           _controller.selectedDay.compareTo(currentdate)>0
 //  _controller.selectedDay.day >=  currentdate.day 
          ){
           return Navigator.push(
            context, MaterialPageRoute(builder: (context) => Doctorlist(
               appointment_date: _controller.selectedDay ,
              //  starttime: widget.,
              //  endtime: ,
              //  slotdifference: ,
            )));
        }else{
          return null;
        }
        // return Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => Doctorlist(
        //               appointment_date: _controller.selectedDay,
        //             )));
      } else {
        setState(() {
          appointmentbydate = jsonDecode(result.body);
        });
        return Navigator.push( 
            context,
            MaterialPageRoute(
                builder: (context) => Showappointment(
                      bydate: appointmentbydate,
                      timer: _controller.selectedDay,
                    )));
      }
    });
  }

    Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }

     _appointmentybyMonth() async {
      
    final response = await http.post(apipath + '/doctorAppointments', 
    body: {
     
      "holder_id":_userid  ,
      "start_date":DateFormat("yyyy-MM-dd").format(_controller.visibleDays.first),
         "end_date":DateFormat("yyyy-MM-dd").format(_controller.visibleDays.last),
            'timezone': dateTime.timeZoneName
      
    }).then((test) {
  
    setState(() {
      var result=jsonDecode(test.body) as List;
    try
    {

  
    
    dotappointments=Map.fromIterable(result, key: (e) => DateTime.parse(e["appointment_date"]), value: (e) => ["empty"]);
  
     
    }catch(e)
    {
      
    }
      

    });
     print(dotappointments);
   
    });
  }
   
 void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    return _appointmentybyMonth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:  BottomNavBar(),
      body: Container(
        padding: EdgeInsets.only(top: 15),
      //  color: Color(0xFF1B2B33),
        child: new Container(
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(40.0),
                  topRight: const Radius.circular(40.0),
                )),
            padding: EdgeInsets.only(
              top: 0,
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 73,
                        width: 40,
                        decoration: new BoxDecoration(
                              color:buttonColor,
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(40.0),
                              topRight: const Radius.circular(40.0),
                            )),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                                //  IconButton(
                                //   icon: Icon(
                                //     Icons.menu,
                                //     color: Colors.white,
                                //   ),
                                 // onPressed: () {
                                  //  Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (context) =>
                                  //               Menuscreen()));
                                 // }
                                //  ),
                                // SizedBox(width:50),
                          Text(
                                  'Schedule An Appointment',
                                  style: TextStyle(
                                      color: buttonTextColor, fontSize: 18),
                                ),
                         
                             
                              // SizedBox(
                              //   width: 70,
                              // ),
                           
                            ]),
                      ),
                    ]),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TableCalendar(
                           daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.white),
                          dowTextBuilder: (date, locale) =>
                              DateFormat.E(locale).format(date)[0],
                        ),  weekendDays: [],
                           
                        events: dotappointments
                      
                 ,
                     
                        initialCalendarFormat: CalendarFormat.month,
                        calendarStyle: CalendarStyle(
                             markersColor: buttonColor,
                             outsideStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.white),
                            canEventMarkersOverflow: true,
                           todayColor: Color(0xFF1B2B33),
                            selectedColor: Color(0xFF1B2B33),
                            todayStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.white)),
                        headerStyle: HeaderStyle(
                            decoration: BoxDecoration(color: greyContainer),
                          centerHeaderTitle: true,
                            titleTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.black),
                          formatButtonDecoration: BoxDecoration(
                           color: buttonColor,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          formatButtonTextStyle: TextStyle(color: buttonTextColor),
                          formatButtonShowsNext: false,
                        ),
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        onVisibleDaysChanged: _onVisibleDaysChanged,
                        onDaySelected: (date, events, holidays) {
                        
                  _dateappointment();
                         
                        },
            

                        builders: CalendarBuilders(
                          selectedDayBuilder: (context, date, events) =>
                              Container(
                                  margin: const EdgeInsets.all(4.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: buttonColor,
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Text(
                                    date.day.toString(),
                                    style: TextStyle(color: buttonTextColor),
                                  )),
                          todayDayBuilder: (context, date, events) => Container(
                              margin: const EdgeInsets.all(4.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  //  color: Color(0xFFe5e7e6),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(color: Colors.black),
                              )),
                        ),
                        calendarController: _controller,
                      ),
                      ..._selectedEvents.map((event) => Card(
                              child: ListTile(
                            title: Text(event['client_name']),
                          ))),
                    ],
                  ),
                ),
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
         backgroundColor: buttonColor,
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
           //  _dateappointment();
          // _getappointment();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Doctorlist(
                        time:DateTime.now()
                     //    _controller.selectedDay,
                      )
                      ));
        },
      ),
    );
  }

  Future<List> _registerndata() async {
    final response = await http.post(apipath + '/register',

        //  "https://agilemedapp-cn4rzuzz6a-el.a.run.app/createAppointment",
        body: {
          "username": _username.text,
          "address1": _adress.text,
        });
  }

  _setappointment() async {
    await http.post(apipath + '/getAppointment',
        // "http://192.168.1.6:3040/getAppointment",
        // "https://agilemedapp-cn4rzuzz6a-el.a.run.app/getAppointment",
        body: {
          "date": DateFormat('yyyy-MM-dd').format(_controller.selectedDay),
            'timezone': dateTime.timeZoneName
        }).then((val) {
      setState(() {
        _selectedEvents = jsonDecode(val.body);
      });
      print(_selectedEvents);
     
    });
  }

 
}
