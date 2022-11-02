import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:doctoragileapp/widget/bottomnavbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:doctoragileapp/api.dart';
import 'package:doctoragileapp/color.dart';
import 'package:doctoragileapp/screens/chatlist.dart';
import 'package:doctoragileapp/screens/login.dart';
import 'package:doctoragileapp/screens/menuscreen.dart';
import 'package:doctoragileapp/screens/notificationlist.dart';
import 'package:doctoragileapp/screens/testchat.dart';
import 'package:doctoragileapp/triage/aptmntriage.dart';
import 'package:doctoragileapp/theme2.dart';
import 'package:doctoragileapp/triage/detailpage.dart';
import 'package:doctoragileapp/triage/doctrinfo.dart';
import 'package:doctoragileapp/triage/updateappointment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Upcomingappointment extends StatefulWidget {
  final String user_name;
  Upcomingappointment({this.user_name});
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<Upcomingappointment> {
  String _email;
  String _password;
  final formkey = new GlobalKey<FormState>();
  FormType _formtype = FormType.login;
  TextEditingController useremail = new TextEditingController();
  TextEditingController userpassword = new TextEditingController();
  TextEditingController _name = new TextEditingController();
// TextEditingController _description =new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _address = new TextEditingController();

// _doctordata(int index)async{
//   final ddata= await http.post(apipath + '/doctorListById',
//   body: {
//     "user_id": appointmentdata[index]["user_id"],
//   }).then((value){
// // return value.body;
//       return
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Doctorinfo()));
//   });
//   }

  bool validateandsave() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  String token_id;
  String _localuserid;
  String _userid;
  String _loginedusername;
  @override
  void initState() {
    super.initState();
    _settoken();
    _getScreen();
  }

  int deleteremove;
  bool _homeScreen;
  bool _chatScreen = false;
  bool _serviceScreen = false;
  bool _eventScreen = false;
  _getScreen() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _homeScreen = true;
    });
    preferences.setBool("HomePage", _homeScreen);
    preferences.setBool("ChatPage", _chatScreen);
    preferences.setBool("ServicePage", _serviceScreen);
    preferences.setBool("EventPage", _eventScreen);
  }

  _deleteappointment(int apointid) async {
    final response =
        await http.post(apipath + '/cancelAppointmnetFromDoctor', body: {
      "appointment_id": apointid.toString(),
      "holder_id": _localuserid,
      "username": appointmentdata[0]['client_name'],
      "user_id": appointmentdata[0]['user_id'].toString(),
      'timezone': dateTime.timeZoneName
      //checkid.toString(),
    }).then((test) {
      // print(test.body);
      Navigator.pop(context);
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>EventSelect()));
    });
  }

  _settoken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _localuserid = preferences.getString("id");
      _loginedusername = preferences.getString("name");
      token_id = preferences.getString("token");
    });
    startTimer();
    // appointmentByCurrentDate();
  }

  void startTimer() {
    _timer = new Timer.periodic(new Duration(seconds: 1), (time) {
      _getmessage();
      appointmentByCurrentDate();
    });
  }

  @override
  void deactivate() {
    if (_timer.isActive) {
      _timer.cancel();
    } else {
      startTimer();
    }
    super.deactivate();
  }

  setdoctorname(String name) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double multiplier = 1.9;
    return Text(
      name,
      style: TextStyle(
        color: blackTextColor,
        fontWeight: FontWeight.bold,
        fontSize: multiplier * unitHeightValue,
      ),
    );
  }

  Timer _timer;
  List fetchmeassagedata = [];
  Future<List> _getmessage() async {
    final response = await http.post(apipath + '/getNotification', body: {
      "user_id": _localuserid,
      'timezone': dateTime.timeZoneName
    }).then((result) async {
      // print(result.body);
      setState(() {
        fetchmeassagedata = jsonDecode(result.body);
      });
      // print(fetchmeassagedata);
    });
  }

  DateTime dateTime = DateTime.now();
  confirmationstatus(BuildContext context, int selected_id) async {
    final response = await http.post(apipath + '/confirmAppointmentByDoctor',
        body: {'appointment_id': selected_id.toString()}).then((result) {
      result.body;
      setState(() {
        confirmedstatus = jsonDecode(result.body);
      });
      if (confirmedstatus['msg'] == 'Updated') {
        Navigator.pop(context);
      }
      return confirmedstatus['msg'];
    });
  }

  Future<List> appointmentByCurrentDate() async {
    final response = await http
        .post(apipath + '/doctorAppointmentByCurrentDate', body: {
      "user_id": _localuserid,
      'timezone': dateTime.timeZoneName
    }).then((result) {
      result.body;
      setState(() {
        appointmentdata = jsonDecode(result.body);
      });
      _getmessage();
      // modifyappointmentbydate();
    });
  }
