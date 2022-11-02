import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctoragileapp/color.dart';
import 'package:doctoragileapp/widget/bottomnavbar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:doctoragileapp/api.dart';

import 'package:doctoragileapp/triage/detailpage.dart';
import 'package:doctoragileapp/triage/doctrinfo.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Doctorlist extends StatefulWidget {
  final DateTime time;
  final DateTime appointment_date;
    final String starttime;
  final String endtime;
    final String slotdifference;
  Doctorlist({this.time, this.appointment_date,this.endtime,this.slotdifference,this.starttime});
  @override
  _DoctorListState createState() => _DoctorListState();
}

class _DoctorListState extends State<Doctorlist> {
  bool _hasBeenPressed = false;

  List<IconData> icnlst = [Icons.mail, Icons.access_alarm];
  List<IconData> icnDoctorlst = [Icons.assignment_turned_in, Icons.message];
  int selectedIndex;
  int selectedMale = 0;
  int selectedFemale;
  int selectedIndexList;
  int selectedIndexList1;
  List data;
  String _listbyid;
  void initState() {
    super.initState();
    _gettoken();

    // fetchdoctr();
  }

  String _token;
  String _logineduserid;
   String _roleId;
  String _institute_id;
  _gettoken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _token = preferences.getString("token");
      _logineduserid = preferences.getString("id");
       _roleId = preferences.getString("roleid");
       _institute_id = preferences.getString("institute_id");
      // _listbyid = preferences.getString("appointment_id");
    });
    fetchdoctr();
  }

  String _user(dynamic user) {
    return _singledoctor['username'];
  }

  String _holderid(dynamic user) {
    return _singledoctor['user_id'];
  }

  List doctorbyiddata;
  int _id;
  String _email(dynamic user) {
    return _singledoctor['email'];
  }

  TextEditingController _problem = new TextEditingController();

  Future<List> searchdoctor() async {
    if (_problem.text == '') {
      return fetchdoctr();
    } else {
      final response = await http.post(apipath + '/doctorListBySearch', body: {
        "username": _problem.text,
        "searchword": _problem.text,
      }).then((result) async {
        result.body;
        if (result.body == '"No Data"') {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              //  Map<String, dynamic> user = jsonDecode(result.body);
              return AlertDialog(
                title: Text("No such specialist available"),
// content: const Text('This item is no longer available'),
                actions: [
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.pop(context);
                      fetchdoctr();
                    },
                  ),
                ],
              );
            },
          );
        }
        // else if(result.body=='"insert Keyword for search"'){
        //   return fetchdoctr();
        // }
        setState(() {
          alldocotor = jsonDecode(result.body);
        });
      });
    }
  }
