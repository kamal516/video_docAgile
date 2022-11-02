

// import 'package:flutter/material.dart';


// import 'package:newagileapp/color.dart';



// class AppointmentList extends StatefulWidget {
//   @override
//   _AppointmentpageState createState() => _AppointmentpageState();
// }

// enum FormType { login, register }

// class _AppointmentpageState extends State<AppointmentList> {
//   TextEditingController useremail = new TextEditingController();
//   TextEditingController userpassword = new TextEditingController();
// // ignore: unused_field
//   bool _login = false;
// // ignore: unused_field
//   FormType _formtype = FormType.login;

// // _loginset() async {
// // await http.post("http://192.168.1.9:3040/login", body: {
// // 'username': useremail.text,
// // 'password': userpassword.text,
// // }).then((result) async {
// // print(result.body);
// // var data = jsonDecode(result.body);
// // if (data['error'] == 'User does not exist') {
// // return null;
// // } else if (data['error'] == 'Something went Wrong..!!') {
// // return null;
// // } else {
// // setState(() {
// // _login = true;
// // });
// // var body = json.decode(result.body);
// // SharedPreferences localStorage = await SharedPreferences.getInstance();
// // //localStorage.setString('token',result.body);
// // localStorage.setString('token', body['token']);
// // localStorage.setString('name', body['username']);
// // localStorage.setString('desc', body['description']);
// // localStorage.setString('phn', body['phone_number1']);
// // localStorage.setString('adrs', body['address1']);
// // // return json.decode(result.body);
// // Navigator.push(
// // context, MaterialPageRoute(builder: (context) => Testcat()));
// // }
// // });
// // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         bottomNavigationBar: Row(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: <Widget>[
//             GestureDetector(
//                 child: Row(
//               children: <Widget>[
//                 Container(
//                     height: 101,
//                     width: 128,
//                     color: Colors.blue,
//                     padding: EdgeInsets.only(top: 15),
//                     child: Column(
//                       children: <Widget>[
//                         Icon(
//                           Icons.time_to_leave,
//                           color: Colors.white,
//                           size: 32,
//                         ),
//                         SizedBox(
//                           height: 15,
//                         ),
//                         Text(
//                           'SERVICE',
//                           style: TextStyle(color: Colors.white, fontSize: 18),
//                         )
//                       ],
//                     )),
//                 SizedBox(width: 3),
//                 Container(
//                     height: 101,
//                     width: 128,
//                     color: Colors.blue,
//                     padding: EdgeInsets.only(top: 15),
//                     child: Column(
//                       children: <Widget>[
//                         Icon(Icons.calendar_view_day,
//                             color: Colors.white, size: 32),
//                         SizedBox(height: 15),
//                         Text(
//                           'APPOINTMENT',
//                           style: TextStyle(color: Colors.white, fontSize: 18),
//                         )
//                       ],
//                     )),
//                 SizedBox(width: 3),
//                 Container(
//                     height: 101,
//                     width: 128,
//                     color: Colors.blue,
//                     padding: EdgeInsets.only(top: 15),
//                     child: Column(
//                       children: <Widget>[
//                         Icon(
//                           Icons.chat_bubble,
//                           color: Colors.white,
//                           size: 32,
//                         ),
//                         SizedBox(
//                           height: 15,
//                         ),
//                         Text(
//                           'CHAT',
//                           style: TextStyle(color: Colors.white, fontSize: 18),
//                         )
//                       ],
//                     )),
//               ],
//             )),
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: <Widget>[
//               Stack(
//                 children: <Widget>[
//                   ClipPath(
// //clipper: WaveClipperTwo(),
//                     child: Container(
//                       decoration: BoxDecoration(color: themecolor),
//                       height: 200,
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.only(top: 165, left: 5, right: 5),
//                     height: 658.0,
//                     color: themecolor,
//                     child: new Container(
//                         decoration: new BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: new BorderRadius.only(
//                               topLeft: const Radius.circular(40.0),
//                               topRight: const Radius.circular(40.0),
//                             )),
//                         padding: EdgeInsets.only(top: 50, left: 20, right: 20),
//                         child: new Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: <Widget>[
//                             Container(
// // padding: EdgeInsets.only(left: 10, bottom: 10),
//                               child: Text(
//                                 'Welcome!',
//                                 style:
//                                     TextStyle(fontSize: 15, color: Colors.grey),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             Text("John Smith",
//                                 style: TextStyle(
//                                     fontSize: 20, fontWeight: FontWeight.bold)),
//                             SizedBox(
//                               height: 20,
//                             ),
//                             Text("Upcoming Appointments List",
//                                 style: TextStyle(
//                                     fontSize: 12, color: Colors.grey)),
//                             SizedBox(
//                               height: 5,
//                             ),
//                             Expanded(
//                               child: ListView(
//                                 children: <Widget>[
//                                   Container(
//                                       width: 250,
// // margin: EdgeInsets.symmetric(
// // horizontal: 20.0, vertical: 10.0),
//                                       decoration: BoxDecoration(
//                                         border: Border.all(
//                                           width: 1.0,
//                                           color: Colors.grey[200],
//                                         ),
//                                       ),
//                                       child: Container(
//                                         width: 200,
//                                         child: Row(
//                                           children: <Widget>[
//                                             Container(
//                                                 width: 55,
//                                                 height: 55,
//                                                 decoration: ShapeDecoration(
//                                                     shape: CircleBorder(
//                                                       side: BorderSide(
//                                                           width: 1,
//                                                           color: Theme.of(
//                                                                   context)
//                                                               .primaryColor),
//                                                     ),
//                                                     image: DecorationImage(
//                                                         fit: BoxFit.fill,
//                                                         image: AssetImage(
//                                                             "assets/images/cartoon-male-doctor-holding-clipboard_29190-4660.jpg"),
//                                                         alignment:
//                                                             Alignment.center))),
//                                             Expanded(
//                                               child: Container(
//                                                 margin: EdgeInsets.all(12.0),
//                                                 child: Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: <Widget>[
//                                                     Text(
//                                                       "David Reynold",
//                                                       style: TextStyle(
//                                                         fontSize: 14.0,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                       ),
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                     ),
// // RatingStars(5),
//                                                     SizedBox(height: 4.0),
//                                                     Text(
//                                                       'Heart Specialist',
//                                                       style: TextStyle(
//                                                         fontSize: 12.0,
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                       ),
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                     ),
//                                                     SizedBox(height: 20.0),
//                                                     Row(
//                                                       children: <Widget>[
//                                                         Container(
//                                                           width: 120,
//                                                           padding:
//                                                               EdgeInsets.all(5),
//                                                           decoration:
//                                                               BoxDecoration(
//                                                                   color: Colors
//                                                                       .pinkAccent),
//                                                           child: Column(
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .start,
//                                                             crossAxisAlignment:
//                                                                 CrossAxisAlignment
//                                                                     .start,
//                                                             children: <Widget>[
//                                                               Text(
//                                                                 "Friday,10 Nov 2020 ",
//                                                                 style: TextStyle(
//                                                                     fontSize:
//                                                                         10,
//                                                                     color: Colors
//                                                                         .white),
//                                                               ),
//                                                               Text("4.00 PM",
//                                                                   style: TextStyle(
//                                                                       fontSize:
//                                                                           10,
//                                                                       color: Colors
//                                                                           .white))
//                                                             ],
//                                                           ),
//                                                         ),
//                                                         SizedBox(
//                                                           width: 5,
//                                                         ),
//                                                         Container(
//                                                           padding:
//                                                               EdgeInsets.all(5),
//                                                           width: 80,
//                                                           decoration: BoxDecoration(
//                                                               color: Colors
//                                                                   .lightBlueAccent),
//                                                           child: Column(
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .start,
//                                                             crossAxisAlignment:
//                                                                 CrossAxisAlignment
//                                                                     .start,
//                                                             children: <Widget>[
//                                                               Text("Time Left ",
//                                                                   style: TextStyle(
//                                                                       fontSize:
//                                                                           10,
//                                                                       color: Colors
//                                                                           .white)),
//                                                               Text(
//                                                                   "12Hrs 39mins",
//                                                                   style: TextStyle(
//                                                                       fontSize:
//                                                                           10,
//                                                                       color: Colors
//                                                                           .white))
//                                                             ],
//                                                           ),
//                                                         )
//                                                       ],
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                             IconButton(
//                                                 icon: Icon(Icons.message),
//                                                 onPressed: null)
//                                           ],
//                                         ),
//                                       )),
//                                 ],
//                               ),
//                             )
//                           ],
//                         )),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ));
//   }
// }