//  Future<List> modifyappointmentbydate() async {
//     final response =
//         await http.post(apipath + '/doctorListByIdAppointment', body: {
//           'appointment_date':DateTime.parse(appointmentdata[0]['appointment_date']).toLocal().toString(),
//       "user_id": _localuserid,
//        'timezone': dateTime.timeZoneName
//     }).then((result) {
//       result.body;
//       setState(() {
//         appointmentdata = jsonDecode(result.body);
//       });

//     });
//   }
  AlertDialog alert = AlertDialog(
    title: Text("Notice"),
    content: Text("go to login"),
  );

  int selectedIndex;
  int selectedMale = 0;
  int selectedFemale;
  int selectedIndexList;
  int selectedIndexList1;
  List appointmentdata;
  List appointmentdata1;
  var confirmedstatus;
  getdate(var setdate) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double multiplier = 1.6;
    return Text(
      setdate,
      style: TextStyle(
        color: Colors.white,
        fontSize: multiplier * unitHeightValue,
      ),
    );
  }

  getmodifybutton() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double multiplier = 1.7;
    return Text(
      'MODIFY',
      style: TextStyle(
        color: Colors.white,
        fontSize: multiplier * unitHeightValue,
      ),
    );
  }

  String _username(dynamic user) {
    return user[' client_name'];
  }

  int _id;
  String _specalist(dynamic user) {
    return user['email'];
  }

  String _problrm(dynamic user) {
    return user['issue'];
  }

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

  int _counter;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  bool _login = false;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        bottomNavigationBar: BottomNavBar(),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 1.1,
                color: backgroundColor,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 0, left: 0),
                      child: Image(
                        height: 190.0,
                        width: 450.0,
                        image: AssetImage('assets/Logo_new.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 190),
                      child: new Container(
                          decoration: new BoxDecoration(
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 20.0,
                                ),
                              ],
                              color: homescreenContainerColor,
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(40.0),
                                topRight: const Radius.circular(40.0),
                              )),
                          padding:
                              EdgeInsets.only(top: 50, left: 20, right: 20),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Welcome!",
                                          style: TextStyle(
                                            fontSize: 14,
                                          )),
                                      Container(
                                          width: 130,
                                          child: Text(
                                              _loginedusername == null
                                                  ? "Loading..."
                                                  : _loginedusername,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  )),
                                  // SizedBox(
                                  //   width: 70,
                                  // ),

                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Notificationlist()));
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      child: Stack(
                                        children: [
                                          SvgPicture.asset('assets/Belll.svg'),
                                          Container(
                                            width: 30,
                                            height: 30,
                                            alignment: Alignment.topCenter,
                                            margin: EdgeInsets.only(top: 0),
                                            child: Container(
                                              width: 15,
                                              height: 15,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: belliconCircle,
                                                  border: Border.all(
                                                      color: iconColor,
                                                      width: 1)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: Center(
                                                  child: Text(
                                                    fetchmeassagedata.length
                                                                .toString() ==
                                                            null
                                                        ? ''
                                                        : fetchmeassagedata
                                                            .length
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontSize: 8,
                                                        color:
                                                            belliconCircleTextColor),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 1),

                                  //                         )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text("Upcoming Appointments",
                                  style: TextStyle(
                                      fontSize: 12, color: greyTextColor)),
                              SizedBox(
                                height: 5,
                              ),
                              Expanded(
                                  child: ListView.builder(
                                itemCount: appointmentdata == null
                                    ? 0
                                    : appointmentdata.length,
                                itemBuilder: (BuildContext context, int index) {
                                  List<dynamic> user = appointmentdata;
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                        // if you need this
                                        side: BorderSide(
                                      color: appointmentCardborderColor,
                                      width: 1,
                                    )),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                                child: Row(
                                              // crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 5),
                                                  child: CircleAvatar(
                                                      radius: 30,
                                                      child: ClipOval(
                                                        child: Image.asset(
                                                            "assets/profile.png"),
                                                      )),
                                                ),
                                                SizedBox(
                                                  width: 12,
                                                ),
                                                Container(
                                                  width: 120,
                                                  child: setdoctorname(
                                                      appointmentdata[index]
                                                          ['client_name']),
                                                )
                                              ],
                                            )),
                                            Container(
                                              child: Row(
                                                children: <Widget>[
                                                  GestureDetector(
                                                      onTap: () {
                                                        return showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(32.0))),
                                                                title: Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      child: Text(
                                                                          'CONFIRMATION'),
                                                                    ),
                                                                    Divider(
                                                                        color:
                                                                            dividerColor),
                                                                    SizedBox(
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    Container(
                                                                        width:
                                                                            200.0,
                                                                        height:
                                                                            100.0,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(67),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          'Are you sure you want to confirm this appointment?',
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w600),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        )),
                                                                  ],
                                                                ),
                                                                content: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: <
                                                                      Widget>[
                                                                    RaisedButton(
                                                                        color:
                                                                            buttonColor,
                                                                        child:
                                                                            Text(
                                                                          'YES',
                                                                          style:
                                                                              TextStyle(color: buttonTextColor),
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          setState(
                                                                              () {
                                                                            deleteremove =
                                                                                1;
                                                                          });
                                                                          confirmationstatus(
                                                                              context,
                                                                              appointmentdata[index]['appointment_id']);

                                                                          // _deleteappointment(user[index]['appointment_id']);
                                                                        }),
                                                                    RaisedButton(
                                                                        color:
                                                                            disclaimeridontButtonColor,
                                                                        child:
                                                                            Text(
                                                                          'NO',
                                                                          style:
                                                                              TextStyle(color: buttonTextColor),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        })
                                                                  ],
                                                                ),
                                                              );
                                                            });
                                                      },
                                                      child: user[index][
                                                                      'appointment_status'] ==
                                                                  "Confirm" &&
                                                              user[index]
                                                                      [
                                                                      'appointment_status'] !=
                                                                  "Completed"
                                                          ?
                                                          // confirmedstatus==null?
                                                          Container(
                                                              height: 32,
                                                              width: 32,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              18),
                                                                  color:
                                                                      checkColor
                                                                  // Color(0xffD2193B)
                                                                  //  selectedIndexList1 == 0
                                                                  //     ? Colors.grey
                                                                  //     : menucahtcolr
                                                                  ),
                                                              child: Center(
                                                                child: Icon(
                                                                  Icons.check,
                                                                  color:
                                                                      iconColor,
                                                                ),
                                                              )
                                                              //     Padding(
                                                              //   padding: EdgeInsets.only(
                                                              //       top:
                                                              //           6,
                                                              //       left:
                                                              //           1),
                                                              //   child: Icon(Icons.check)
                                                              //   // SvgPicture
                                                              //   //     .asset(
                                                              //   //   'assets/Delete.svg',
                                                              //   //   color:
                                                              //   //       Colors.white,
                                                              //   // ),
                                                              // ),
                                                              )
                                                          : Container()),
                                                  SizedBox(width: 2),
                                                  user[index]['user_id'] == -1
                                                      ? Container(
                                                          height: 32,
                                                          width: 32,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 4,
                                                                    left: 8),
                                                          ),
                                                        )
                                                      : GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            Chatlist(
                                                                              doctorname: user[index]['client_name'],
                                                                              holderid: user[index]['user_id'].toString(),
                                                                            )));
                                                          },
                                                          child: Container(
                                                            height: 32,
                                                            width: 32,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            18),
                                                                color: selectedIndexList1 ==
                                                                        0
                                                                    ? Colors
                                                                        .grey
                                                                    : chaticonBackgroundColor),
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 4,
                                                                      left: 8),
                                                              child: SvgPicture
                                                                  .asset(
                                                                'assets/chat1.svg',
                                                                color:
                                                                    iconColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                  user[index]['appointment_status'] ==
                                                                  "Confirm" &&
                                                              user[index][
                                                                      'appointment_status'] !=
                                                                  "Completed" ||
                                                          user[index]
                                                                  ['user_id'] ==
                                                              -1
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            return showDialog(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    false,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(32.0))),
                                                                    title:
                                                                        Column(
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          child:
                                                                              Text('CONFIRMATION'),
                                                                        ),
                                                                        Divider(
                                                                            color:
                                                                                dividerColor),
                                                                        SizedBox(
                                                                          height:
                                                                              20,
                                                                        ),
                                                                        Container(
                                                                            width:
                                                                                200.0,
                                                                            height:
                                                                                100.0,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(67),
                                                                            ),
                                                                            child:
                                                                                Text(
                                                                              'Are you sure you would like to cancel your appointment?',
                                                                              style: TextStyle(color: blackTextColor, fontSize: 15, fontWeight: FontWeight.w600),
                                                                              textAlign: TextAlign.center,
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    content:
                                                                        Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      children: <
                                                                          Widget>[
                                                                        RaisedButton(
                                                                            color:
                                                                                buttonColor,
                                                                            child:
                                                                                Text(
                                                                              'YES',
                                                                              style: TextStyle(color: buttonTextColor),
                                                                            ),
                                                                            onPressed:
                                                                                () async {
                                                                              _deleteappointment(user[index]['appointment_id']);
                                                                            }),
                                                                        RaisedButton(
                                                                            color:
                                                                                disclaimeridontButtonColor,
                                                                            child:
                                                                                Text(
                                                                              'NO',
                                                                              style: TextStyle(color: buttonTextColor),
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            })
                                                                      ],
                                                                    ),
                                                                  );
                                                                });
                                                          },
                                                          child: Container(
                                                            height: 32,
                                                            width: 32,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            18),
                                                                color:
                                                                    deleteiconBackgroundColor
                                                                //  selectedIndexList1 == 0
                                                                //     ? Colors.grey
                                                                //     : menucahtcolr
                                                                ),
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 6,
                                                                      left: 1),
                                                              child: SvgPicture
                                                                  .asset(
                                                                'assets/Delete.svg',
                                                                color:
                                                                    iconColor,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : Container()
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                            child: Row(
                                          //       crossAxisAlignment: CrossAxisAlignment.stretch,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                                height: 36,
                                                width: 170,
                                                decoration: BoxDecoration(
                                                    color: Color(0xFF436670),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2)),
                                                child: Center(
                                                  child: Text(
                                                    DateFormat(
                                                            "EEEE, d MMMM\n y")
                                                        .add_jm()
                                                        .format(DateTime.parse(
                                                                user[index][
                                                                    'appointment_date'])
                                                            .toLocal()),
                                                    style: TextStyle(
                                                        color: buttonTextColor,
                                                        fontSize: 13),
                                                  ),
                                                )
                                                // getdate(DateFormat("EEEE, d MMMM\n y").add_jm().format(DateTime.parse(user[index]['appointment_date']).toLocal())) ,)
                                                ),
                                            SizedBox(
                                              width: 2,
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(right: 5),
                                                child: RaisedButton(
                                                    color: buttonColor,
                                                    onPressed: () {
                                                      http.post(
                                                          apipath +
                                                              '/doctorListByIdAppointment',
                                                          body: {
                                                            'appointment_date':
                                                                DateTime.parse(
                                                                        appointmentdata[0]
                                                                            [
                                                                            'appointment_date'])
                                                                    .toLocal()
                                                                    .toString(),
                                                            "user_id":
                                                                _localuserid,
                                                            'timezone': dateTime
                                                                .timeZoneName
                                                          }).then((result) {
                                                        result.body;
                                                        setState(() {
                                                          appointmentdata1 =
                                                              jsonDecode(
                                                                  result.body);
                                                        });
                                                        return Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => Detailpage(
                                                                    starttime: appointmentdata1[0]['available_start_time'],
                                                                    endtime: appointmentdata1[0]['available_end_time'],
                                                                    slotdifference: appointmentdata1[0]['slot_size'],
                                                                    doctor: user[index]['doctorname'],
                                                                    total_amount: user[index]['paid_amount'].toString(),
                                                                    holderid: user[index]['holder_id'].toString(),
                                                                    user_image: user[index]['user_profile'],
                                                                    doctoremail: user[index]['doctoremail'],
                                                                    email: user[index]['email'],
                                                                    name: user[index]['client_name'],
                                                                    clientid: user[index]['user_id'].toString(),
                                                                    phonenumber: user[index]['phonenumber'],
                                                                    // problem: user[index]['issue'],
                                                                    appointment_id: user[index]['appointment_id'].toString(),
                                                                    appointment_datetime: DateTime.parse(user[index]['appointment_date']))));
                                                      });
                                                    },
                                                    child:
                                                        // setmodifybuttom()
                                                        Text(
                                                      'Modify',
                                                      style: TextStyle(
                                                          color:
                                                              buttonTextColor,
                                                          fontSize: 11),
                                                    )))
                                          ],
                                        ))
                                      ],
                                    ),
                                  );
                                },
                              ))
