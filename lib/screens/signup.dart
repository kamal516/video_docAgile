
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:http/http.dart' as http;
// import 'package:doctoragileapp/api.dart';
// import 'package:doctoragileapp/color.dart';
// import 'package:doctoragileapp/theme2.dart';


// import 'package:doctoragileapp/upcomingappntmnt.dart';
// import 'package:shared_preferences/shared_preferences.dart';



// class SigninPage extends StatefulWidget {
//   final String appid_token;
//   SigninPage({this.appid_token});
//  @override
//   State<StatefulWidget> createState() => new _LoginPageState();
// }

// enum FormType { login, register }

// class _LoginPageState extends State<SigninPage> {
//   String _email;
//   String _nname;
//   String _pphonenum;
//   String _password;
//     final _formKey = GlobalKey<FormState>();
//      final _formname = GlobalKey<FormState>();
//       final _formphonenum = GlobalKey<FormState>();
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   final formkey = new GlobalKey<FormState>();
//  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   FormType _formtype = FormType.login;
// TextEditingController useremail =new TextEditingController();
// TextEditingController userpassword =new TextEditingController();
// TextEditingController _name =new TextEditingController();
// // TextEditingController _description =new TextEditingController();
// TextEditingController _phone =new TextEditingController();
// TextEditingController _address =new TextEditingController();
//    bool _validate = false;
//   bool validateandsave() {
//     final form = formkey.currentState;
//     if (form.validate()) {
//       form.save();
//       return true;
//     }
//     return false;
//   }
//  @override
//   void initState() {
//     super.initState();
//    getapptokenid();
//     }
//   AlertDialog alert = AlertDialog(
//     title: Text("Notice"),
//     content: Text("go to login"),
//   );

 
//  String apptoken_id;

//   getapptokenid() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     setState(() {
//       apptoken_id = preferences.getString("appidtoken");
   
//     });
   
 
//   }
  

//   void movetoRegister() {
//     formkey.currentState.reset();
//     setState(() {
//       _formtype = FormType.register;
//     });
//   }

//   void movetoLogin() {
//     formkey.currentState.reset();
//     setState(() {
//       _formtype = FormType.login;
//     });
//   }
// bool _login= false;
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//        key: _scaffoldKey,
//       bottomNavigationBar: BottomAppBar(child: 
//         Container(
//            decoration: BoxDecoration(color: primarydarkcolor),
//         padding: EdgeInsets.only(bottom: 20,left:10,right:10),
//                                   child: new RaisedButton(
//                                       color: buttonColor,
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.vertical(),
                                       
//                                           side:
//                                               BorderSide(color: Colors.black)),
//                                       child: new Text(
//                                         'REGISTER',
//                                         style: TextStyle(
//                                             color: Colors.white, fontSize: 19),
//                                       ),
//                                       onPressed: () {
                                
                                 
//                                         _logindata();
                                
//                                       }),
//                                 ),),
//         body: SingleChildScrollView(
//           child: Stack(
//             children: <Widget>[
//               Container(
//               height:MediaQuery.of(context).size.height / 1.1,
//                 color: Colors.black,
//                 child: Stack(
//                   children: <Widget>[
//                     Padding(
//                       padding: EdgeInsets.only(top: 0, left: 0),
//                       child: Image(
//                         height: 250.0,
//                         width: 450.0,
//                         image: AssetImage('assets/Logo_new.png'),
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(top: 250),
//                       child: new Container(
                       
//                           decoration: new BoxDecoration(
//                               boxShadow: [
//                                 new BoxShadow(
//                                   color: Colors.black,
//                                   blurRadius: 20.0,
//                                 ),
//                               ],
//                               color: Colors.white,
//                               borderRadius: new BorderRadius.only(
//                                 topLeft: const Radius.circular(40.0),
//                                 topRight: const Radius.circular(40.0),
//                               )),
//                           padding:
//                               EdgeInsets.only(top: 50, left: 40, right: 40),
//                           child: new Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: <Widget>[
                              
