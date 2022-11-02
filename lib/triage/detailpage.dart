import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:doctoragileapp/api.dart';
import 'package:doctoragileapp/color.dart';
import 'package:http/http.dart' as http;
import 'package:doctoragileapp/datetime.dart';
import 'package:doctoragileapp/screens/apptmntdone.dart';
import 'package:doctoragileapp/screens/doneappointment.dart';
import 'package:doctoragileapp/triage/aptmntriage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Detailpage extends StatefulWidget {
  final String starttime;
  final String endtime;
  final String date;
  final String time;
  DateTime appointment_datetime;
  final String name;
  final String phonenumber;
  final String problem;
  final String clientid;
  final String total_amount;
  final String appointment_id;
  final String doctor;
  final String email;
  final String holderid;
  final String doctoremail;
  final String user_image;
  final String slotdifference;
  // final String username;
  Detailpage(
      {this.starttime,
      this.endtime,
      this.date,
      this.holderid,
      this.time,
      this.appointment_datetime,
      this.name,
      this.email,
      this.total_amount,
      this.phonenumber,
      this.clientid,
      this.doctor,
      this.problem,
      this.user_image,
      this.doctoremail,
      this.appointment_id,
      this.slotdifference});
  @override
  _TestcatState createState() => _TestcatState();
}

class _TestcatState extends State<Detailpage> {
  String _catg(dynamic user) {
    return user['category'];
  }

  var date;
  @override
  void initState() {
    super.initState();
    // date = DateFormat('y-M-d').format(widget.appointment_datetime);
    // print(date);

    //   if (widget.appointment_datetime == date+' 12:00:00.000Z') {

    //   widget.appointment_datetime = date+' 00:00:00.000Z';
    // }else{
    //    widget.appointment_datetime;
    // }

    // name = new TextEditingController(text: widget.name);
    // address = new TextEditingController(text: widget.address);
    // problem = new TextEditingController(text: widget.problem);
    // datetime = new TextEditingController(text: widget.date);
    //  _time= new TextEditingController(text: widget.time);
    getPref();
    if (widget.appointment_datetime == null) {
      widget.appointment_datetime = DateTime.now();
    }

    //_information= widget.appointment_datetime ;
    //  datetime=new TextEditingController(text: widget.date.toString());
  }

