import 'dart:convert';
import 'dart:math';
import 'package:angles/angles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doctoragileapp/color.dart';
import 'package:http/http.dart' as http;
import 'package:doctoragileapp/color.dart';
import 'package:doctoragileapp/upcomingappntmnt.dart';
import 'package:doctoragileapp/upcomingappntmnt.dart';
import 'package:doctoragileapp/upcomingappntmnt.dart';

class AppointmentDone extends StatefulWidget {
  final double size;
  final VoidCallback onComplete;
  final String doctorname;
  final String doctoremail;
  final String appointmenttime;
  final String  appointmentdate;
  AppointmentDone({this.size,this.doctoremail,this.appointmenttime,this.appointmentdate,this.doctorname, this.onComplete});
  @override
  _TestcatState createState() => _TestcatState();
}

class _TestcatState extends State<AppointmentDone>
    with SingleTickerProviderStateMixin {
  String _catg(dynamic user) {
    return user['category'];
  }

  bool pressAttention = false;
  bool secondattention = false;
  int _id;
  String _description(dynamic user) {
    return user['description'];
  }

  AnimationController _controller;
  Animation<double> curve;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    curve = CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);

    _controller.addListener(() {
      setState(() {});
      if (_controller.status == AnimationStatus.completed &&
          widget.onComplete != null) {
        widget.onComplete();
      }
    });
    _controller.forward();
     setState(() {
      settime = widget.appointmenttime;
    });
  print(settime);
  }

  int modifyList;
  int donelist;
  final String apiUrl = "http://192.168.1.9:3040/triage_test";
  //final String apiUrl = "https://agilemedapp-cn4rzuzz6a-el.a.run.app/triage_test";

  Future<List<dynamic>> fetchUsers() async {
    var result = await http.get(apiUrl);
    print(result.body);
    return json.decode(result.body);
  }

  List<String> lst = ['MODIFY', 'DONE'];
  int selectedIndex = 0;
  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
String settime;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Container(
        padding: EdgeInsets.only(top: 15, left: 5, right: 5,bottom: 10),
        // color: headerthemecolor,
        child: new Container(
            decoration: new BoxDecoration(
                color: buttonColor,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(40.0),
                  topRight: const Radius.circular(40.0),
                    bottomLeft: const Radius.circular(40.0),
                  bottomRight: const Radius.circular(40.0),
                )),
            // padding: EdgeInsets.only(
            //   top: 370,left: 150
            // ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      top: 40,
                    ),
                    height: 180,
                    width: 140,
                    color: Colors.transparent,
                    child: CustomPaint(
                      painter: CheckPainter(value: curve.value),
                    ),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                         SizedBox(
                          height: 40,
                        ),
                      Text(
                            'Done!',
                            style: TextStyle(fontSize: 17,color: greyTextColor),
                          ),
                          SizedBox(
                          height: 20,
                        ),
                         Text(
                            // 'Your appointment is with',
                            'Successfully updated appointment with',
                            style: TextStyle(fontSize: 17,color: greyTextColor),
                          ),   SizedBox(
                          height: 20,
                        ),
                          Text(
                           widget.doctorname==null?"":widget.doctorname,
                         
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,color: buttonTextColor),
                          ),  SizedBox(
                          height: 20,
                        ),
                          Text('',
                            // widget.doctoremail,
                      // 'Heart specialist',
                            style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),
                          ),
                        //   SizedBox(
                        //   height: 20,
                        // ),
                  //         Text('',
                  //  // widget.appointmenttime,
                  //     //  widget.appointmentdate==null?"": 
                  //     //   DateFormat(' EEEE, d MMMM y').format(DateTime.parse(widget.appointmentdate)),
                       
                         
                  //           style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),
                  //         ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        
                           Text(
                   // widget.appointmenttime,
                       widget.appointmenttime==null?"": 
                        DateFormat(' EEEE, d MMMM y').format(DateTime.parse(widget.appointmenttime)),
                       
                         
                            style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: buttonTextColor),
                          ),
                          SizedBox(
                          height: 10,
                        ),
                            Text(
                   // widget.appointmenttime,
                       widget.appointmenttime==null?"":DateFormat.jm().format(DateTime.parse(settime)),
                       // DateFormat('kk:mm:a').format(DateTime.parse(widget.appointmenttime)),
                       
                         
                            style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: buttonTextColor),
                          ),
                      ]),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // Container(
                        //     padding: EdgeInsets.only(left: 10, right: 10),
                        //     child: RaisedButton(
                        //       onPressed: () {
                        //         // setState(() {
                        //         //   modifyList = 0;
                        //         //   donelist = 1;
                        //         // });
                        //         // Navigator.pop(context);
                        //       },
                        //       shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(10.0)),
                        //       color: donelist == 0 ?  Colors.grey : logincolr ,
                        //       //  borderSide: BorderSide(color: selectedIndex == index ? Colors.cyan : Colors.grey),
                        //       child: Text(
                        //         'MODIFY',
                        //         style: TextStyle(color: Colors.white),
                        //       ),
                        //     )),
                        Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: RaisedButton(
                              onPressed: () {
                                // setState(() {
                                //   modifyList = 1;
                                //   donelist = 0;
                                // });
                                // Navigator.push(context,
                                //  MaterialPageRoute(builder: (context)=>Upcomingappointment()));
                                  Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => Upcomingappointment()),
              (Route<dynamic> route) => false);
                              
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              color: modifyList == 0 ?  Colors.grey : buttonTextColor ,
                              //  borderSide: BorderSide(color: selectedIndex == index ? Colors.cyan : Colors.grey),
                              child: Text(
                                'DONE',
                                style: TextStyle(color: buttonColor),
                              ),
                            )),
                      ])
                ]),
              ],
            )),
      ),
    );
  }
}