//                               Container(
//                                 padding: EdgeInsets.only(bottom: 20),
//                                 child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                   children: <Widget>[
//                                     GestureDetector(
//                                       onTap: (){
//                                         Navigator.pop(context);
//                                       },
//                                       child:     Container(
//                                     height: 30,
//                                     width: 30,
//                                decoration: BoxDecoration(
//                                  borderRadius: BorderRadius.circular(20.0),
//                                   color: Colors.grey[200]
//                                ),
//                              padding: EdgeInsets.only(top:7),
//                                       child:  SvgPicture.asset(
//                               'assets/back.svg',
                            
//                             ),
                          
                                 
//                                     ),
//                                     ),
                                
                        
//                                      Text(
//                                   'REGISTER',
//                                   style: TextStyle(fontSize: 19),
//                                 ),
                        
//                                  Container(
//                                     height: 30,
//                                     width: 30,
//                                decoration: BoxDecoration(
//                                  borderRadius: BorderRadius.circular(20.0),
//                                   color: Colors.grey[200]
//                                ),
//                              padding: EdgeInsets.only(top:7,left: 10),
//                                       child:  SvgPicture.asset(
//                               'assets/close.svg',
                            
//                             ),
                       
//                                     ),
//                                   ],
//                                 )
                               
//                               ),
//                               Form(
//                                    key: _formKey,
//                                 child: Column(
//                                   children: <Widget>[
//                     TextFormField(
//         controller: _name,
//         keyboardType: TextInputType.emailAddress,
//         decoration: new InputDecoration(
//             labelText: 'Name',
//      filled: true,
//                                             fillColor: primarylightcolor,
//           border: 
//             new OutlineInputBorder(
//                 borderRadius: new BorderRadius.vertical()
//                 ,)
//                 ),
//                   validator: (val) {
//                                       if (val.length == 0)
//                                         return "Please enter name";
                                    
                                   
//                                     },
//                                     onSaved: (val) => _nname = val,
       
//       ),
//        SizedBox(
//         height: 10.0,
//       ),
      
//          TextFormField(
//                                     controller: useremail,
//                                     keyboardType: TextInputType.emailAddress,
//                                     decoration: new InputDecoration(
//                                         labelText: 'Email',
//                                        filled: true,
//                                             fillColor: primarylightcolor,
//                                         border: new OutlineInputBorder(
//                                           borderRadius:
//                                               new BorderRadius.vertical(),
//                                         )),
//                                     validator: (val) {
//                                       if (val.length == 0)
//                                         return "Please enter email";
//                                       else if (!val.contains("@"))
//                                         return "Please enter valid email";
                                   
//                                     },
//                                     onSaved: (val) => _email = val,
                                  
//                                   ),
//                                     SizedBox(
//         height: 10.0,
//       ),
     
//         TextFormField(
          
//         controller: _phone,
//          autocorrect: true,
//                   keyboardType: TextInputType.number,
//         maxLength: 15,
//          inputFormatters: <TextInputFormatter>[
//                     WhitelistingTextInputFormatter.digitsOnly
//                    ],
//            decoration: new InputDecoration(
//             labelText: 'Phone number',
//          filled: true,
//                                             fillColor: primarylightcolor,
//           border: 
//             new OutlineInputBorder(
//                 borderRadius: new BorderRadius.vertical()
//                 ,)
//                 ),
//                   validator: (val) {
//                                       if (val.length == 0)
//                                         return "Please enter phonenumber";
                                     
//                                    },
//                                     onSaved: (val) => _pphonenum = val,
       
//       ),
//                                   ],
//                                 )
        
//                           ),
     
//        SizedBox(
//         height: 10.0,
//       ),
//        TextFormField(
//          obscureText: true,
//         controller: userpassword,
//         keyboardType: TextInputType.emailAddress,
//         decoration: new InputDecoration(
//             labelText: 'Password',
//         filled: true,
//                                             fillColor: primarylightcolor,
//           border: 
//             new OutlineInputBorder(
//                 borderRadius: new BorderRadius.vertical()
//                 ,)
//                 ),
       