List timeslot;
  _fetcheddoctor(int index) async {
    if(_roleId=="102"){
    final ddata = await http.post(apipath + '/doctorListById', body: {
      "user_id": _singledoctor['user_id'].toString(),
    }).then((value)async {
      // return value.body;
      setState(() {
        doctorbyiddata = jsonDecode(value.body);
      });
     await http.post(apipath + '/doctorListByIdAppointment', body: {
      
'appointment_date':widget.appointment_date.toString(),

'timezone':_currenttime.timeZoneName,
      "user_id": index.toString(),
    }).then((val) {
timeslot= jsonDecode(val.body);
    });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Doctorinfo(
                    detaildoctor: doctorbyiddata,
                    appoint_time: widget.appointment_date,
                    starttime:timeslot[0]['available_start_time'],
                   endtime:timeslot[0]['available_end_time'],
                  slotdifference:timeslot[0]['slot_size']
           )));
    });
    }
    else{
       final ddata = await http.post(apipath + '/doctorListById', body: {
      "user_id": index.toString(),
    }).then((value) {
      // return value.body;
      setState(() {
        doctorbyiddata = jsonDecode(value.body);
      });
        http.post(apipath + '/doctorListByIdAppointment', body: {
      
'appointment_date':widget.appointment_date.toString(),

'timezone':_currenttime.timeZoneName,
      "user_id": index.toString(),
    }).then((val) {
timeslot= jsonDecode(val.body);
    });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Doctorinfo(
                    detaildoctor: doctorbyiddata,
                    appoint_time: widget.appointment_date,
                     starttime:timeslot[0]['available_start_time'],
                   endtime:timeslot[0]['available_end_time'],
                  slotdifference:timeslot[0]['slot_size']
           )));
    });
    }
   
  }
  _doctorlist(int index) async {
    final ddata = await http.post(apipath + '/doctorListByIdAppointment', body: {
      
'appointment_date':widget.appointment_date.toString(),

'timezone':_currenttime.timeZoneName,
      "user_id": index.toString(),
    }).then((value) {
      // return value.body;
      setState(() {
        doctorbyiddata = jsonDecode(value.body);
      });
       if(_roleId=="102"){
return  Navigator.push( context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Detailpage(
                                                                starttime:doctorbyiddata[0]['available_start_time'],
                                                                endtime: doctorbyiddata[0]['available_end_time'],
                                                                  doctoremail:
                                                                      _singledoctor[
                                                                          'doctoremail'],
                                                                  clientid: _singledoctor[
                                                                          'user_id']
                                                                      .toString(),
                                                                  phonenumber:
                                                                      _singledoctor[
                                                                          'phone_number1'],
                                                                  doctor: _user(
                                                                    _singledoctor[
                                                                        'user_id'],
                                                                  ),
                                                                  // email: _singledocotor['email'],

                                                                  // name: _singledocotor
                                                                  //         ['username'],
                                                                  appointment_datetime:
                                                                      widget
                                                                          .appointment_date,
                                                                  holderid: _singledoctor[
                                                                          'user_id']
                                                                      .toString(),
                                                                  user_image:
                                                                      _singledoctor[
                                                                          'user_profile'],
                                                                         slotdifference:doctorbyiddata[0]['slot_size']
                                                                  // holderid: _holderid(
                                                                  //   snapshot.alldocotor[index],
                                                                  // ),
                                                                  )));
       }
    return  Navigator.push( context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Detailpage(
                                                                starttime:doctorbyiddata[0]['available_start_time'],
                                                                endtime: doctorbyiddata[0]['available_end_time'],
                                                                  doctoremail:
                                                                      doctorbyiddata[0][
                                                                          'email'],
                                                                  // clientid: _singledoctor[
                                                                  //         'user_id']
                                                                  //     .toString(),
                                                                  // phonenumber:
                                                                  //     _singledoctor[
                                                                  //         'phone_number1'],
                                                                  doctor: 
                                         doctorbyiddata[0]['username'],
                                                                  appointment_datetime:
                                                                      widget
                                                                          .appointment_date,
                                                                  holderid: doctorbyiddata[0]['user_id']
                                                                      .toString(),
                                                                  user_image:
                                                                      doctorbyiddata[0][
                                                                          'user_profile'],
                                                                         slotdifference:doctorbyiddata[0]['slot_size']
                                                                  // holderid: _holderid(
                                                                  //   snapshot.alldocotor[index],
                                                                  // ),
                                                                  )));
    });
  }


  _doctordata(int index) async {
    final ddata = await http.post(apipath + '/doctorListById', body: {
      "user_id": data[index]["user_id"].toString(),
    }).then((value) {
      // return value.body;
      setState(() {
        doctorbyiddata = jsonDecode(value.body);
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Doctorinfo(
                    detaildoctor: doctorbyiddata,
                    appoint_time: widget.appointment_date,
                  )));
    });
  }

  List alldocotor;
DateTime _currenttime = DateTime.now();
  var _singledoctor = {};
  final String apiUrl = apipath + '/doctorList';