class CheckPainter extends CustomPainter {
  Paint _paint;
  double value;

  double _length;
  double _offset;
  double _secondOffset;
  double _startingAngle;

  CheckPainter({this.value}) {
    _paint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    assert(value != null);

    _length = 75;
    _offset = 20;
    _startingAngle = 205;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Background canvas
    var rect = Offset(0, 0) & size;
    _paint.color = Colors.greenAccent.withOpacity(.30);

    double line1x1 = size.width / 2 +
        size.width * cos(Angle.fromDegrees(_startingAngle).radians) * .5;
    double line1y1 = size.height / 2 +
        size.height * sin(Angle.fromDegrees(_startingAngle).radians) * .5;
    double line1x2 = size.width * .45;
    double line1y2 = size.height * .65;

    double line2x1 =
        size.width / 2 + size.width * cos(Angle.fromDegrees(320).radians) * .35;
    double line2y1 = size.height / 2 +
        size.height * sin(Angle.fromDegrees(320).radians) * .35;

    canvas.drawArc(rect, Angle.fromDegrees(_startingAngle).radians,
        Angle.fromDegrees(360).radians, false, _paint);
    canvas.drawLine(Offset(line1x1, line1y1), Offset(line1x2, line1y2), _paint);
    canvas.drawLine(Offset(line2x1, line2y1), Offset(line1x2, line1y2), _paint);

    // animation painter

    double circleValue, checkValue;
    if (value < .5) {
      checkValue = 0;
      circleValue = value / .5;
    } else {
      checkValue = (value - .5) / .5;
      circleValue = 1;
    }

    _paint.color = const Color(0xff047d16);
    double firstAngle = _startingAngle + 360 * circleValue;

    canvas.drawArc(
        rect,
        Angle.fromDegrees(firstAngle).radians,
        Angle.fromDegrees(
                getSecondAngle(firstAngle, _length, _startingAngle + 360))
            .radians,
        false,
        _paint);

    double line1Value = 0, line2Value = 0;
    if (circleValue >= 1) {
      if (checkValue < .5) {
        line2Value = 0;
        line1Value = checkValue / .5;
      } else {
        line2Value = (checkValue - .5) / .5;
        line1Value = 1;
      }
    }

    double auxLine1x1 = (line1x2 - line1x1) * getMin(line1Value, .8);
    double auxLine1y1 =
        (((auxLine1x1) - line1x1) / (line1x2 - line1x1)) * (line1y2 - line1y1) +
            line1y1;

    if (_offset < 60) {
      auxLine1x1 = line1x1;
      auxLine1y1 = line1y1;
    }

    double auxLine1x2 = auxLine1x1 + _offset / 2;
    double auxLine1y2 =
        (((auxLine1x1 + _offset / 2) - line1x1) / (line1x2 - line1x1)) *
                (line1y2 - line1y1) +
            line1y1;

    if (checkIfPointHasCrossedLine(Offset(line1x2, line1y2),
        Offset(line2x1, line2y1), Offset(auxLine1x2, auxLine1y2))) {
      auxLine1x2 = line1x2;
      auxLine1y2 = line1y2;
    }

    if (_offset > 0) {
      canvas.drawLine(Offset(auxLine1x1, auxLine1y1),
          Offset(auxLine1x2, auxLine1y2), _paint);
    }

    // SECOND LINE

    double auxLine2x1 = (line2x1 - line1x2) * line2Value;
    double auxLine2y1 =
        ((((line2x1 - line1x2) * line2Value) - line1x2) / (line2x1 - line1x2)) *
                (line2y1 - line1y2) +
            line1y2;

    if (checkIfPointHasCrossedLine(Offset(line1x1, line1y1),
        Offset(line1x2, line1y2), Offset(auxLine2x1, auxLine2y1))) {
      auxLine2x1 = line1x2;
      auxLine2y1 = line1y2;
    }
    if (line2Value > 0) {
      canvas.drawLine(
          Offset(auxLine2x1, auxLine2y1),
          Offset(
              (line2x1 - line1x2) * line2Value + _offset * .75,
              ((((line2x1 - line1x2) * line2Value + _offset * .75) - line1x2) /
                          (line2x1 - line1x2)) *
                      (line2y1 - line1y2) +
                  line1y2),
          _paint);
    }
  }

  double getMax(double x, double y) {
    return (x > y) ? x : y;
  }

  double getMin(double x, double y) {
    return (x > y) ? y : x;
  }

  bool checkIfPointHasCrossedLine(Offset a, Offset b, Offset point) {
    return ((b.dx - a.dx) * (point.dy - a.dy) -
            (b.dy - a.dy) * (point.dx - a.dx)) >
        0;
  }

  double getSecondAngle(double angle, double plus, double max) {
    if (angle + plus > max) {
      _offset = angle + plus - max;
      return max - angle;
    } else {
      _offset = 0;
      return plus;
    }
  }

  @override
  bool shouldRepaint(CheckPainter old) {
    return old.value != value;
  }
}