//                               Expanded(
//                                 child: ListView(
//                                   children: <Widget>[
//                                     Padding(
//                                         padding:
//                                             EdgeInsets.only(left: 1, right: 1),
//                                         child: ListView.builder(
//                                             itemCount: appointmentdata == null
//                                                 ? 0
//                                                 : appointmentdata.length,
//                                             shrinkWrap: true,
//                                             physics: ClampingScrollPhysics(),
//                                             itemBuilder: (BuildContext context,
//                                                 int index) {
//                                               List<dynamic> user =
//                                                   appointmentdata;
//                                               return Card(
//                                                 child: Row(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: <Widget>[
//                                                     GestureDetector(
//                                                       onTap: () {
//                                                         // _doctordata(index);
//                                                         // Navigator.pushReplacement(
//                                                         //     context,
//                                                         //     MaterialPageRoute(
//                                                         //         builder:
//                                                         //             (context) =>
//                                                         //                 Doctorinfo()));
//                                                       },
//                                                       child: Container(
//                                                         width: 45,
//                                                         height: 45,
//                                                         child: CircleAvatar(
//                                                           backgroundColor:
//                                                               Colors.grey,
//                                                           //  radius: 15,
//                                                           child: ClipOval(
//                                                               child: Image.asset(
//                                                                   "assets/profile.png")
//                                                               // CachedNetworkImage(
//                                                               //   imageUrl:user[index][
//                                                               //       'user_profile'],
//                                                               //   fit: BoxFit.fill,
//                                                               // width: 65.0 ,
//                                                               // )
//                                                               //     Image.network(
//                                                               //   user[index][
//                                                               //       'user_profile'],
//                                                               //   fit: BoxFit.fill,
//                                                               // width: 65.0,
//                                                               //   // height: 160.0,
//                                                               // ),
//                                                               ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Expanded(
//                                                       child: Container(
//                                                         margin: EdgeInsets.all(
//                                                             12.0),
//                                                         child: Column(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .spaceAround,
//                                                           crossAxisAlignment:
//                                                               CrossAxisAlignment
//                                                                   .start,
//                                                           children: <Widget>[
//                                                             Row(
//                                                               mainAxisAlignment: MainAxisAlignment.start,
//                                                                 children: <
//                                                                     Widget>[
//                                                                   Container(
//                                                                     // color: Colors.orange,
//                                                                     width: 100,
//                                                                     child: Column(