bool nodata = false;
   fetchdoctr() async {
    if(_roleId =='102'){
//  var result = await http.get(apiUrl);
var result = await http.post(apiUrl,body: {
  'timezone':_currenttime.timeZoneName,
  'selectedDate':widget.appointment_date.toLocal().toString(),
   'institute_id':_institute_id.toString()
}).then((value) {
  setState(() {
      alldocotor = json.decode(value.body);
  });

    });
   
    for (int i = 0; i < alldocotor.length; i++) {
      if (_logineduserid == alldocotor[i]['user_id'].toString()) {
        print("hello");

        _singledoctor = alldocotor[i];
      }
      else{
        setState(() {
           nodata = true;
        });
      }
    }
// return json.decode(result.body);
    print(_singledoctor[0].username);
    }
     if(_roleId =='103'){
        final ddata = await http.post(apipath + '/getDoctorListForAssistant', body: {
      "user_id": _logineduserid,
      'timezone':_currenttime.timeZoneName,
  'selectedDate':widget.appointment_date.toLocal().toString()
    }).then((value) {
      // return value.body;
      setState(() {
        alldocotor = jsonDecode(value.body);
      });
   
    });
    }
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavBar(),
        body: SingleChildScrollView(
          child: Container(
            //    padding: EdgeInsets.only(top: 15, left: 5, right: 5),
            // color: Color(0xFF1b2b33),
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
                                  // IconButton(
                                  //     icon: Icon(
                                  //       Icons.arrow_back,
                                  //       color: Colors.white,
                                  //     ),
                                  //     onPressed: () {
                                  //       Navigator.pop(context);
                                  //     }),
                                  // SizedBox(
                                  //   width: 100,
                                  // ),

                                  Text(
                                    'SERVICES',
                                    style: TextStyle(
                                        color: buttonTextColor, fontSize: 19),
                                  ),

                                  // IconButton(
                                  //     icon: Icon(
                                  //       Icons.power_settings_new,
                                  //       color: Colors.white,
                                  //     ),
                                  //     onPressed: null),
                                ]),
                          ),
                        ]),
                    Container(
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(2)),
                      padding: EdgeInsets.only(top: 10, left: 0, right: 30),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 10, left: 2, right: 5),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Filter Doctor/ Specialist by Profile",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            Container(
                              height: 40,
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(width: 10),
                                  Flexible(
                                    child: TextFormField(
                                      controller: _problem,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'Search',
                                          suffixIcon: IconButton(
                                            icon: Icon(Icons.search),
                                            onPressed: () {
                                              // searchdoctor();
                                            },
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ),
                      _getList(),
          
                  ],
                )),
          ),
        ));
  }
  checklist(){
    if(nodata==false){
     return Center(child: CircularProgressIndicator()) ;
    }else{
    return  Center(child:Text('Doctor is not available'));
    }
  }
  _getList(){
    if(_roleId=="102"){
      return 
                Container(
                        // height: (MediaQuery.of(context).size.height - 240),
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child:
                            //  ListView.builder(
                            //     itemCount:
                            //         alldocotor == null ? 0 : alldocotor.length,
                            //     shrinkWrap: true,
                            //     physics: ClampingScrollPhysics(),
                            //     itemBuilder: (BuildContext context, int index) {
                            //       List<dynamic> user = alldocotor;

                            //       return
                            
                            _singledoctor.length == 0
                                ? checklist()
                                : 
                                //  _singledoctor.length == 0?Container(child:Text('no go so to')):
                                Card(
                                    color: greyContainer,
                                    child: Row(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            _fetcheddoctor(
                                                _singledoctor['user_id']);
                                          },
                                          child: Container(
                                            width: 65,
                                            height: 65,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.grey,
                                              //radius: 5,
                                              child: ClipOval(
                                                  child: _singledoctor[
                                                              'user_profile'] ==
                                                          null
                                                      ? Image.asset(
                                                          "assets/profile.png")
                                                      : CachedNetworkImage(
                                                          // imageUrl: user[index]['user_profile'],Image.asset("assets/profile.png")
                                                          imageUrl: _singledoctor[
                                                                  'user_profile']
                                                              .toString(),
                                                          fit: BoxFit.fill,
                                                          width: 65.0,
                                                        )),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              ListTile(
                                                //  title: Text(result.body),
                                                // title: Text(user[index]['username']),
                                                title: Text(
                                                    _singledoctor['username']
                                                        .toString()),
                                                // subtitle: Text(
                                                //     user[index]['email'] == null
                                                //         ? ""
                                                //         : user[index]['email']),
                                                subtitle: Text(_singledoctor[
                                                            'email'] ==
                                                        null
                                                    ? ""
                                                    : _singledoctor['email']),
                                                onTap: () {
                                                   _doctorlist(_singledoctor['user_id']);
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             Detailpage(
                                                                
                                                  //                 doctoremail:
                                                  //                     _singledoctor[
                                                  //                         'doctoremail'],
                                                  //                 clientid: _singledoctor[
                                                  //                         'user_id']
                                                  //                     .toString(),
                                                  //                 phonenumber:
                                                  //                     _singledoctor[
                                                  //                         'phone_number1'],
                                                  //                 doctor: _user(
                                                  //                   _singledoctor[
                                                  //                       'user_id'],
                                                  //                 ),
                                                  //                 // email: _singledocotor['email'],

                                                  //                 // name: _singledocotor
                                                  //                 //         ['username'],
                                                  //                 appointment_datetime:
                                                  //                     widget
                                                  //                         .appointment_date,
                                                  //                 holderid: _singledoctor[
                                                  //                         'user_id']
                                                  //                     .toString(),
                                                  //                 user_image:
                                                  //                     _singledoctor[
                                                  //                         'user_profile']
                                                  //                 // holderid: _holderid(
                                                  //                 //   snapshot.alldocotor[index],
                                                  //                 // ),
                                                  //                 )));
                                                  //   Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             Detailpage(
                                                  //                 doctor: _user(
                                                  //                   user[index],
                                                  //                 ),
                                                  //                 email: _email(
                                                  //                   user[index],
                                                  //                 ),
                                                  //                 appointment_datetime:
                                                  //                     widget
                                                  //                         .appointment_date,
                                                  //                 holderid: user[
                                                  //                             index]
                                                  //                         ['user_id']
                                                  //                     .toString(),
                                                  //                 user_image: user[
                                                  //                         index]
                                                  //                     ['user_profile']
                                                  //                 // holderid: _holderid(
                                                  //                 //   snapshot.alldocotor[index],
                                                  //                 // ),
                                                  //    )
                                                  //   )
                                                  // );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(left: 20)),
                                        // GestureDetector(
                                        //   onTap: () {
                                        //     Navigator.push(
                                        //         context,
                                        //         MaterialPageRoute(
                                        //             builder: (context) => Detailpage(
                                        //                 doctor: user[index]
                                        //                     ['username'],
                                        //                 email: user[index]['email'],
                                        //                 appointment_datetime:
                                        //                     widget.appointment_date,
                                        //                 //  widget
                                        //                 //     .timer
                                        //                 //     .toString(),
                                        //                 holderid: user[index]
                                        //                         ['user_id']
                                        //                     .toString(),
                                        //                 user_image: user[index]
                                        //                     ['user_profile'])));
                                        //     // setState(() {
                                        //     //   selectedIndexList = 0;
                                        //     //   selectedIndexList1 = 1;
                                        //     // });
                                        //     // Navigator.push(
                                        //     //     context,
                                        //     //     MaterialPageRoute(
                                        //     //         builder: (context) =>
                                        //     //             Detailpage()));
                                        //   },
                                        //   child: Container(
                                        //     height: 33,
                                        //     width: 33,
                                        //     decoration: BoxDecoration(
                                        //         borderRadius:
                                        //             BorderRadius.circular(18),
                                        //         color: selectedIndexList == 0
                                        //             ? Colors.grey
                                        //             : themecolor),
                                        //     child: Icon(Icons.done_outline,
                                        //         color: selectedIndexList == 0
                                        //             ? Colors.white
                                        //             : Colors.black),
                                        //   ),
                                        // ),
                                        // SizedBox(
                                        //   width: 5,
                                        // ),
                                        // GestureDetector(
                                        //   onTap: () {
                                        //     // setState(() {
                                        //     //   selectedIndexList1 = 0;
                                        //     //   selectedIndexList = 1;
                                        //     // });
                                        //     // Navigator.push(
                                        //     //     context,
                                        //     //     MaterialPageRoute(
                                        //     //         builder: (context) =>
                                        //     //             Detailpage()));
                                        //   },
                                        //   child: Container(
                                        //     height: 36,
                                        //     width: 36,
                                        //     decoration: BoxDecoration(
                                        //         borderRadius:
                                        //             BorderRadius.circular(18),
                                        //         color: selectedIndexList1 == 0
                                        //             ? Colors.grey
                                        //             : menucahtcolr),

                                        //     child: Padding(
                                        //       padding:
                                        //           EdgeInsets.only(top: 4, left: 8),
                                        //       child: SvgPicture.asset(
                                        //         'assets/chat1.svg',
                                        //       ),
                                        //     ),

                                        //     // Icon(Icons.chat,
                                        //     //     color: selectedIndexList1 == 0
                                        //     //         ? Colors.white
                                        //     //         : Colors.black),
                                        //   ),
                                        // ),
                                      ],
                                    ))

                        // }
                        // else if(data!=null) {
                        //   return
                        //              Container(
                        //  height: (MediaQuery.of(context).size.height - 280),
                        //     padding: EdgeInsets.only(left: 10, right: 10),
                        //     child:
                        //      ListView.builder(
                        //         itemCount:data == null ? 0 :data.length,
                        //         shrinkWrap: true,
                        //         physics: ClampingScrollPhysics(),
                        //         itemBuilder: (BuildContext contextt, int iindex) {
                        //           List<dynamic> searchdoctor = data;
                        //           return Card(
                        //               child: Row(
                        //             children: <Widget>[
                        //               GestureDetector(
                        //                 onTap: () {
                        //                _doctordata(index);
                        //               },
                        //                 child: Container(
                        //                     width: 55,
                        //                     height: 45,
                        //                     decoration: ShapeDecoration(
                        //                         shape: CircleBorder(
                        //                           side: BorderSide(
                        //                               width: 1,
                        //                               color: Theme.of(context)
                        //                                   .primaryColor),
                        //                         ),
                        //                         image: DecorationImage(
                        //                             fit: BoxFit.fitHeight,
                        //                             image: AssetImage(
                        //                               "assets/profile.png",
                        //                             ),
                        //                             alignment: Alignment.center))),
                        //               ),
                        //               Expanded(
                        //                 child: Column(
                        //                   children: <Widget>[
                        //                     ListTile(
                        //                       //  title: Text(result.body),
                        //                       title: Text(searchdoctor[iindex]['username']),
                        //                       subtitle: Text(searchdoctor[iindex]['email']==null?"":searchdoctor[iindex]['email']),
                        //                       onTap: () {
                        //                         Navigator.push(
                        //                             context,
                        //                             MaterialPageRoute(
                        //                                 builder: (context) =>
                        //                                     Detailpage(
                        //                                          doctor: _user(
                        //                                           searchdoctor[iindex],
                        //                                         ),
                        //                                         email:   _email(
                        //                                           searchdoctor[iindex],
                        //                                         ),
                        //                                         appointment_datetime: widget
                        //                                             .appointment_date
                        //                                             ,
                        //                                         holderid: searchdoctor[
                        //                                                     iindex]
                        //                                                 ['user_id']
                        //                                             .toString()
                        //                                         // holderid: _holderid(
                        //                                         //   snapshot.data[index],
                        //                                         // ),
                        //                                         )));
                        //                       },
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //               Padding(padding: EdgeInsets.only(left: 20)),
                        //               GestureDetector(
                        //                 onTap: () {
                        //                     Navigator.push(
                        //                             context,
                        //                             MaterialPageRoute(
                        //                                 builder: (context) =>
                        //                                     Detailpage(
                        //                                          doctor:
                        //                                        searchdoctor[iindex]['username'],

                        //                                         email: searchdoctor[iindex]['email'],

                        //                                         appointment_datetime:widget.appointment_date,
                        //                                         //  widget
                        //                                         //     .timer
                        //                                         //     .toString(),
                        //                                         holderid: searchdoctor[iindex]['user_id'].toString()

                        //                                         )));
                        //                   // setState(() {
                        //                   //   selectedIndexList = 0;
                        //                   //   selectedIndexList1 = 1;
                        //                   // });
                        //                   // Navigator.push(
                        //                   //     context,
                        //                   //     MaterialPageRoute(
                        //                   //         builder: (context) =>
                        //                   //             Detailpage()));
                        //                 },
                        //                 child: Container(
                        //                   height: 33,
                        //                   width: 33,
                        //                   decoration: BoxDecoration(
                        //                       borderRadius:
                        //                           BorderRadius.circular(18),
                        //                       color: selectedIndexList == 0
                        //                           ? Colors.grey
                        //                           : themecolor),
                        //                   child: Icon(Icons.done_outline,
                        //                       color: selectedIndexList == 0
                        //                           ? Colors.white
                        //                           : Colors.black),
                        //                 ),
                        //               ),
                        //               SizedBox(
                        //                 width: 5,
                        //               ),
                        //               GestureDetector(
                        //                 onTap: () {
                        //                   // setState(() {
                        //                   //   selectedIndexList1 = 0;
                        //                   //   selectedIndexList = 1;
                        //                   // });
                        //                   // Navigator.push(
                        //                   //     context,
                        //                   //     MaterialPageRoute(
                        //                   //         builder: (context) =>
                        //                   //             Detailpage()));
                        //                 },
                        //                 child: Container(
                        //                   height: 36,
                        //                   width: 36,
                        //                   decoration: BoxDecoration(
                        //                       borderRadius:
                        //                           BorderRadius.circular(18),
                        //                       color: selectedIndexList1 == 0
                        //                           ? Colors.grey
                        //                           : menucahtcolr),

                        //                   child: Padding(
                        //                     padding:
                        //                         EdgeInsets.only(top: 4, left: 8),
                        //                     child: SvgPicture.asset(
                        //                       'assets/chat1.svg',
                        //                     ),
                        //                   ),

                        //                   // Icon(Icons.chat,
                        //                   //     color: selectedIndexList1 == 0
                        //                   //         ? Colors.white
                        //                   //         : Colors.black),
                        //                 ),
                        //               ),
                        //             ],
                        //           ));
                        //         }
                        //  //      )
                        //          );
                        //           }
                        // })
                        );
    }
    else{
      return Container(
                        // height: (MediaQuery.of(context).size.height - 240),
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child:
                             ListView.builder(
                                itemCount:
                                    alldocotor == null ? 0 : alldocotor.length,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  List<dynamic> user = alldocotor;

                                  return
                            user.length == 0
                                ? Center(child: CircularProgressIndicator())
                                : Card(
                                    color: greyContainer,
                                    child: Row(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            _fetcheddoctor(
                                                user[index]['user_id']);
                                          },
                                          child: Container(
                                            width: 65,
                                            height: 65,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.grey,
                                              //radius: 5,
                                              child: ClipOval(
                                                  child: user[index][
                                                              'user_profile'] ==
                                                          null
                                                      ? Image.asset(
                                                          "assets/profile.png")
                                                      : CachedNetworkImage(
                                                          // imageUrl: user[index]['user_profile'],Image.asset("assets/profile.png")
                                                          imageUrl: user[index][
                                                                  'user_profile']
                                                              .toString(),
                                                          fit: BoxFit.fill,
                                                          width: 65.0,
                                                        )),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              ListTile(
                                                //  title: Text(result.body),
                                                // title: Text(user[index]['username']),
                                                title: Text(
                                                    user[index]['username']
                                                        .toString()),
                                                // subtitle: Text(
                                                //     user[index]['email'] == null
                                                //         ? ""
                                                //         : user[index]['email']),
                                                subtitle: Text(user[index][
                                                            'email'] ==
                                                        null
                                                    ? ""
                                                    : user[index]['email']),
                                                onTap: () {
                                                   _doctorlist(user[index]['user_id']);
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             Detailpage(
                                                  //              starttime:user[index]['available_start_time'],
                                                  //               endtime: user[index]['available_end_time'],
                                                  //                 doctoremail:
                                                  //                     user[index][
                                                  //                         'doctoremail'],
                                                  //                 clientid: user[index][
                                                  //                         'user_id']
                                                  //                     .toString(),
                                                  //                 phonenumber:
                                                  //                     user[index][
                                                  //                         'phone_number1'],
                                                  //                 doctor: _user(
                                                  //                   user[index][
                                                  //                       'user_id'],
                                                  //                 ),
                                                  //                 // email: _singledocotor['email'],

                                                  //                 name:  user[index]
                                                  //                         ['username'],
                                                  //                 appointment_datetime:
                                                  //                     widget
                                                  //                         .appointment_date,
                                                  //                 holderid: user[index][
                                                  //                         'user_id']
                                                  //                     .toString(),
                                                  //                 user_image:
                                                  //                     user[index][
                                                  //                         'user_profile'],slotdifference: user[index]['slot_size'],
                                                  //                 // holderid: _holderid(
                                                  //                 //   snapshot.alldocotor[index],
                                                  //                 // ),
                                                  //                 )));
                                                  //   Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             Detailpage(
                                                  //                 doctor: _user(
                                                  //                   user[index],
                                                  //                 ),
                                                  //                 email: _email(
                                                  //                   user[index],
                                                  //                 ),
                                                  //                 appointment_datetime:
                                                  //                     widget
                                                  //                         .appointment_date,
                                                  //                 holderid: user[
                                                  //                             index]
                                                  //                         ['user_id']
                                                  //                     .toString(),
                                                  //                 user_image: user[
                                                  //                         index]
                                                  //                     ['user_profile']
                                                  //                 // holderid: _holderid(
                                                  //                 //   snapshot.alldocotor[index],
                                                  //                 // ),
                                                  //    )
                                                  //   )
                                                  // );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(left: 20)),
                                        // GestureDetector(
                                        //   onTap: () {
                                        //     Navigator.push(
                                        //         context,
                                        //         MaterialPageRoute(
                                        //             builder: (context) => Detailpage(
                                        //                 doctor: user[index]
                                        //                     ['username'],
                                        //                 email: user[index]['email'],
                                        //                 appointment_datetime:
                                        //                     widget.appointment_date,
                                        //                 //  widget
                                        //                 //     .timer
                                        //                 //     .toString(),
                                        //                 holderid: user[index]
                                        //                         ['user_id']
                                        //                     .toString(),
                                        //                 user_image: user[index]
                                        //                     ['user_profile'])));
                                        //     // setState(() {
                                        //     //   selectedIndexList = 0;
                                        //     //   selectedIndexList1 = 1;
                                        //     // });
                                        //     // Navigator.push(
                                        //     //     context,
                                        //     //     MaterialPageRoute(
                                        //     //         builder: (context) =>
                                        //     //             Detailpage()));
                                        //   },
                                        //   child: Container(
                                        //     height: 33,
                                        //     width: 33,
                                        //     decoration: BoxDecoration(
                                        //         borderRadius:
                                        //             BorderRadius.circular(18),
                                        //         color: selectedIndexList == 0
                                        //             ? Colors.grey
                                        //             : themecolor),
                                        //     child: Icon(Icons.done_outline,
                                        //         color: selectedIndexList == 0
                                        //             ? Colors.white
                                        //             : Colors.black),
                                        //   ),
                                        // ),
                                        // SizedBox(
                                        //   width: 5,
                                        // ),
                                        // GestureDetector(
                                        //   onTap: () {
                                        //     // setState(() {
                                        //     //   selectedIndexList1 = 0;
                                        //     //   selectedIndexList = 1;
                                        //     // });
                                        //     // Navigator.push(
                                        //     //     context,
                                        //     //     MaterialPageRoute(
                                        //     //         builder: (context) =>
                                        //     //             Detailpage()));
                                        //   },
                                        //   child: Container(
                                        //     height: 36,
                                        //     width: 36,
                                        //     decoration: BoxDecoration(
                                        //         borderRadius:
                                        //             BorderRadius.circular(18),
                                        //         color: selectedIndexList1 == 0
                                        //             ? Colors.grey
                                        //             : menucahtcolr),

                                        //     child: Padding(
                                        //       padding:
                                        //           EdgeInsets.only(top: 4, left: 8),
                                        //       child: SvgPicture.asset(
                                        //         'assets/chat1.svg',
                                        //       ),
                                        //     ),

                                        //     // Icon(Icons.chat,
                                        //     //     color: selectedIndexList1 == 0
                                        //     //         ? Colors.white
                                        //     //         : Colors.black),
                                        //   ),
                                        // ),
                                      ],
                                    ));

                        // }
                        // else if(data!=null) {
                        //   return
                        //              Container(
                        //  height: (MediaQuery.of(context).size.height - 280),
                        //     padding: EdgeInsets.only(left: 10, right: 10),
                        //     child:
                        //      ListView.builder(
                        //         itemCount:data == null ? 0 :data.length,
                        //         shrinkWrap: true,
                        //         physics: ClampingScrollPhysics(),
                        //         itemBuilder: (BuildContext contextt, int iindex) {
                        //           List<dynamic> searchdoctor = data;
                        //           return Card(
                        //               child: Row(
                        //             children: <Widget>[
                        //               GestureDetector(
                        //                 onTap: () {
                        //                _doctordata(index);
                        //               },
                        //                 child: Container(
                        //                     width: 55,
                        //                     height: 45,
                        //                     decoration: ShapeDecoration(
                        //                         shape: CircleBorder(
                        //                           side: BorderSide(
                        //                               width: 1,
                        //                               color: Theme.of(context)
                        //                                   .primaryColor),
                        //                         ),
                        //                         image: DecorationImage(
                        //                             fit: BoxFit.fitHeight,
                        //                             image: AssetImage(
                        //                               "assets/profile.png",
                        //                             ),
                        //                             alignment: Alignment.center))),
                        //               ),
                        //               Expanded(
                        //                 child: Column(
                        //                   children: <Widget>[
                        //                     ListTile(
                        //                       //  title: Text(result.body),
                        //                       title: Text(searchdoctor[iindex]['username']),
                        //                       subtitle: Text(searchdoctor[iindex]['email']==null?"":searchdoctor[iindex]['email']),
                        //                       onTap: () {
                        //                         Navigator.push(
                        //                             context,
                        //                             MaterialPageRoute(
                        //                                 builder: (context) =>
                        //                                     Detailpage(
                        //                                          doctor: _user(
                        //                                           searchdoctor[iindex],
                        //                                         ),
                        //                                         email:   _email(
                        //                                           searchdoctor[iindex],
                        //                                         ),
                        //                                         appointment_datetime: widget
                        //                                             .appointment_date
                        //                                             ,
                        //                                         holderid: searchdoctor[
                        //                                                     iindex]
                        //                                                 ['user_id']
                        //                                             .toString()
                        //                                         // holderid: _holderid(
                        //                                         //   snapshot.data[index],
                        //                                         // ),
                        //                                         )));
                        //                       },
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //               Padding(padding: EdgeInsets.only(left: 20)),
                        //               GestureDetector(
                        //                 onTap: () {
                        //                     Navigator.push(
                        //                             context,
                        //                             MaterialPageRoute(
                        //                                 builder: (context) =>
                        //                                     Detailpage(
                        //                                          doctor:
                        //                                        searchdoctor[iindex]['username'],

                        //                                         email: searchdoctor[iindex]['email'],

                        //                                         appointment_datetime:widget.appointment_date,
                        //                                         //  widget
                        //                                         //     .timer
                        //                                         //     .toString(),
                        //                                         holderid: searchdoctor[iindex]['user_id'].toString()

                        //                                         )));
                        //                   // setState(() {
                        //                   //   selectedIndexList = 0;
                        //                   //   selectedIndexList1 = 1;
                        //                   // });
                        //                   // Navigator.push(
                        //                   //     context,
                        //                   //     MaterialPageRoute(
                        //                   //         builder: (context) =>
                        //                   //             Detailpage()));
                        //                 },
                        //                 child: Container(
                        //                   height: 33,
                        //                   width: 33,
                        //                   decoration: BoxDecoration(
                        //                       borderRadius:
                        //                           BorderRadius.circular(18),
                        //                       color: selectedIndexList == 0
                        //                           ? Colors.grey
                        //                           : themecolor),
                        //                   child: Icon(Icons.done_outline,
                        //                       color: selectedIndexList == 0
                        //                           ? Colors.white
                        //                           : Colors.black),
                        //                 ),
                        //               ),
                        //               SizedBox(
                        //                 width: 5,
                        //               ),
                        //               GestureDetector(
                        //                 onTap: () {
                        //                   // setState(() {
                        //                   //   selectedIndexList1 = 0;
                        //                   //   selectedIndexList = 1;
                        //                   // });
                        //                   // Navigator.push(
                        //                   //     context,
                        //                   //     MaterialPageRoute(
                        //                   //         builder: (context) =>
                        //                   //             Detailpage()));
                        //                 },
                        //                 child: Container(
                        //                   height: 36,
                        //                   width: 36,
                        //                   decoration: BoxDecoration(
                        //                       borderRadius:
                        //                           BorderRadius.circular(18),
                        //                       color: selectedIndexList1 == 0
                        //                           ? Colors.grey
                        //                           : menucahtcolr),

                        //                   child: Padding(
                        //                     padding:
                        //                         EdgeInsets.only(top: 4, left: 8),
                        //                     child: SvgPicture.asset(
                        //                       'assets/chat1.svg',
                        //                     ),
                        //                   ),

                        //                   // Icon(Icons.chat,
                        //                   //     color: selectedIndexList1 == 0
                        //                   //         ? Colors.white
                        //                   //         : Colors.black),
                        //                 ),
                        //               ),
                        //             ],
                        //           ));
                        //         }
                        //  //      )
                        //          );
                        //           }
                        })
                        );
    }
  }
}