  SharedPreferences prefs;
  String _description(dynamic user) {
    return user['description'];
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  TextEditingController name = new TextEditingController();
  TextEditingController fees = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController phonenumber = new TextEditingController();
  TextEditingController useremail = new TextEditingController();
  TextEditingController problem = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController datetime = new TextEditingController();
  TextEditingController _time = new TextEditingController();
  TextEditingController _username = new TextEditingController();
  TextEditingController _adress = new TextEditingController();

// Future<List> sendappointment() async {
//   final response = await http.post(apipath + '/createAppointment',
//     //"http://192.168.1.6:3040/createAppointment",
//   //  "https://agilemedapp-cn4rzuzz6a-el.a.run.app/createAppointment",
//    body: {
//       "appointment_date":DateFormat('yyyy-MM-dd').format(widget.date),
//     "client_name": name.text,
//     "client_address1": address.text,
//     "description":description.text,
//     "issue":problem.text,

//   });

// }

  String _date,
      name1,
      phone1,
      address1,
      email,
      mobilenumber,
      _problem,
      _localDoctorName,
      _roleid;
  int id;
  String _localid;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getInt("localid");
      _localid = preferences.getString("id");
      _date = preferences.getString("appointment_date");
      name1 = widget.name;
      _localDoctorName = preferences.getString("appointment_date");
      address1 = preferences.getString("adrs");
      _problem = preferences.getString("issue");
      email = widget.email;
      _feespaid = "0.00";
      _roleid = preferences.getString("roleid");
      mobilenumber = widget.phonenumber;
    });
    name = new TextEditingController(text: name1);
    phonenumber = new TextEditingController(text: mobilenumber);
    useremail = new TextEditingController(text: email);
    fees = new TextEditingController(text: _feespaid);
    // problem = new TextEditingController(text: _problem);
    // datetime = new TextEditingController(text: widget.date);
  }

  bool _login = false;
  int _userid;
  String _email;

  String _pphonenum;
  String _feespaid;
  final _formKey = GlobalKey<FormState>();
  final _formKeyfees = GlobalKey<FormState>();
  Future<List> _registerndata() async {
    final response = await http.post(apipath + '/register', body: {
      "username": name.text,
      "address1": address.text,
      'timezone': dateTime.timeZoneName
    }).then((value) async {
      print(value.body);
      var body = json.decode(value.body);
      setState(() {
        _userid = body['user_id'];
        // _login = true;
      });
      SharedPreferences localStorage = await SharedPreferences.getInstance();

      localStorage.setInt('localid', body['user_id']);
      localStorage.setString('token', body['token']);
      localStorage.setString('name', body['username']);
      localStorage.setString('adrs', body['address1']);
    });
    register();
  }

  int appointmentid;
  Future<List> register() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    final response = await http.post(apipath + '/createAppointment', body: {
      "appointment_date": widget.appointment_datetime,
      "client_name": name.text,
      "client_address": address.text,
      "issue": problem.text,
      "user_id": _userid.toString(),
      "holder_id": widget.holderid,
      "user_traiage_result_id": '1',
      'timezone': dateTime.timeZoneName
    }).then((vl) async {
      var body = json.decode(vl.body);
      setState(() {
        _login = true;
      });

      localStorage.setInt('date', body['appointment_date']);
      // localStorage.setString('token', body['token']);
      localStorage.setString('clientname', body['client_name']);
      localStorage.setString('clientadrs', body['client_address']);
      localStorage.setString('prblem', body['issue']);
      print(vl.body);
    });
    if (localStorage.getString("token") != null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => EventSelect()),
          (Route<dynamic> route) => false);
    }
  }

  Future<List> _createappointment() async {
    _formKey.currentState.validate();

    if (useremail.text.length == 0 ||
        phonenumber.text.length == 0 ||
        !useremail.text.contains("@")) {
      return null;
    }

    if (fees.text.length == 0) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Please Enter fees"),
// content: const Text('This item is no longer available'),
            actions: [
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
//     }else if(fees.text=="0" || fees.text=="0.0" || fees.text=="0.00"){
//        return showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text(" fees cant be zero"),
// // content: const Text('This item is no longer available'),
//             actions: [
//               FlatButton(
//                 child: Text('Ok'),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     }
    if (useremail.text == "" || phonenumber.text == "") {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Please, Insert all required fields"),
// content: const Text('This item is no longer available'),
            actions: [
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    } else {
      if (_roleid == "102") {
        final response =
            await http.post(apipath + '/createAppointmentFromDoctor', body: {
          "appointment_date": widget.appointment_datetime.toString(),
          "client_name": name.text,
          "price": fees.text,
          "holder_id": _localid,
          "user_traiage_result_id": '-1',
          "phonenumber": phonenumber.text,
          "email": useremail.text,
          'timezone': dateTime.timeZoneName
        }).then((vl) async {
          var body = json.decode(vl.body);
          if (body['error'] == 'Invalid Email') {
            return null;
          } else if (body == 'No Data Found to create an Appointment..!') {
            return null;
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Doneappointment(
                        doctorname: name.text,
                        // doctoremail: widget.email,
                        appointmenttime: body['appointment_time'],
                        appointmentdate: body['appointment_date'])));
            print(vl.body);
          }
        });
      } else {
        final response =
            await http.post(apipath + '/createAppointmentFromDoctor', body: {
          "appointment_date": widget.appointment_datetime.toString(),
          "client_name": name.text,
          "price": fees.text,
          "holder_id": widget.holderid,
          "user_traiage_result_id": '-1',
          "phonenumber": phonenumber.text,
          "email": useremail.text,
          'timezone': dateTime.timeZoneName
        }).then((vl) async {
          var body = json.decode(vl.body);
          if (body['error'] == 'Invalid Email') {
            return null;
          } else if (body == 'No Data Found to create an Appointment..!') {
            return null;
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Doneappointment(
                        doctorname: name.text,
                        // doctoremail: widget.email,
                        appointmenttime: body['appointment_time'],
                        appointmentdate: body['appointment_date'])));
            print(vl.body);
          }
        });
      }
    }

    // _appointmentybyMonth();
  }

  DateTime dateTime = DateTime.now();
  Future<List> _rescheduleappointment() async {
    // final response = await http.post(apipath + '/rescheduleAppointmnet', body: {
    //   "appointment_id": widget.updateid,
    //   "appointment_date": widget.appointment_datetime ,
    // }).then((value) {
    //   print(value.body);
    // });
    _formKey.currentState.validate();
    if (useremail.text.length == 0 ||
        phonenumber.text.length == 0 ||
        !useremail.text.contains("@")) {
      return null;
    }
    final rs =
        await http.post(apipath + '/modifyAnAppointmentForDoctor', body: {
      "appointment_id": widget.appointment_id,
      "appointment_date": widget.appointment_datetime.toString(),
      "client_name": name.text,
      // "client_address": address.text,
      "user_id": widget.clientid,
      // "description":description.text,
      // "issue": problem.text,
      "phonenumber": phonenumber.text,
      "email": useremail.text,
      "holder_id": widget.holderid,
      "user_traiage_result_id": '-1',
      'timezone': dateTime.timeZoneName
    }).then((vl) async {
      return
          // vl.body;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AppointmentDone(
                      doctorname: name.text,
                      doctoremail: widget.email,
                      appointmenttime: widget.appointment_datetime.toString()
                      //new DateFormat.yMd().add_jm().format(widget.appointment_datetime)
                      )));
      // print(vl.body);
    });
  }

  final String apiUrl = apipath + '/triage_test';

  DateTime _information;
  Future<List<dynamic>> fetchUsers() async {
    var result = await http.get(apiUrl);
    print(result.body);
    return json.decode(result.body);
  }

  void updateInformation(DateTime information) {
    if (information != null) {
      setState(() => widget.appointment_datetime = information);
    }
  }

  var data;
  var bookedtime;
  var onlyDate;
  List booktime;
  moveToSecondPage() async {
    await http.post(apipath + '/getBookedAppointmentSlot', body: {
      "selected_date": DateFormat('yMd').format(widget.appointment_datetime),
      "holder_id": widget.holderid,
      "timezone": dateTime.timeZoneName
    }).then((value) {
      data = json.decode(value.body);
      if (value.body != '[]') {
        booktime = data;
        //   return  Navigator.push(
        // context,
        // MaterialPageRoute(
        //     builder: (context) => Dateselect(
        //         appointment_datetime: widget.appointment_datetime,
        //         bookedtime: data,
        //         endtime: DateTime.parse(widget.endtime),
        //         holderid: widget.holderid,
        //         slotdifference: widget.slotdifference,
        //         starttime: DateTime.parse(widget.starttime))));
      } 
      // else {
      //   //  data = [
      //   //   {
      //   //     "appointment_date": "2021-10-13T01:00:00.000Z",
      //   //     "holder_id": widget.holderid,
      //   //     "appointment_time": "00:00 AM"
      //   //   }
      //   // ];
      //     return  Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => Dateselect(
      //           appointment_datetime: widget.appointment_datetime,
      //           bookedtime: data,
      //           endtime: DateTime.parse(widget.endtime),
      //           holderid: widget.holderid,
      //           slotdifference: widget.slotdifference,
      //           starttime: DateTime.parse(widget.starttime))));
       
      // }
    });
  // return  Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => Dateselect(
  //               appointment_datetime: widget.appointment_datetime,
  //               bookedtime: data,
  //               endtime: DateTime.parse(widget.endtime),
  //               holderid: widget.holderid,
  //               slotdifference: widget.slotdifference,
  //               starttime: DateTime.parse(widget.starttime))));
    DateTime selected_datetime = await Navigator.push(
      context,
      CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) =>
              Dateselect(appointment_datetime: widget.appointment_datetime,
              //DateTime.parse( date+' 04:15:00.000Z'),

         holderid:widget.holderid ,
             bookedtime: data,
           starttime:DateTime.parse(widget.starttime) ,
             endtime: DateTime.parse(widget.endtime),
             slotdifference: widget.slotdifference,
              )),
    );
    updateInformation(selected_datetime);
  }
  // void moveToSecondPage() async {
  //   DateTime selected_datetime = await Navigator.push(
  //     context,
  //     CupertinoPageRoute(
  //         fullscreenDialog: true,
  //         builder: (context) =>
  //             Dateselect(appointment_datetime: widget.appointment_datetime)),
  //   );
  //   updateInformation(selected_datetime);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        //   padding: EdgeInsets.only(top: 15, left: 5, right: 5),
        // color: primarylightcolor,
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
                            color: buttonColor,
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(40.0),
                              topRight: const Radius.circular(40.0),
                            )),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Book an appointment',
                                style: TextStyle(
                                    color: buttonTextColor, fontSize: 18),
                              ),
                            ]),
                      ),
                      Container(
                          height: 140,
                          padding: EdgeInsets.only(top: 2, left: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 3, color: containerBorderColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  child: Row(children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(left: 2),
                                      width: 65,
                                      height: 65,
                                      child: CircleAvatar(
                                        backgroundColor: containerBorderColor,
                                        child: ClipOval(
                                            child: widget.user_image!=null?CachedNetworkImage(
                                              imageUrl: widget.user_image,
                                              fit: BoxFit.fill,
                                              width: 65.0,
                                            ):Image.asset("assets/profile.png")
                                        //     CachedNetworkImage(
                                        //   imageUrl: widget.user_image,
                                        //   fit: BoxFit.fill,
                                        //   width: 65.0,
                                        // )

                                          
                                            ),
                                      ),
                                    ),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: 100,
                                            padding: EdgeInsets.only(
                                                top: 20, left: 11),
                                            child: Text(
                                              widget.doctor == null
                                                  ? widget.name
                                                  : widget.doctor,
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ),
                                          //                                         Row(
                                          //                                           children: [
                                          // Container(

                                          //                                           padding: EdgeInsets.only(left: 11),
                                          //                                           child: Text(
                                          //                                      '${'Availabilty:'+ DateFormat.jm().format(DateTime.parse(widget.starttime))}'         == null
                                          //                                                   ? ""
                                          //                                                   : '${'Availabilty :  '  + DateFormat.jm().format(DateTime.parse(widget.starttime))}' ,
                                          //                                               style: TextStyle(fontSize: 14)),
                                          //                                         ),
                                          //                                         Text('-'),
                                          //                                             Container(

                                          //                                           child: Text(
                                          //                                                       DateFormat.jm().format(DateTime.parse(widget.endtime))  == null
                                          //                                                   ? ""
                                          //                                                   :DateFormat.jm().format(DateTime.parse(widget.endtime)) ,
                                          //                                               style: TextStyle(fontSize: 14)),
                                          //                                         ),
                                          //                                           ],
                                          //                                         )
                                        ]),
                                    SizedBox(
                                      width: 80,
                                    ),
                                    GestureDetector(
                                      child: SvgPicture.asset(
                                          'assets/appointment.svg'),
                                      onTap: () {},
                                    )
                                  ]))
                            ],
                          )),
                      Container(
                          padding:
                              EdgeInsets.only(top: 60, left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              widget.appointment_id == null
                                  ? TextFormField(
                                      controller: name,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: new InputDecoration(
                                          labelText: 'Name',
                                          fillColor: Colors.grey[300],
                                          filled: true,
                                          border: new OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                          )),
                                    )
                                  : TextFormField(
                                      readOnly: true,
                                      controller: name,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: new InputDecoration(
                                          labelText: 'Name',
                                          fillColor: Colors.grey[300],
                                          filled: true,
                                          border: new OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                          )),
                                    ),

                              SizedBox(
                                height: 10,
                              ),
                              Form(
                                  key: _formKey,
                                  child: Column(
                                    children: <Widget>[
                                      widget.appointment_id == null
                                          ? TextFormField(
                                              controller: useremail,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              decoration: new InputDecoration(
                                                  labelText: 'Email',
                                                  fillColor: Colors.grey[300],
                                                  filled: true,
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.0)),
                                                  )),
                                              validator: (val) {
                                                if (val.length == 0)
                                                  return "Please enter email";
                                                else if (!val.contains("@"))
                                                  return "Please enter valid email";
                                              },
                                              onSaved: (val) => _email = val,
                                            )
                                          : TextFormField(
                                              readOnly: true,
                                              controller: useremail,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              decoration: new InputDecoration(
                                                  labelText: 'Email',
                                                  fillColor: Colors.grey[300],
                                                  filled: true,
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.0)),
                                                  )),
                                              validator: (val) {
                                                if (val.length == 0)
                                                  return "Please enter email";
                                                else if (!val.contains("@"))
                                                  return "Please enter valid email";
                                              },
                                              onSaved: (val) => _email = val,
                                            ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      widget.appointment_id == null
                                          ? TextFormField(
                                              controller: phonenumber,
                                              autocorrect: true,
                                              keyboardType:
                                                  TextInputType.number,
                                              maxLength: 15,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                // WhitelistingTextInputFormatter
                                                //     .digitsOnly
                                              ],
                                              decoration: new InputDecoration(
                                                  labelText: 'Phone number',
                                                  fillColor: Colors.grey[300],
                                                  filled: true,
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.0)),
                                                  )),
                                              validator: (val) {
                                                if (val.length == 0)
                                                  return "Please enter phonenumber";
                                              },
                                              onSaved: (val) =>
                                                  _pphonenum = val,
                                            )
                                          : TextFormField(
                                              readOnly: true,
                                              controller: phonenumber,
                                              autocorrect: true,
                                              keyboardType:
                                                  TextInputType.number,
                                              maxLength: 15,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                // WhitelistingTextInputFormatter
                                                //     .digitsOnly
                                              ],
                                              decoration: new InputDecoration(
                                                  labelText: 'Phone number',
                                                  fillColor: Colors.grey[300],
                                                  filled: true,
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.0)),
                                                  )),
                                              validator: (val) {
                                                if (val.length == 0)
                                                  return "Please enter phonenumber";
                                              },
                                              onSaved: (val) =>
                                                  _pphonenum = val,
                                            ),
                                    ],
                                  )),
                              SizedBox(
                                height: 10,
                              ),

                              Container(
                                  child: Row(
                                children: <Widget>[
                                  Container(
                                    width: 150,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.grey),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(
                                        5.0,
                                      )),
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(top: 13, left: 10),
                                      child: Text(
                                        new DateFormat.yMd().add_jm().format(
                                            widget.appointment_datetime
                                                .toLocal()),
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: containerBorderColor),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(
                                        5.0,
                                      )),
                                    ),
                                    child: IconButton(
                                        icon: Icon(Icons.timer),
                                        onPressed: () {
                                          moveToSecondPage();
                                        }),
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Container(
                                    width: 75,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: containerBorderColor,
                                      border: Border.all(
                                          width: 1,
                                          color: containerBorderColor),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(
                                        5.0,
                                      )),
                                    ),
                                    child: widget.total_amount != null
                                        ? Container(
                                            child: Center(
                                            child: Text(widget.total_amount),
                                          ))
                                        : TextFormField(
                                            // key: _formKeyfees,
                                            controller: fees,
                                            keyboardType: TextInputType.number,
                                            decoration: new InputDecoration(
                                                fillColor: Colors.grey[300],
                                                filled: true,
                                                labelText: 'Fees',
                                                contentPadding: EdgeInsets.only(
                                                    left: 14,
                                                    right: 14,
                                                    top: 2),
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5.0)),
                                                )),
                                            onSaved: (val) => _feespaid = val,
                                            validator: (val) {
                                              if (val.length == 0)
                                                return "fees not empty";
                                            },
                                          ),
                                  )
                                ],
                              )),

                              //   ],
                              // ),

                              //   TextFormField(
                              //     //enabled: true,
                              //    showCursor: false,
                              //     //     readOnly: false,
                              //     //       autofocus: false,
                              //  // controller:  datetime,
                              //     //    keyboardType:,
                              //     decoration: new InputDecoration(
                              //         // labelText:  widget.date,
                              //         hintText:
                              //         new DateFormat.yMd().add_jm().format(widget.appointment_datetime),
                              //         // DateFormat('yyyy-MM-dd HH:MM').format(DateTime.parse(_information)),
                              //      //  widget.settime,
                              //         // widget.settime!=null?0:_information,
                              //      //   _information,delete2
                              //         suffixIcon: IconButton(
                              //             icon: Icon(Icons.timer),
                              //             onPressed: () {

                              //               moveToSecondPage();
                              //               //   Navigator.push(context, MaterialPageRoute(builder: (context)=>Dateselect()));
                              //             }),
                              //         border: new OutlineInputBorder(
                              //           borderRadius: BorderRadius.all(
                              //               Radius.circular(5.0)),
                              //         )),

                              //   ),
                              SizedBox(
                                height: 80,
                              ),
                              RaisedButton(
                                child: widget.appointment_id != null
                                    ? Text(
                                        'UPDATE',
                                        style:
                                            TextStyle(color: buttonTextColor),
                                      )
                                    : Text(
                                        'BOOK',
                                        style:
                                            TextStyle(color: buttonTextColor),
                                      ),
                                onPressed: () {
                                  if (widget.appointment_id != null) {
                                    _rescheduleappointment();
                                  } else if (_localid != null) {
                                    _createappointment();
                                  } else {
                                    _registerndata();
                                  }
                                },
                                color: buttonColor,
                              )
                            ],
                          ))
                    ]),
              ],
            )),
      )),
    );
  }
}
