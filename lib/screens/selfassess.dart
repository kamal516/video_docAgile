import 'dart:async';
import 'dart:convert';

import 'package:doctoragileapp/upcomingappntmnt.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../api.dart';
import '../color.dart';

class Selfassess extends StatefulWidget {
  @override
  _TestcatState createState() => _TestcatState();
}

class _TestcatState extends State<Selfassess>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    getid();
  }

  bool monVal = false;
  bool tuVal = false;
  bool wedVal = false;
  bool thurVal = false;
  bool friVal = false;
  bool satVal = false;
  bool sunVal = false;

  String _mondaystarttime = "00:00";
  String _tuesdyastarttime = "00:00";
  String _wednesdaystarttime = "00:00";
  String _thursdaystarttime = "00:00";
  String _fridaystarttime = "00:00";
  String _saturdaystarttime = "00:00";
  String _sundaystarttime = "00:00";

  String _mondayendtime = "00:00";
  String _tuesdyaendtime = "00:00";
  String _wednesdayendtime = "00:00";
  String _thursdayendtime = "00:00";
  String _fridayendtime = "00:00";
  String _saturdayendtime = "00:00";
  String _sundayendtime = "00:00";

  String break_start_time = "00:00";
  String break_end_time = "00:00";

  String availability_till = "00:00";

  String _localid;
  getid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _localid = preferences.getString("id");
    });
    //  _getavailability();
  }

  String timmingid;
  bool _loading;
  List availablitylist;
  _getavailability() async {
    final response =
        await http.post(apipath + '/getDataFromUserTimimng', body: {
      "user_id": _localid,
    }).then((value) async {
      print(value.body);
//  user_timing_id
      setState(() {
        availablitylist = json.decode(value.body);
      });

      print(availablitylist);

      monVal = availablitylist[0]['monday'];
      tuVal = availablitylist[0]['tuesday'];
      wedVal = availablitylist[0]['wednesday'];
      thurVal = availablitylist[0]['thursday'];
      friVal = availablitylist[0]['friday'];
      satVal = availablitylist[0]['saturday'];
      sunVal = availablitylist[0]['sunday'];

      _mondaystarttime = availablitylist[0]['monday_start_time'];
      _mondayendtime = availablitylist[0]['monday_end_time'];

      _tuesdyastarttime = availablitylist[0]['tuesday_start_time'];
      _tuesdyaendtime = availablitylist[0]['tuesday_end_time'];

      _wednesdaystarttime = availablitylist[0]['wednesday_start_time'];
      _wednesdayendtime = availablitylist[0]['wednesday_end_time'];

      _thursdaystarttime = availablitylist[0]['thursday_start_time'];
      _thursdayendtime = availablitylist[0]['thursday_end_time'];

      _fridaystarttime = availablitylist[0]['friday_start_time'];
      _fridayendtime = availablitylist[0]['friday_end_time'];

      _saturdaystarttime = availablitylist[0]['saturday_start_time'];
      _saturdayendtime = availablitylist[0]['saturday_end_time'];

      _sundaystarttime = availablitylist[0]['sunday_start_time'];
      _sundayendtime = availablitylist[0]['sunday_end_time'];

      break_start_time = availablitylist[0]['break_start_time'];
      break_end_time = availablitylist[0]['break_end_time'];

      availability_till = availablitylist[0]['availability_till'];
    });
  }

  void _loadingCall(bool value, BuildContext context) {
    if (value == true) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: buttonColor,
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  color: buttonColor,
                  child: Column(
                    children: <Widget>[
                      new CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      new Text(
                        "Loading...",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      );
    } else {
      Navigator.pop(context);
    }
  }
DateTime _currenttime = DateTime.now();
  Future<List> _registeravailabilitybyweek(String week) async {
    // if(availablitylist[0]['user_timing_id']==null){
    // setState(() {
    //   _loading = true;
    //   _loadingCall(_loading, context);
    // });
    print(week);
    final response =
        await http.post(apipath + '/getDataFromDoctorAvailability', body: {
      "user_id": _localid,
      "week": week,
      'timezone':_currenttime.timeZoneName.toString()
    }).then((value) async {
      print(value.body);
    
      setState(() {
        availablitylist = json.decode(value.body);
        if (availablitylist.length == 0) {
          print("object");
  // setState(() {
  //       _loading = false;
  //       _loadingCall(_loading, context);
  //     });
          setState(() {
            monVal = false;
            tuVal = false;
            wedVal = false;
            thurVal = false;
            friVal = false;
            satVal = false;
            sunVal = false;
          });
          break_start_time = "00:00";
          break_end_time = "00:00";
          availability_till = "00:00";
          _mondaystarttime = "00:00";
          _tuesdyastarttime = "00:00";
          _wednesdaystarttime = "00:00";
          _thursdaystarttime = "00:00";
          _fridaystarttime = "00:00";
          _saturdaystarttime = "00:00";
          _sundaystarttime = "00:00";
          _mondayendtime = "00:00";
          _tuesdyaendtime = "00:00";
          _wednesdayendtime = "00:00";
          _thursdayendtime = "00:00";
          _fridayendtime = "00:00";
          _saturdayendtime = "00:00";
          _sundayendtime = "00:00";
          // _mondaystarttime="00:00";
        } else {
      //   setState(() {
      //   _loading = false;
      //   _loadingCall(_loading, context);
      // });
          monVal = availablitylist[0]['monday'];
          tuVal = availablitylist[0]['tuesday'];
          wedVal = availablitylist[0]['wednesday'];
          thurVal = availablitylist[0]['thursday'];
          friVal = availablitylist[0]['friday'];
          satVal = availablitylist[0]['saturday'];
          sunVal = availablitylist[0]['sunday'];

          _mondaystarttime = availablitylist[0]['monday_start_time'];
          _mondayendtime = availablitylist[0]['monday_end_time'];

          _tuesdyastarttime = availablitylist[0]['tuesday_start_time'];
          _tuesdyaendtime = availablitylist[0]['tuesday_end_time'];

          _wednesdaystarttime = availablitylist[0]['wednesday_start_time'];
          _wednesdayendtime = availablitylist[0]['wednesday_end_time'];

          _thursdaystarttime = availablitylist[0]['thursday_start_time'];
          _thursdayendtime = availablitylist[0]['thursday_end_time'];

          _fridaystarttime = availablitylist[0]['friday_start_time'];
          _fridayendtime = availablitylist[0]['friday_end_time'];

          _saturdaystarttime = availablitylist[0]['saturday_start_time'];
          _saturdayendtime = availablitylist[0]['saturday_end_time'];

          _sundaystarttime = availablitylist[0]['sunday_start_time'];
          _sundayendtime = availablitylist[0]['sunday_end_time'];

          break_start_time = availablitylist[0]['break_start_time'];
          break_end_time = availablitylist[0]['break_end_time'];

          availability_till = availablitylist[0]['availability_till'];
        }
      });

      //  Navigator.pop(context);
    });
  }

  Future<List> _registeravailability() async {
    //  if(availablitylist[0]['user_timing_id']==null){345
    if (availablitylist.length == 0) {
      final response =
          await http.post(apipath + '/setavailabilityfordoctor', body: {
        "user_id": _localid,
        "title": "Timing",
        "description": "New week timing",
        "monday": monVal.toString(),
        "tuesday": tuVal.toString(),
        "wednesday": wedVal.toString(),
        "thursday": thurVal.toString(),
        "friday": friVal.toString(),
        "saturday": satVal.toString(),
        "sunday": sunVal.toString(),
        "monday_start_time": _mondaystarttime,
        "monday_end_time": _mondayendtime,
        "tuesday_start_time": _tuesdyastarttime,
        "tuesday_end_time": _tuesdyaendtime,
        "wednesday_start_time": _wednesdaystarttime,
        "wednesday_end_time": _wednesdayendtime,
        "thursday_start_time": _thursdaystarttime,
        "thursday_end_time": _thursdayendtime,
        "friday_start_time": _fridaystarttime,
        "friday_end_time": _fridayendtime,
        "saturday_start_time": _saturdaystarttime,
        "saturday_end_time": _saturdayendtime,
        "sunday_start_time": _sundaystarttime,
        "sunday_end_time": _sundayendtime,
        "break_start_time": break_start_time,
        "break_end_time": break_end_time,
        "availability_till": availability_till,
        // "user_timing_id": userTiming,
        "week": _weekCount
      }).then((value) async {
        print(value.body);
           showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
        // title: Text('Not in stock'),
        content: const Text('Save Done'),
        actions: [
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
          // return Dialog(
          //   backgroundColor: primarydarkcolor,
          //   child: new Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Container(
          //         padding: EdgeInsets.all(10),
          //         color: primarydarkcolor,
          //         child: Column(
          //           children: <Widget>[
          //             new CircularProgressIndicator(
          //               backgroundColor: Colors.white,
          //             ),
          //             SizedBox(
          //               height: 5,
          //             ),
          //             new Text(
          //               "Loading...",
          //               style: TextStyle(color: Colors.white),
          //             ),
          //           ],
          //         ),
          //       )
          //     ],
          //   ),
          // );
        },
      );
   setState(() {
            monVal = false;
            tuVal = false;
            wedVal = false;
            thurVal = false;
            friVal = false;
            satVal = false;
            sunVal = false;
          });
          break_start_time = "00:00";
          break_end_time = "00:00";
          availability_till = "00:00";
      });
    } else {
      final response =
        await http.post(apipath + '/setavailabilityfordoctor', body: {
        "user_timing_id": availablitylist[0]['user_timing_id'].toString(),
        "week": _weekCount,
        "user_id": _localid,
        "title": "Timing",
        "description": "New week timing",
        "monday": monVal.toString(),
        "tuesday": tuVal.toString(),
        "wednesday": wedVal.toString(),
        "thursday": thurVal.toString(),
        "friday": friVal.toString(),
        "saturday": satVal.toString(),
        "sunday": sunVal.toString(),
        "monday_start_time": _mondaystarttime,
        "monday_end_time": _mondayendtime,
        "tuesday_start_time": _tuesdyastarttime,
        "tuesday_end_time": _tuesdyaendtime,
        "wednesday_start_time": _wednesdaystarttime,
        "wednesday_end_time": _wednesdayendtime,
        "thursday_start_time": _thursdaystarttime,
        "thursday_end_time": _thursdayendtime,
        "friday_start_time": _fridaystarttime,
        "friday_end_time": _fridayendtime,
        "saturday_start_time": _saturdaystarttime,
        "saturday_end_time": _saturdayendtime,
        "sunday_start_time": _sundaystarttime,
        "sunday_end_time": _sundayendtime,
        "break_start_time": break_start_time,
        "break_end_time": break_end_time,
        "availability_till": availability_till,
      }).then((value) async {
        print(value.body);
         showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
        // title: Text('Not in stock'),
        content: const Text('Update Done'),
        actions: [
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
        setState(() {
            monVal = false;
            tuVal = false;
            wedVal = false;
            thurVal = false;
            friVal = false;
            satVal = false;
            sunVal = false;
          });
          break_start_time = "00:00";
          break_end_time = "00:00";
          availability_till = "00:00";
      });
    }
  }

  String dropdownValue = "Week 1";
  String _weekCount = "";
  Widget checkbox(String title, bool boolValue) {
    return Row(
      children: <Widget>[
        Text(title),
        Padding(
            padding: EdgeInsets.only(left: 15),
            child: Checkbox(
              value: boolValue,
              onChanged: (bool value) {
                setState(() {
                  switch (title) {
                    case "Monday      ":
                      monVal = value;
                      if (value == false) {
                        _mondaystarttime = '00:00';
                        _mondayendtime = '00:00';
                      }

                      break;
                    case "Tuesday      ":
                      tuVal = value;
                     if (value == false) {
                        _tuesdyaendtime = '00:00';
                        _tuesdyastarttime = '00:00';
                      }
                      break;
                    case "Wednesday":
                      wedVal = value;
                    if (value == false) {
                        _wednesdaystarttime = '00:00';
                        _wednesdayendtime = '00:00';
                      }
                      break;
                    case "Thursday    ":
                      thurVal = value;
                    if (value == false) {
                        _thursdaystarttime = '00:00';
                        _thursdayendtime = '00:00';
                      }
                      break;
                    case "Friday          ":
                      friVal = value;
                      if (value == false) {
                        _fridaystarttime = '00:00';
                        _fridayendtime = '00:00';
                      }
                      break;
                    case "Saturday     ":
                      satVal = value;
                     if (value == false) {
                        _saturdaystarttime = '00:00';
                        _saturdayendtime = '00:00';
                      }
                      break;
                    case "Sunday        ":
                      sunVal = value;
                      if (value == false) {
                        _sundaystarttime = '00:00';
                        _sundayendtime = '00:00';
                      }
                      break;
                  }
                });
              },
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: RaisedButton(
            child: Text(
              'DONE',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              _registeravailability();
            },
            color: buttonColor,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              top: 15,
            ),
            // color: primarydarkcolor,
            child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(40.0),
                      topRight: const Radius.circular(40.0),
                      bottomLeft: const Radius.circular(1.0),
                      bottomRight: const Radius.circular(1.0),
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
                            child: Row(children: <Widget>[
                              IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              // SizedBox(
                              //   width: 80,
                              // ),
                              Text(
                                'AVAILABILITY',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 19),
                              ),
                            ]),
                          ),
                        ]),

                    Container(
                        height: (MediaQuery.of(context).size.height - 140),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.only(top: 0),
                        child: Container(
                            height: 400,
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Container(
                                          width: 120,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: dropdownValue,
                                              //  widget.getclientdata==null? dropdownValue: widget.getclientdata.clientcourt,
                                              icon: const Icon(
                                                  Icons.arrow_drop_down),
                                              iconSize: 24,
                                              elevation: 16,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              underline: Container(
                                                height: 2,
                                                color: Colors.black,
                                              ),
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  dropdownValue = newValue;
                                                  _weekCount = dropdownValue
                                                      .replaceAll("Week ", "");
                                                  _registeravailabilitybyweek(
                                                      _weekCount);
                                                  // widget.getclientdata.clientcourt= dropdownValue;
                                                });
                                              },
                                              items: <String>[
                                                'Week 1',
                                                'Week 2',
                                                'Week 3',
                                                'Week 4'
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                // setState(() {
                                                //    courtname = widget.getclientdata.clientcourt;
                                                // });
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ))),
                                  Column(
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              (monVal == false)
                                                  ? checkbox(
                                                      "Monday      ", monVal)
                                                  : Column(
                                                      children: <Widget>[
                                                        checkbox("Monday      ",
                                                            monVal),
                                                        Row(
                                                          children: <Widget>[
                                                            RaisedButton(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0)),
                                                              elevation: 4.0,
                                                              onPressed: () {
                                                                DatePicker.showTime12hPicker(
                                                                    context,
                                                                    theme:
                                                                        DatePickerTheme(
                                                                      containerHeight:
                                                                          210.0,
                                                                    ),
                                                                    showTitleActions:
                                                                        true,
                                                                    onConfirm:
                                                                        (time) {
                                                                  print(
                                                                      'confirm $time');

                                                                  setState(() {
                                                                    _mondaystarttime =
                                                                        '${time.hour}:${time.minute}';
                                                                  });
                                                                },
                                                                    currentTime:
                                                                        DateTime
                                                                            .now(),
                                                                    locale:
                                                                        LocaleType
                                                                            .en);
                                                                setState(() {});
                                                              },
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                height: 50.0,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                    Row(
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          child:
                                                                              Row(
                                                                            children: <Widget>[
                                                                              Icon(
                                                                                Icons.access_time,
                                                                                size: 18.0,
                                                                                color: Colors.teal,
                                                                              ),
                                                                              Text(
                                                                                " $_mondaystarttime",
                                                                                style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 18.0),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    // Text(
                                                                    //   "  Start time",
                                                                    //   style: TextStyle(
                                                                    //       color: Colors.teal,
                                                                    //       fontWeight: FontWeight.bold,
                                                                    //       fontSize: 18.0),
                                                                    // ),
                                                                  ],
                                                                ),
                                                              ),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            RaisedButton(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0)),
                                                              elevation: 4.0,
                                                              onPressed: () {
                                                                DatePicker.showTime12hPicker(
                                                                    context,
                                                                    theme:
                                                                        DatePickerTheme(
                                                                      containerHeight:
                                                                          210.0,
                                                                    ),
                                                                    showTitleActions:
                                                                        true,
                                                                    // minTime:  DateFormat("hh:mm").parse(_mondaystarttime),

                                                                    onConfirm:
                                                                        (time) {
                                                                  print(
                                                                      'confirm $time');
                                                                  _mondayendtime =
                                                                      '${time.hour}:${time.minute}';
                                                                  setState(
                                                                      () {});
                                                                },
                                                                    currentTime: DateFormat(
                                                                            "hh:mm")
                                                                        .parse(
                                                                            _mondaystarttime),
                                                                    locale:
                                                                        LocaleType
                                                                            .en);
                                                                setState(() {});
                                                              },
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                height: 50.0,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                    Row(
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          child:
                                                                              Row(
                                                                            children: <Widget>[
                                                                              Icon(
                                                                                Icons.access_time,
                                                                                size: 18.0,
                                                                                color: Colors.teal,
                                                                              ),
                                                                              Text(
                                                                                " $_mondayendtime",
                                                                                style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 18.0),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    // Text(
                                                                    //   "  End time",
                                                                    //   style: TextStyle(
                                                                    //       color: Colors.teal,
                                                                    //       fontWeight: FontWeight.bold,
                                                                    //       fontSize: 18.0),
                                                                    // ),
                                                                  ],
                                                                ),
                                                              ),
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                            ],
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              (tuVal == false)
                                                  ? checkbox(
                                                      "Tuesday      ", tuVal)
                                                  : Column(
                                                      children: <Widget>[
                                                        checkbox(
                                                            "Tuesday      ",
                                                            tuVal),
                                                        Row(
                                                          children: <Widget>[
                                                            RaisedButton(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0)),
                                                              elevation: 4.0,
                                                              onPressed: () {
                                                                DatePicker.showTime12hPicker(
                                                                    context,
                                                                    theme:
                                                                        DatePickerTheme(
                                                                      containerHeight:
                                                                          210.0,
                                                                    ),
                                                                    showTitleActions:
                                                                        true,
                                                                    onConfirm:
                                                                        (time) {
                                                                  print(
                                                                      'confirm $time');
                                                                  _tuesdyastarttime =
                                                                      '${time.hour}:${time.minute}';
                                                                  setState(
                                                                      () {});
                                                                },
                                                                    currentTime:
                                                                        DateTime
                                                                            .now(),
                                                                    locale:
                                                                        LocaleType
                                                                            .en);
                                                                setState(() {});
                                                              },
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                height: 50.0,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                    Row(
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          child:
                                                                              Row(
                                                                            children: <Widget>[
                                                                              Icon(
                                                                                Icons.access_time,
                                                                                size: 18.0,
                                                                                color: Colors.teal,
                                                                              ),
                                                                              Text(
                                                                                " $_tuesdyastarttime",
                                                                                style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 18.0),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            RaisedButton(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0)),
                                                              elevation: 4.0,
                                                              onPressed: () {
                                                                DatePicker.showTime12hPicker(
                                                                    context,
                                                                    theme:
                                                                        DatePickerTheme(
                                                                      containerHeight:
                                                                          210.0,
                                                                    ),
                                                                    //  minTime:DateFormat("hh:mm").parse(_tuesdyastarttime) ,
                                                                    showTitleActions:
                                                                        true,
                                                                    onConfirm:
                                                                        (time) {
                                                                  print(
                                                                      'confirm $time');
                                                                  _tuesdyaendtime =
                                                                      '${time.hour}:${time.minute}';
                                                                  setState(
                                                                      () {});
                                                                },
                                                                    currentTime: DateFormat(
                                                                            "hh:mm")
                                                                        .parse(
                                                                            _tuesdyastarttime),
                                                                    locale:
                                                                        LocaleType
                                                                            .en);
                                                                setState(() {});
                                                              },
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                height: 50.0,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                    Row(
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          child:
                                                                              Row(
                                                                            children: <Widget>[
                                                                              Icon(
                                                                                Icons.access_time,
                                                                                size: 18.0,
                                                                                color: Colors.teal,
                                                                              ),
                                                                              Text(
                                                                                " $_tuesdyaendtime",
                                                                                style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 18.0),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                            ],
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              (wedVal == false)
                                                  ? checkbox(
                                                      "Wednesday", wedVal)
                                                  : Column(
                                                      children: <Widget>[
                                                        checkbox("Wednesday",
                                                            wedVal),
                                                        Row(
                                                          children: <Widget>[
                                                            RaisedButton(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0)),
                                                              elevation: 4.0,
                                                              onPressed: () {
                                                                DatePicker.showTime12hPicker(
                                                                    context,
                                                                    theme:
                                                                        DatePickerTheme(
                                                                      containerHeight:
                                                                          210.0,
                                                                    ),
                                                                    showTitleActions:
                                                                        true,
                                                                    onConfirm:
                                                                        (time) {
                                                                  print(
                                                                      'confirm $time');
                                                                  _wednesdaystarttime =
                                                                      '${time.hour}:${time.minute}';
                                                                  setState(
                                                                      () {});
                                                                },
                                                                    currentTime:
                                                                        DateTime
                                                                            .now(),
                                                                    locale:
                                                                        LocaleType
                                                                            .en);
                                                                setState(() {});
                                                              },
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                height: 50.0,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                    Row(
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          child:
                                                                              Row(
                                                                            children: <Widget>[
                                                                              Icon(
                                                                                Icons.access_time,
                                                                                size: 18.0,
                                                                                color: Colors.teal,
                                                                              ),
                                                                              Text(
                                                                                " $_wednesdaystarttime",
                                                                                style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 18.0),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            RaisedButton(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0)),
                                                              elevation: 4.0,
                                                              onPressed: () {
                                                                DatePicker.showTime12hPicker(
                                                                    context,
                                                                    theme:
                                                                        DatePickerTheme(
                                                                      containerHeight:
                                                                          210.0,
                                                                    ),
                                                                    //     minTime: DateFormat("hh:mm").parse(_wednesdaystarttime),
                                                                    showTitleActions:
                                                                        true,
                                                                    onConfirm:
                                                                        (time) {
                                                                  print(
                                                                      'confirm $time');
                                                                  _wednesdayendtime =
                                                                      '${time.hour}:${time.minute}';
                                                                  setState(
                                                                      () {});
                                                                },
                                                                    currentTime: DateFormat(
                                                                            "hh:mm")
                                                                        .parse(
                                                                            _wednesdaystarttime),
                                                                    locale:
                                                                        LocaleType
                                                                            .en);
                                                                setState(() {});
                                                              },
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                height: 50.0,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                    Row(
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          child:
                                                                              Row(
                                                                            children: <Widget>[
                                                                              Icon(
                                                                                Icons.access_time,
                                                                                size: 18.0,
                                                                                color: Colors.teal,
                                                                              ),
                                                                              Text(
                                                                                " $_wednesdayendtime",
                                                                                style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 18.0),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                            ],
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              (thurVal == false)
                                                  ? checkbox(
                                                      "Thursday    ", thurVal)
                                                  : Column(
                                                      children: <Widget>[
                                                        checkbox("Thursday    ",
                                                            thurVal),
                                                        Row(children: <Widget>[
                                                          RaisedButton(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0)),
                                                            elevation: 4.0,
                                                            onPressed: () {
                                                              DatePicker.showTime12hPicker(
                                                                  context,
                                                                  theme:
                                                                      DatePickerTheme(
                                                                    containerHeight:
                                                                        210.0,
                                                                  ),
                                                                  showTitleActions:
                                                                      true,
                                                                  onConfirm:
                                                                      (time) {
                                                                print(
                                                                    'confirm $time');
                                                                _thursdaystarttime =
                                                                    '${time.hour}:${time.minute}';
                                                                setState(() {});
                                                              },
                                                                  currentTime:
                                                                      DateTime
                                                                          .now(),
                                                                  locale:
                                                                      LocaleType
                                                                          .en);
                                                              setState(() {});
                                                            },
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: 50.0,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: <
                                                                    Widget>[
                                                                  Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                        child:
                                                                            Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Icon(
                                                                              Icons.access_time,
                                                                              size: 18.0,
                                                                              color: Colors.teal,
                                                                            ),
                                                                            Text(
                                                                              " $_thursdaystarttime",
                                                                              style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 18.0),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            color: Colors.white,
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          RaisedButton(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0)),
                                                            elevation: 4.0,
                                                            onPressed: () {
                                                              DatePicker.showTime12hPicker(
                                                                  context,
                                                                  theme:
                                                                      DatePickerTheme(
                                                                    containerHeight:
                                                                        210.0,
                                                                  ),
                                                                  showTitleActions:
                                                                      true,
                                                                  //  minTime: DateFormat("hh:mm").parse(_thursdaystarttime),
                                                                  onConfirm:
                                                                      (time) {
                                                                print(
                                                                    'confirm $time');
                                                                _thursdayendtime =
                                                                    '${time.hour}:${time.minute}';
                                                                setState(() {});
                                                              },
                                                                  currentTime: DateFormat(
                                                                          "hh:mm")
                                                                      .parse(
                                                                          _thursdaystarttime),
                                                                  locale:
                                                                      LocaleType
                                                                          .en);
                                                              setState(() {});
                                                            },
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: 50.0,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: <
                                                                    Widget>[
                                                                  Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                        child:
                                                                            Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Icon(
                                                                              Icons.access_time,
                                                                              size: 18.0,
                                                                              color: Colors.teal,
                                                                            ),
                                                                            Text(
                                                                              " $_thursdayendtime",
                                                                              style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 18.0),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            color: Colors.white,
                                                          ),
                                                        ])
                                                      ],
                                                    ),
                                            ],
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              (friVal == false)
                                                  ? checkbox("Friday          ",
                                                      friVal)
                                                  : Column(
                                                      children: <Widget>[
                                                        checkbox(
                                                            "Friday          ",
                                                            friVal),
                                                        Row(children: <Widget>[
                                                          RaisedButton(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0)),
                                                            elevation: 4.0,
                                                            onPressed: () {
                                                              DatePicker.showTime12hPicker(
                                                                  context,
                                                                  theme:
                                                                      DatePickerTheme(
                                                                    containerHeight:
                                                                        210.0,
                                                                  ),
                                                                  showTitleActions:
                                                                      true,
                                                                  onConfirm:
                                                                      (time) {
                                                                print(
                                                                    'confirm $time');
                                                                _fridaystarttime =
                                                                    '${time.hour}:${time.minute}';
                                                                setState(() {});
                                                              },
                                                                  currentTime:
                                                                      DateTime
                                                                          .now(),
                                                                  locale:
                                                                      LocaleType
                                                                          .en);
                                                              setState(() {});
                                                            },
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: 50.0,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: <
                                                                    Widget>[
                                                                  Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                        child:
                                                                            Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Icon(
                                                                              Icons.access_time,
                                                                              size: 18.0,
                                                                              color: Colors.teal,
                                                                            ),
                                                                            Text(
                                                                              " $_fridaystarttime",
                                                                              style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 18.0),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            color: Colors.white,
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          RaisedButton(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0)),
                                                            elevation: 4.0,
                                                            onPressed: () {
                                                              DatePicker.showTime12hPicker(
                                                                  context,
                                                                  theme:
                                                                      DatePickerTheme(
                                                                    containerHeight:
                                                                        210.0,
                                                                  ),
                                                                  showTitleActions:
                                                                      true,
                                                                  //  minTime: DateFormat("hh:mm").parse(_fridaystarttime),
                                                                  onConfirm:
                                                                      (time) {
                                                                print(
                                                                    'confirm $time');
                                                                _fridayendtime =
                                                                    '${time.hour}:${time.minute}';
                                                                setState(() {});
                                                              },
                                                                  currentTime: DateFormat(
                                                                          "hh:mm")
                                                                      .parse(
                                                                          _fridaystarttime),
                                                                  locale:
                                                                      LocaleType
                                                                          .en);
                                                              setState(() {});
                                                            },
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: 50.0,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: <
                                                                    Widget>[
                                                                  Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                        child:
                                                                            Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Icon(
                                                                              Icons.access_time,
                                                                              size: 18.0,
                                                                              color: Colors.teal,
                                                                            ),
                                                                            Text(
                                                                              " $_fridayendtime",
                                                                              style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 18.0),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            color: Colors.white,
                                                          ),
                                                        ])
                                                      ],
                                                    ),
                                            ],
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              (satVal == false)
                                                  ? checkbox(
                                                      "Saturday     ", satVal)
                                                  : Column(
                                                      children: <Widget>[
                                                        checkbox(
                                                            "Saturday     ",
                                                            satVal),
                                                        Row(children: <Widget>[
                                                          RaisedButton(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0)),
                                                            elevation: 4.0,
                                                            onPressed: () {
                                                              DatePicker.showTime12hPicker(
                                                                  context,
                                                                  theme:
                                                                      DatePickerTheme(
                                                                    containerHeight:
                                                                        210.0,
                                                                  ),
                                                                  showTitleActions:
                                                                      true,
                                                                  onConfirm:
                                                                      (time) {
                                                                print(
                                                                    'confirm $time');
                                                                _saturdaystarttime =
                                                                    '${time.hour}:${time.minute}';
                                                                setState(() {});
                                                              },
                                                                  currentTime:
                                                                      DateTime
                                                                          .now(),
                                                                  locale:
                                                                      LocaleType
                                                                          .en);
                                                              setState(() {});
                                                            },
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: 50.0,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: <
                                                                    Widget>[
                                                                  Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                        child:
                                                                            Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Icon(
                                                                              Icons.access_time,
                                                                              size: 18.0,
                                                                              color: Colors.teal,
                                                                            ),
                                                                            Text(
                                                                              " $_saturdaystarttime",
                                                                              style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 18.0),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            color: Colors.white,
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          RaisedButton(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0)),
                                                            elevation: 4.0,
                                                            onPressed: () {
                                                              DatePicker.showTime12hPicker(
                                                                  context,
                                                                  theme:
                                                                      DatePickerTheme(
                                                                    containerHeight:
                                                                        210.0,
                                                                  ),
                                                                  showTitleActions:
                                                                      true,
                                                                  //  minTime:DateFormat("hh:mm").parse(_saturdaystarttime) ,
                                                                  onConfirm:
                                                                      (time) {
                                                                print(
                                                                    'confirm $time');
                                                                _saturdayendtime =
                                                                    '${time.hour}:${time.minute}';
                                                                setState(() {});
                                                              },
                                                                  currentTime: DateFormat(
                                                                          "hh:mm")
                                                                      .parse(
                                                                          _saturdaystarttime),
                                                                  locale:
                                                                      LocaleType
                                                                          .en);
                                                              setState(() {});
                                                            },
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: 50.0,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: <
                                                                    Widget>[
                                                                  Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                        child:
                                                                            Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Icon(
                                                                              Icons.access_time,
                                                                              size: 18.0,
                                                                              color: Colors.teal,
                                                                            ),
                                                                            Text(
                                                                              " $_saturdayendtime",
                                                                              style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 18.0),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            color: Colors.white,
                                                          ),
                                                        ])
                                                      ],
                                                    ),
                                            ],
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              (sunVal == false)
                                                  ? checkbox(
                                                      "Sunday        ", sunVal)
                                                  : Column(
                                                      children: <Widget>[
                                                        checkbox(
                                                            "Sunday        ",
                                                            sunVal),
                                                        Row(
                                                          children: <Widget>[
                                                            RaisedButton(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0)),
                                                              elevation: 4.0,
                                                              onPressed: () {
                                                                DatePicker.showTime12hPicker(
                                                                    context,
                                                                    theme:
                                                                        DatePickerTheme(
                                                                      containerHeight:
                                                                          210.0,
                                                                    ),
                                                                    showTitleActions:
                                                                        true,
                                                                    onConfirm:
                                                                        (time) {
                                                                  print(
                                                                      'confirm $time');
                                                                  _sundaystarttime =
                                                                      '${time.hour}:${time.minute}';
                                                                  setState(
                                                                      () {});
                                                                },
                                                                    currentTime:
                                                                        DateTime
                                                                            .now(),
                                                                    locale:
                                                                        LocaleType
                                                                            .en);
                                                                setState(() {});
                                                              },
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                height: 50.0,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                    Row(
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          child:
                                                                              Row(
                                                                            children: <Widget>[
                                                                              Icon(
                                                                                Icons.access_time,
                                                                                size: 18.0,
                                                                                color: Colors.teal,
                                                                              ),
                                                                              Text(
                                                                                " $_sundaystarttime",
                                                                                style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 18.0),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            RaisedButton(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0)),
                                                              elevation: 4.0,
                                                              onPressed: () {
                                                                DatePicker.showTime12hPicker(
                                                                    context,
                                                                    theme:
                                                                        DatePickerTheme(
                                                                      containerHeight:
                                                                          210.0,
                                                                    ),
                                                                    showTitleActions:
                                                                        true,
                                                                    //  minTime:DateFormat("hh:mm").parse(_sundaystarttime) ,
                                                                    onConfirm:
                                                                        (time) {
                                                                  print(
                                                                      'confirm $time');
                                                                  _sundayendtime =
                                                                      '${time.hour}:${time.minute}';
                                                                  setState(
                                                                      () {});
                                                                },
                                                                    currentTime: DateFormat(
                                                                            "hh:mm")
                                                                        .parse(
                                                                            _sundaystarttime),
                                                                    locale:
                                                                        LocaleType
                                                                            .en);
                                                                setState(() {});
                                                              },
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                height: 50.0,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                    Row(
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          child:
                                                                              Row(
                                                                            children: <Widget>[
                                                                              Icon(
                                                                                Icons.access_time,
                                                                                size: 18.0,
                                                                                color: Colors.teal,
                                                                              ),
                                                                              Text(
                                                                                " $_sundayendtime",
                                                                                style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 18.0),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                            ],
                                          )),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Container(
                                        height: 30,
                                        width: 450,
                                        color: Colors.grey[300],
                                        alignment: Alignment.center,
                                        child: Text(
                                          'BreakTime',
                                          style: TextStyle(fontSize: 20),
                                        )),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: 10, right: 10, left: 10),
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0)),
                                            elevation: 4.0,
                                            onPressed: () {
                                              DatePicker.showTime12hPicker(
                                                  context,
                                                  theme: DatePickerTheme(
                                                    containerHeight: 210.0,
                                                  ),
                                                  showTitleActions: true,
                                                  onConfirm: (time) {
                                                print('confirm $time');
                                                break_start_time =
                                                    '${time.hour}:${time.minute}';
                                                setState(() {});
                                              },
                                                  currentTime: DateTime.now(),
                                                  locale: LocaleType.en);
                                              setState(() {});
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: 50.0,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Container(
                                                        child: Row(
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons.access_time,
                                                              size: 18.0,
                                                              color:
                                                                  Colors.teal,
                                                            ),
                                                            Text(
                                                              " $break_start_time",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .teal,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      18.0),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            color: Colors.white,
                                          )),
                                      // SizedBox(width: 10),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: 10, right: 10, left: 10),
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0)),
                                            elevation: 4.0,
                                            onPressed: () {
                                              DatePicker.showTime12hPicker(
                                                  context,
                                                  theme: DatePickerTheme(
                                                    containerHeight: 210.0,
                                                  ),
                                                  showTitleActions: true,
                                                  onConfirm: (time) {
                                                print('confirm $time');
                                                break_end_time =
                                                    '${time.hour}:${time.minute}';
                                                setState(() {});
                                              },
                                                  currentTime: DateTime.now(),
                                                  locale: LocaleType.en);
                                              setState(() {});
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: 50.0,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Container(
                                                        child: Row(
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons.access_time,
                                                              size: 18.0,
                                                              color:
                                                                  Colors.teal,
                                                            ),
                                                            Text(
                                                              " $break_end_time",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .teal,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      18.0),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            color: Colors.white,
                                          )),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 8),
                                    child: Container(
                                        height: 30,
                                        width: 450,
                                        color: Colors.grey[300],
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Availability Till',
                                          style: TextStyle(fontSize: 20),
                                        )),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 5, right: 10, left: 10),
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        elevation: 4.0,
                                        onPressed: () {
                                          DatePicker.showTime12hPicker(context,
                                              theme: DatePickerTheme(
                                                containerHeight: 210.0,
                                              ),
                                              showTitleActions: true,
                                              onConfirm: (time) {
                                            print('confirm $time');
                                            availability_till =
                                                '${time.hour}:${time.minute}';
                                            setState(() {});
                                          },
                                              currentTime: DateTime.now(),
                                              locale: LocaleType.en);
                                          setState(() {});
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 50.0,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.access_time,
                                                          size: 18.0,
                                                          color: Colors.teal,
                                                        ),
                                                        Text(
                                                          " $availability_till",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.teal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18.0),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        color: Colors.white,
                                      )),
                                ],
                              ),
                            )
                          )
                        ),
                    // SizedBox(height: 40,),
                  ],
                )),
          ),
        ));
  }
}