//                                                                         crossAxisAlignment:
//                                                                             CrossAxisAlignment
//                                                                                 .start,
//                                                                         children: <
//                                                                             Widget>[
//                                                                           Text(
//                                                                             user[index]['client_name'],
//                                                                             //  _username(user[index]),
//                                                                             style:
//                                                                                 TextStyle(
//                                                                               fontSize: 14.0,
//                                                                               fontWeight: FontWeight.bold,
//                                                                             ),
//                                                                             overflow:
//                                                                                 TextOverflow.ellipsis,
//                                                                           ),
// //  RatingStars(5),
//                                                                           SizedBox(
//                                                                               height: 4.0),
//                                                                           Text(
//                                                                             user[index]['issue'] == null
//                                                                                 ? ''
//                                                                                 : user[index]['issue'],
//                                                                             //  _problrm(user[index]),
//                                                                             style:
//                                                                                 TextStyle(
//                                                                               fontSize: 12.0,
//                                                                               fontWeight: FontWeight.w600,
//                                                                             ),
//                                                                             overflow:
//                                                                                 TextOverflow.ellipsis,
//                                                                           ),
//                                                                         ]),
//                                                                   ),
//                                                                   Container(
//                                 child: Row(children: <Widget>[
//                                                                     GestureDetector(
//                                                                     onTap: () {
//                                                                       return showDialog(
//                                                                           context:
//                                                                               context,
//                                                                           barrierDismissible:
//                                                                               false,
//                                                                           builder:
//                                                                               (BuildContext context) {
//                                                                             return AlertDialog(
//                                                                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
//                                                                               title: Column(
//                                                                                 children: <Widget>[
//                                                                                   Container(
//                                                                                     child: Text('CONFIRMATION'),
//                                                                                   ),
//                                                                                   Divider(color: Colors.black),
//                                                                                   SizedBox(
//                                                                                     height: 20,
//                                                                                   ),
//                                                                                   Container(
//                                                                                       width: 200.0,
//                                                                                       height: 100.0,
//                                                                                       decoration: BoxDecoration(
//                                                                                         borderRadius: BorderRadius.circular(67),
//                                                                                       ),
//                                                                                       child: Text(
//                                                                                         'Are you sure you want to confirm this appointment?',
//                                                                                         style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
//                                                                                         textAlign: TextAlign.center,
//                                                                                       )),
//                                                                                 ],
//                                                                               ),
//                                                                               content: Row(
//                                                                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                                                                 children: <Widget>[
//                                                                                   RaisedButton(
//                                                                                       color: themecolor,
//                                                                                       child: Text(
//                                                                                         'YES',
//                                                                                         style: TextStyle(color: Colors.white),
//                                                                                       ),
//                                                                                       onPressed: () async {
// setState(() {
//   deleteremove = 1;
// });
//            confirmationstatus(context,appointmentdata[index]['appointment_id']);