//       ),
     
     
     
//       SizedBox(
//         height: 10,
//       )
//                             ],
//                           )),
//                     ),
                  
//                   ],
//                 ),
//               ),
      
//             ],
//           ),
//         ));
//   }

 
//     _logindata() async {
//       _formKey.currentState.validate();
//          if(useremail.text.length==0 || _phone.text.length==0 || _name.text.length==0 || userpassword.text.length==0 || !useremail.text.contains("@"))
//     {
//       return;
//     }
// //   if(_name.text==""||useremail.text==""||userpassword.text==""){
// //    return showDialog(
// //         context: context,
// //         builder: (BuildContext context) {
     
// //           return AlertDialog(
// //             title: Text("Please, Insert all required fields"),
// // // content: const Text('This item is no longer available'),
// //             actions: [
// //               FlatButton(
// //                 child: Text('Ok'),
// //                 onPressed: () {
// //               Navigator.pop(context);
// //               _name.clear();
// //               _address.clear();
// //              _phone.clear();
// //              useremail.clear();
// //              userpassword.clear();

// //                 },
// //               ),
// //             ],
// //           );
// //         },
// //       );
// //   }

//  // else{
           
// final response = await http.post(apipath + '/register',
//    body: {
//       "username":_name.text,
//     "email": useremail.text,
//    "phone_number1":_phone.text,
//     "appToken": widget.appid_token==null?'': widget.appid_token,
//    "password": userpassword.text,
   
//   }).then((result) async {
//       print(result.body);
//       var data = jsonDecode(result.body);
//       if(data['error'] == 'Email already exists'){
//         return showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           Map<String, dynamic> user = jsonDecode(result.body);
//           return AlertDialog(
//             title: Text("User already exists"),
// // content: const Text('This item is no longer available'), 
//             actions: [
//               FlatButton(
//                 child: Text('Ok'),
//                 onPressed: () {
//               Navigator.pop(context);
//               _name.clear();
//               _address.clear();
//              _phone.clear();
//              useremail.clear();
//              userpassword.clear();

//                 },
//               ),
//             ],
//           );
//         },
//       );
      
//       }
//       else if(data['error'] == 'Invalid Email'){
// return null;
//       }
//        else if(data == 'Fill all details..!'){
// return null;
//       }
//       else{
//  setState(() {
//       _login=true;
//     });
//     _email;
//     var body = json.decode(result.body);
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     //localStorage.setString('token',result.body);
//   localStorage.setString('token', body['token']);
//   localStorage.setString('name', body['username']);
//    localStorage.setString('token', body['token']);
//         localStorage.setString('id', body['user_id'].toString());
//         localStorage.setString('desc', body['description']);
//         localStorage.setString('phn', body['phone_number1']);
//         localStorage.setString('adrs', body['address1']);
//         localStorage.setString('email', body['email']);
// // return json.decode(result.body);
//    Navigator.push(context, MaterialPageRoute(builder:(context)=>Upcomingappointment()));
//       }
   
//     });
// //  }
  
//   // _scaffoldKey.currentState.showSnackBar(
//   //                     new SnackBar(duration: new Duration(seconds: 4), content:
//   //                     new Row(
//   //                       children: <Widget>[
//   //                         new CircularProgressIndicator(),
//   //                         new Text("  Signing-In...")
//   //                       ],
//   //                     ),
//   //                     ));
// }
//  _loginset() async {
//     await http.post("http://192.168.1.9:3040/login",
//         body: {
//           'email': useremail.text,
//             'password': userpassword.text,
//         }).then((result) async {
//       print(result.body);
//       var data = jsonDecode(result.body);
//       if(data ['error'] == 'User does not exist'){
//         return null;
//       }else{
//  setState(() {
//       _login=true;
//     });
//     var body = json.decode(result.body);
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     //localStorage.setString('token',result.body);
// localStorage.setString('token', body['token']);
// // return json.decode(result.body);
//    Navigator.push(context, MaterialPageRoute(builder: (context)=>Categoryset()));
//       }
   
  
//     });
//   }


// }
