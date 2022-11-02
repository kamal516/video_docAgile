import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:doctoragileapp/color.dart';

class Dateselect extends StatefulWidget {
  DateTime appointment_datetime;
    List bookedtime;
     String holderid;
     final DateTime starttime;
  final DateTime endtime;
 final String slotdifference;
  Dateselect({this.appointment_datetime,this.bookedtime,this.holderid,this.starttime,this.endtime,this.slotdifference});
  @override
  _WidgetPageState createState() => _WidgetPageState();
}

class _WidgetPageState extends State<Dateselect> {
  DateTime _selectedDate;
  DateTime _dateTime = DateTime.now();
    List<String> timeSlots = [
    '01:00',
    '01:15',
    '01:30',
    '01:45',
    '02:00',
    '02:15',
    '02:30',
    '02:45',
    '03:00',
    '03:15',
    '03:30',
    '03:45',
    '04:00',
    '04:15',
    '04:30',
    '04:45',
    '05:00',
    '05:15',
    '05:30',
    '05:45',
    '06:00',
    '06:15',
    '06:30',
    '06:45',
    '07:00',
    '07:15',
    '07:30',
    '07:45',
    '08:00',
    '08:15',
    '08:30',
    '08:45',
    '09:00',
    '09:15',
    '09:30',
    '09:45',
    '10:00',
    '10:15',
    '10:30',
    '10:45',
    '11:00',
    '11:15',
    '11:30',
    '11:45',
    '12:00',
    '12:15',
    '12:30',
    '12:45',
    '13:00',
    '13:15',
    '13:30',
    '13:45',
    '14:00',
    '14:15',
    '14:30',
    '14:45',
    '15:00',
    '15:15',
    '15:30',
    '15:45',
    '16:00',
    '16:15',
    '16:30',
    '16:45',
    '17:00',
    '17:15',
    '17:30',
    '17:45',
    '18:00',
    '18:15',
    '18:30',
    '18:45',
    '19:00',
    '19:15',
    '19:30',
    '19:45',
    '20:00',
    '20:15',
    '20:30',
    '20:45',
    '21:00',
    '21:15',
    '21:30',
    '21:45',
    '22:00',
    '22:15',
    '22:30',
    '22:45',
    '23:00',
    '23:15',
    '23:30',
    '23:45'
  ];
int selectedCard = -1;
  var slottimeshow;
  var st;
  DateTime dt1;
  var et;
  var splitduration;
  List booktime = [];
  var setdatetime;
  @override
  void initState() {
    super.initState();
  
    st = DateFormat('hh:mm a').format(widget.starttime.toLocal());
    et = DateFormat('hh:mm a').format(widget.endtime.toLocal());

    if (widget.slotdifference == null) {
      splitduration = 15;
    } else {
      var splittime = widget.slotdifference.split(':');
      splitduration = int.parse(splittime[1]);
    }
    print(splitduration);
    slottime();
   
  }
    List<dynamic> allslotslist = [];
  List<dynamic> slottimeList = [];
 slottime() {
    var dynamiclist = [];
    var obj = {'time': st, "selected": false};
    var addminutes;
    dynamiclist.add(obj);
    addminutes = widget.starttime.add(new Duration(minutes: splitduration));

    for (int i = 0; i < dynamiclist.length; i++) {
      var obj1 = {
        'time': DateFormat('hh:mm a').format(addminutes.toLocal()),
        "selected": false
      };
      dynamiclist.add(obj1);
      addminutes = addminutes.add(new Duration(minutes: splitduration));
      if (DateFormat('hh:mm a').format(addminutes.toLocal()) == et) {
        var obj2 = {'time': et, "selected": false};
        dynamiclist.add(obj2);
        break;
      }
    }

    for (int i = 0; i < dynamiclist.length; i++) {
      if (dynamiclist[i]['time'] == st) {
        for (int k = 0; k < widget.bookedtime.length; k++) {
          if (dynamiclist[i]['time'] ==
              DateFormat('hh:mm a').format(
                  DateTime.parse(widget.bookedtime[k]['appointment_date'])
                      .toLocal())) {
            dynamiclist[i]['selected'] = true;
          }
        }
        slottimeList.add(dynamiclist[i]);
        for (int j = i + 1; j < dynamiclist.length; j++) {
          for (int k = 0; k < widget.bookedtime.length; k++) {
            if (dynamiclist[j]['time'] ==
                DateFormat('hh:mm a').format(
                    DateTime.parse(widget.bookedtime[k]['appointment_date'])
                        .toLocal())) {
              dynamiclist[j]['selected'] = true;
            }
          }
          slottimeList.add(dynamiclist[j]);
          if (dynamiclist[j]['time'] == et) {
            break;
          }
        }
      }
    }
    print(slottimeList);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 15),
        // color: primarydarkcolor,
        child: new Container(
            decoration: new BoxDecoration(
                color: buttonTextColor,
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
                        decoration: new BoxDecoration(
                            color: buttonColor,
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(40.0),
                              topRight: const Radius.circular(40.0),
                            )),
                        child: Row(  
                            mainAxisAlignment: MainAxisAlignment.start,children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: buttonTextColor,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          // SizedBox(
                          //   width: 60,
                          // ),
                          Text(
                            'Select date and time',
                            style: TextStyle(color: buttonTextColor, fontSize: 19),
                          ),
                        ]),
                      ),
                    ]),
                SizedBox(height: 0),
                Column(
                  children: <Widget>[
                    Container(
                        height: 30,
                        width: 450,
                        color: greyContainer,
                        alignment: Alignment.center,
                        child: Text(
                          'Date',
                          style: TextStyle(fontSize: 22),
                        )),
                    Container(
                      padding: EdgeInsets.only(top: 30, left: 35, right: 35),
                      child: DatePickerWidget(
                        looping: false,
                        firstDate:
                           
                            DateTime.now(),
                        lastDate: DateTime(2040, 1, 1),
                        initialDate: widget.appointment_datetime.toLocal(),
                        dateFormat: "dd-MMMM-yyyy",
                        locale: DateTimePickerLocale.en_us,
                        onChange: (DateTime newDate, _) {
                          widget.appointment_datetime = new DateTime(
                              newDate.year,
                              newDate.month,
                              newDate.day,
                              widget.appointment_datetime.hour,
                              widget.appointment_datetime.minute,
                              widget.appointment_datetime.second,
                              widget.appointment_datetime.millisecond,
                              widget.appointment_datetime.microsecond);
                        },
                        pickerTheme: DateTimePickerTheme(
                          itemTextStyle:
                              TextStyle(color: Colors.black, fontSize: 20),
                          dividerColor: buttonColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Container(
                          height: 30,
                          width: 450,
                          color: greyContainer,
                          alignment: Alignment.center,
                          child: Text(
                            'Time',
                            style: TextStyle(fontSize: 22),
                          )),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                      Container(
                        decoration: BoxDecoration(
                            //                border:  Border(
                            //     bottom: BorderSide(color: Colors.grey, width: 1, style: BorderStyle.solid),

                            // ),
                            ),
                        height: 230,
                        child: Padding(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: GridView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 7,
                                        crossAxisSpacing: 5.0,
                                        mainAxisSpacing: 1),
                                itemCount: slottimeList.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  // bookedtimelist.add(slottimeList.where((f) => f[index] == booktime))     ;
                                  //     print(bookedtimelist);
                                  return GestureDetector(
                                      onTap: slottimeList[index]['selected'] ==
                                              false
                                          ? () {
                                              setState(() {
                                                slottimeshow =
                                                    slottimeList[index]['time'];
                                                       dt1 =DateFormat('hh:mm a').parse(slottimeshow);
                                                selectedCard = index;
                                              });
                                              print(booktime);
                                                 print(DateFormat('HH:mm').format(dt1));
                                            }
                                          : null,
                                      child: Container(
                                        padding: EdgeInsets.all(0.0),
                                        margin: EdgeInsets.only(
                                            left: 1.0,
                                            right: 1.0,
                                            top: 1.0,
                                            bottom: 10.0),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey,
                                                // bookedCard==index?Colors.grey:Colors.red,
                                                width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    8.0) //                 <--- border radius here
                                                ),
                                            color: slottimeList[index]
                                                        ['selected'] ==
                                                    false
                                                ? selectedCard == index
                                                    ? (buttonColor)
                                                    : (Colors.white)
                                                : (Colors.grey)),
                                        child: Center(
                                          child: Text(
                                            slottimeList[index]['time'],
                                            style: TextStyle(
                                              color: slottimeList[index]
                                                          ['selected'] ==
                                                      false
                                                  ? selectedCard == index
                                                      ? Colors.white
                                                      : Colors.black
                                                  : Colors.white,
                                              fontSize: 14.0,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ));
                                }))),
                    SizedBox(
                      height: 10,
                    ),
                    slottimeshow != null
                        ? Text(
                            'Selected Time: ${DateFormat('hh:mm a').format(dt1)}',
                            style: TextStyle(fontSize: 15),
                          )
                        : Text(''),
                        //  slottimeshow.toString()
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                        color: buttonColor,
                        onPressed: () {
                          Navigator.pop(
                            context,
                            DateTime.parse(DateFormat('yMd ')
                                    .format(widget.appointment_datetime) +
                                // slottimeshow
                                DateFormat('HH:mm').format(dt1)
                                ),
                          );
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(color: buttonTextColor),
                        ))
//                      Container(
//                       decoration:   BoxDecoration(
//       //                border:  Border(
//       //     bottom: BorderSide(color: Colors.grey, width: 1, style: BorderStyle.solid),
         
//       // ),
//                       ),
//                         height: 230,
//                         child: Padding(padding: EdgeInsets.only(left:15,right:15),
//                         child: GridView.builder(
//                             scrollDirection: Axis.vertical,
//                             shrinkWrap: true,
//                             gridDelegate:
//                                 SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount: 7,
//                                     crossAxisSpacing: 5.0,
//                                     mainAxisSpacing: 1),
//                             itemCount: slottimeList.length,
//                             itemBuilder: (BuildContext ctx, index) {
//                         return GestureDetector(
//                                  onTap: (){
//                                setState(() {
//                                     slottimeshow =slottimeList[index];
//                                     selectedCard = index;
//                                 //  selectedCard =int.parse(DateFormat('hh:mm').format(widget.bookedtime)) ;
//                                   // widget.appointment_datetime =slottimeshow;
//                            });
//                             print(selectedCard);
//                                   print(slottimeshow);
//                                 },
//                                 child:Container(
//                               padding: EdgeInsets.all(0.0),
//                                 margin: EdgeInsets.only(
//                                     left: 1.0,
//                                     right: 1.0,
//                                     top: 1.0,
//                                     bottom: 10.0),
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                       color:Colors.grey,
//                                       // bookedCard==index?Colors.grey:Colors.red,
//                                        width: 1.0),
//                                   borderRadius: BorderRadius.all(
//                                       Radius.circular(
//                                           8.0) //                 <--- border radius here
//                                       ),
//                             color: selectedCard == index ? Colors.grey: Colors.white
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                      slottimeList[index]['time'],
//                                     style: TextStyle(
//                                       color:selectedCard == index ? Colors.white: Colors.black,
//                                       fontSize: 14.0,
//                                     ),
//                                   ),
//                                 ),
//                                ) );
//                             }))),   SizedBox(height: 10,),
//                             slottimeshow!=null?Text('Selected Time: ${slottimeList[index]['time']}',style: TextStyle(fontSize: 15),):Text('')
//               ,SizedBox(height: 10,),
//               RaisedButton(color: buttonColor,onPressed: (){
// Navigator.pop(
//   context,
//  DateTime.parse(DateFormat('yMd ').format(widget.appointment_datetime )+slottimeshow ),
// );
//              },child:Text('Done', style: TextStyle(color: buttonTextColor),))
                    // Padding(
                    //     padding: EdgeInsets.only(top: 10),
                    //     child: Container(
                    //       color: buttonTextColor,
                    //       padding: EdgeInsets.only(top: 10),
                    //       child: new Column(
                    //         children: <Widget>[
                    //           hourMinute15Interval(),
                    //          SizedBox(height:58),
                    //           Container(
                    //               width: 360,
                    //               padding: EdgeInsets.only(right: 10, left: 10),
                    //               child: RaisedButton(
                    //                 onPressed: () {
                    //                   if (_selectedDate == null) {
                    //                     setState(() {
                    //                       _timer =
                    //                           DateFormat('yyyy-MM-dd  HH:MM')
                    //                               .format(_dateTime);
                    //                     });
                    //                   } else {
                    //                     setState(() {
                    //                       _timer = _selectedDate.year
                    //                               .toString() +
                    //                           '-' +
                    //                           _selectedDate.month.toString() +
                    //                           '-' +
                    //                           _selectedDate.day.toString() +
                    //                           ' ' +
                    //                           _dateTime.hour
                    //                               .toString()
                    //                               .padLeft(2, '0') +
                    //                           ':' +
                    //                           _dateTime.minute
                    //                               .toString()
                    //                               .padLeft(2, '0');
                    //                     });
                    //                   }

                    //                   Navigator.pop(
                    //                     context,
                    //                     widget.appointment_datetime,
                    //                   );
                    //                 },
                    //                 shape: RoundedRectangleBorder(
                    //                     borderRadius:
                    //                         BorderRadius.circular(10.0)),
                    //                 color: buttonColor,
                    //                 child: Text(
                    //                   'DONE',
                    //                   style: TextStyle(color: buttonTextColor),
                    //                 ),
                    //               ))
                    //         ],
                    //       ),
                    //     ))
                  ],
                )
              ],
            )),
      ),
    ));
  }

  String _timer;
  Widget hourMinute15Interval() {
    return new TimePickerSpinner(
      spacing: 30,
      itemHeight: 40,
      minutesInterval: 15,
      is24HourMode: false,
      time: widget.appointment_datetime.toLocal(),
      onTimeChange: (time) {
        setState(() {
          widget.appointment_datetime = new DateTime(
              widget.appointment_datetime.year,
              widget.appointment_datetime.month,
              widget.appointment_datetime.day,
              time.hour,
              time.minute,
              time.second,
              time.millisecond,
              time.microsecond);
         
        });
      },
    );
  }
}