//                                                                                         // _deleteappointment(user[index]['appointment_id']);
//                                                                                       }),
//                                                                                   RaisedButton(
//                                                                                       color: Colors.grey,
//                                                                                       child: Text(
//                                                                                         'NO',
//                                                                                         style: TextStyle(color: Colors.white),
//                                                                                       ),
//                                                                                       onPressed: () {
//                                                                                         Navigator.pop(context);
//                                                                                       })
//                                                                                 ],
//                                                                               ),
//                                                                             );
//                                                                           });
//                                                                     },
//                                                                     child:
//                                                                     user[index]['appointment_status']=="Confirm"&& user[index]['appointment_status']!="Completed"?
//                                                                     // confirmedstatus==null?
//                                                                     Container(
//                                                                       height:
//                                                                           32,
//                                                                       width: 32,
//                                                                       decoration: BoxDecoration(
//                                                                           borderRadius: BorderRadius.circular(
//                                                                               18),
//                                                                           color: Colors.green
//                                                                               // Color(0xffD2193B)
//                                                                           //  selectedIndexList1 == 0
//                                                                           //     ? Colors.grey
//                                                                           //     : menucahtcolr
//                                                                           ),
//                                                                       child: Center(
//                                                                         child: Icon(
//                                                                           Icons.check, color: Colors.white,
//                                                                           ),
//                                                                         )
//                                                                       //     Padding(
//                                                                       //   padding: EdgeInsets.only(
//                                                                       //       top:
//                                                                       //           6,
//                                                                       //       left:
//                                                                       //           1),
//                                                                       //   child: Icon(Icons.check)
//                                                                       //   // SvgPicture
//                                                                       //   //     .asset(
//                                                                       //   //   'assets/Delete.svg',
//                                                                       //   //   color:
//                                                                       //   //       Colors.white,
//                                                                       //   // ),
//                                                                       // ),
//                                                                     ):
//                                                                     Container()
//                                                                   ),

//                                                     SizedBox(
//                                                                       width: 5),
//                                                                   user[index]['user_id'] ==
//                                                                           -1
//                                                                       ? Container(
//                                                                           height:
//                                                                               32,
//                                                                           width:
//                                                                               32,
//                                                                           child:
//                                                                               Padding(
//                                                                             padding:
//                                                                                 EdgeInsets.only(top: 4, left: 8),
//                                                                           ),
//                                                                         )
//                                                                       : GestureDetector(
//                                                                           onTap:
//                                                                               () {
//                                                                             Navigator.push(
//                                                                                 context,
//                                                                                 MaterialPageRoute(
//                                                                                     builder: (context) => Chatlist(
//                                                                                           doctorname: user[index]['client_name'],
//                                                                                           holderid: user[index]['user_id'].toString(),
//                                                                                         )));
//                                                                           },
//                                                                           child:
//                                                                               Container(
//                                                                             height:
//                                                                                 32,
//                                                                             width:
//                                                                                 32,
//                                                                             decoration:
//                                                                                 BoxDecoration(borderRadius: BorderRadius.circular(18), color: selectedIndexList1 == 0 ? Colors.grey : Color(0xFF008ba1)),
//                                                                             child:
//                                                                                 Padding(
//                                                                               padding: EdgeInsets.only(top: 4, left: 8),
//                                                                               child: SvgPicture.asset(
//                                                                                 'assets/chat1.svg',
//                                                                                 color: Colors.white,
//                                                                               ),
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                   SizedBox(
//                                                                     width: 5,
//                                                                   ),
//                                                                  user[index]['appointment_status']=="Confirm"&& user[index]['appointment_status']!="Completed"?
//                                                                   GestureDetector(
//                                                                     onTap: () {
//                                                                       return showDialog(
//                                                                           context:
//                                                                               context,
//                                                                           barrierDismissible:
//                                                                               false,
//                                                                           builder:
//                                                                               (BuildContext context) {
//                                                                             return AlertDialog(
//                                                                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
//                                                                               title: Column(
//                                                                                 children: <Widget>[
//                                                                                   Container(
//                                                                                     child: Text('CONFIRMATION'),
//                                                                                   ),
//                                                                                   Divider(color: Colors.black),
//                                                                                   SizedBox(
//                                                                                     height: 20,
//                                                                                   ),
//                                                                                   Container(
//                                                                                       width: 200.0,
//                                                                                       height: 100.0,
//                                                                                       decoration: BoxDecoration(
//                                                                                         borderRadius: BorderRadius.circular(67),
//                                                                                       ),
//                                                                                       child: Text(
//                                                                                         'Are you sure you would like to cancel your appointment?',
//                                                                                         style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
//                                                                                         textAlign: TextAlign.center,
//                                                                                       )),
//                                                                                 ],
//                                                                               ),
//                                                                               content: Row(
//                                                                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                                                                 children: <Widget>[
//                                                                                   RaisedButton(
//                                                                                       color: themecolor,
//                                                                                       child: Text(
//                                                                                         'YES',
//                                                                                         style: TextStyle(color: Colors.white),
//                                                                                       ),
//                                                                                       onPressed: () async {
//                                                                                         _deleteappointment(user[index]['appointment_id']);
//                                                                                       }),
//                                                                                   RaisedButton(
//                                                                                       color: Colors.grey,
//                                                                                       child: Text(
//                                                                                         'NO',
//                                                                                         style: TextStyle(color: Colors.white),
//                                                                                       ),
//                                                                                       onPressed: () {
//                                                                                         Navigator.pop(context);
//                                                                                       })
//                                                                                 ],
//                                                                               ),
//                                                                             );
//                                                                           });
//                                                                     },
//                                                                     child:
//                                                                         Container(
//                                                                       height:
//                                                                           32,
//                                                                       width: 32,
//                                                                       decoration: BoxDecoration(
//                                                                           borderRadius: BorderRadius.circular(
//                                                                               18),
//                                                                           color:
//                                                                               Color(0xffD2193B)
//                                                                           //  selectedIndexList1 == 0
//                                                                           //     ? Colors.grey
//                                                                           //     : menucahtcolr
//                                                                           ),
//                                                                       child:
//                                                                           Padding(
//                                                                         padding: EdgeInsets.only(
//                                                                             top:
//                                                                                 6,
//                                                                             left:
//                                                                                 1),
//                                                                         child: SvgPicture
//                                                                             .asset(
//                                                                           'assets/Delete.svg',
//                                                                           color:
//                                                                               Colors.white,
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ):Container()

// ],),

//                                                                   ),

//                                                                 ]),
//                                                             SizedBox(
//                                                                 height: 6.0),
//                                                             Row(
//                                                               mainAxisAlignment: MainAxisAlignment.end,
//                                                               children: <
//                                                                   Widget>[
//                                                                        Container(
//                                                                        padding: EdgeInsets.only(top: 8,left: 2,right: 2),
//                                                                       height: 45,
//                                                                       color: Color(0xFF436670),
//                                                                       child: getdate( DateFormat(" EEEE, d MMMM y\n")
//                                                                               .add_jm()
//                                                                               .format(DateTime.parse(user[index]['appointment_date']).toLocal()),)
//                                                                         // Text(
//                                                                         //   new DateFormat(" EEEE, d MMMM , y\n")
//                                                                         //       .add_jm()
//                                                                         //       .format(DateTime.parse(user[index]['appointment_date']).toLocal()),
//                                                                         //   style: TextStyle(
//                                                                         //       fontSize: 11,
//                                                                         //       color: Colors.white),
//                                                                         // ),
//                                                                     ),
//                                                                 // Container(
//                                                                 //   height: 45,
//                                                                 //   width: 153,
//                                                                 //   padding:
//                                                                 //       EdgeInsets
//                                                                 //           .all(
//                                                                 //               5),
//                                                                 //   decoration: BoxDecoration(
//                                                                 //       borderRadius:
//                                                                 //           BorderRadius.circular(
//                                                                 //               2),
//                                                                 //       color: Color(
//                                                                 //           0xFF436670)),
//                                                                 //   child: Column(
//                                                                 //     crossAxisAlignment:
//                                                                 //         CrossAxisAlignment
//                                                                 //             .stretch,
//                                                                 //     children: <
//                                                                 //         Widget>[
//                                                                 //       Padding(
//                                                                 //         padding: EdgeInsets.only(
//                                                                 //             top:
//                                                                 //                 2,
//                                                                 //             left:
//                                                                 //                 3),
//                                                                 //         child:
//                                                                 //             Text(
//                                                                 //           new DateFormat(" EEEE, d MMMM , y\n")
//                                                                 //               .add_jm()
//                                                                 //               .format(DateTime.parse(user[index]['appointment_date']).toLocal()),
//                                                                 //           style: TextStyle(
//                                                                 //               fontSize: 11,
//                                                                 //               color: Colors.white),
//                                                                 //         ),
//                                                                 //       ),
//                                                                 //     ],
//                                                                 //   ),
//                                                                 // ),
//                                                                 SizedBox(
//                                                                   width: 2,
//                                                                 ),
//                                                                 GestureDetector(
//                                                                   onTap: () {
//                                                                     Navigator.push(
//                                                                         context,
//                                                                         MaterialPageRoute(
//                                                                             builder: (context) => Detailpage(
//                                                                                 doctor: user[index]['doctorname'],
//                                                                                 total_amount: user[index]['paid_amount'].toString(),
//                                                                                 holderid: user[index]['holder_id'].toString(),
//                                                                                 user_image: user[index]['user_profile'],
//                                                                                 doctoremail: user[index]['doctoremail'],
//                                                                                 email: user[index]['email'],
//                                                                                 name: user[index]['client_name'],
//                                                                                 clientid: user[index]['user_id'].toString(),
//                                                                                 phonenumber: user[index]['phonenumber'],
//                                                                                 // problem: user[index]['issue'],
//                                                                                 appointment_id: user[index]['appointment_id'].toString(),
//                                                                                 appointment_datetime: DateTime.parse(user[index]['appointment_date']))));
//                                                                   },
//                                                                   child: Container(
//                                                                       height: 45,
//                                                                       padding: EdgeInsets.only(top: 13,left: 2,right: 2),
//                                                                       // width: 65,
//                                                                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: Color(0xFF1B2B33)),
//                                                                       child: Column(
//                                                                         crossAxisAlignment:
//                                                                             CrossAxisAlignment.center,
//                                                                         children: <
//                                                                             Widget>[
//                                                                               getmodifybutton()
//                                                                           // Text(
//                                                                           //   'MODIFY',
//                                                                           //   style:
//                                                                           //       TextStyle(color: Colors.white, fontSize: 12),
//                                                                           // )
//                                                                         ],
//                                                                       )),
//                                                                 )
//                                                               ],
//                                                             )
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               );
//                                             })),
//                                   ],
//                                 ),
//                               )
                            ],
                          )),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 25, left: 30),
                        child: Stack(
                          children: <Widget>[
                            // SvgPicture.asset(
                            //   'assets/monitor.svg',
                            //   height: 150,
                            //   // width: 180,
                            // ),
                            Padding(
                                padding: EdgeInsets.only(top: 20, left: 5),
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  // padding: EdgeInsets.all(0.3),
                                  child: CircleAvatar(
                                    //  backgroundColor: Color(0xFF001233),
                                    backgroundColor: buttonColor,
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.menu,
                                          color: iconColor,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Menuscreen()));
                                        }),
                                  ),
                                )),
                            // Padding(
                            //   padding: EdgeInsets.only(top: 35, left: 100),
                            //   child: SvgPicture.asset(
                            //     'assets/logo.svg',
                            //     height: 30,
                            //   ),
                            // )
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
