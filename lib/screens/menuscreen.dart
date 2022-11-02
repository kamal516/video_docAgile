import 'dart:convert';

import 'package:doctoragileapp/versionpage.dart';
import 'package:flutter/material.dart';
import 'package:doctoragileapp/color.dart';
import 'package:http/http.dart' as http;
import 'package:doctoragileapp/screens/login.dart';
import 'package:doctoragileapp/screens/profilepage.dart';
import 'package:doctoragileapp/triage/aptmntriage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../upcomingappntmnt.dart';
import 'chatlistscreen.dart';
import 'selfassess.dart';

class Menuscreen extends StatefulWidget {
  @override
  _TestcatState createState() => _TestcatState();
}

class _TestcatState extends State<Menuscreen> {
 
       void logout() async{
setState(() {
  
});

SharedPreferences localStorage = await SharedPreferences.getInstance();
 localStorage.remove('localid');
localStorage.remove('token');
   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Loginpage()), (Route<dynamic> route) => false);
//  }

}
void initState(){
  super.initState();
  _localtoken();
}
 void signout() async {
    setState(() {});

    SharedPreferences localStorage = await SharedPreferences.getInstance();
localStorage.clear();
 localStorage.remove('name');
        localStorage.remove('id');
      localStorage.remove('token');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Loginpage()),
        (Route<dynamic> route) => false);

  }
String _loginusername;
String _loginuserphn;
bool _localenable = false;
      _localtoken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
     
      _loginusername=preferences.getString("name");
    _loginuserphn=preferences.getString("phn");
   //  _localenable=preferences.getBool('enablnoti');

    });
  // print(_localenable);
  }
      


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(child: 
       Container(
        padding: EdgeInsets.only(top: 15, left: 5, right: 5,),
        // color: primarydarkcolor,
        child: new Container(
          height: 740,
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
                                
                            )
                            ),
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
                        Text(
                            'MENU',
                            style: TextStyle(color: buttonTextColor, fontSize: 19),
                          ),
                        
                        
                             
                        ]),
                      ),
                      
                      Container(
                    
                         padding:
                              EdgeInsets.only(top: 0, left: 2, right: 2),
                      
                        child:Column(
                         crossAxisAlignment: CrossAxisAlignment.stretch,
                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                        Container(
                              margin: EdgeInsets.only(top: 10.0),
                          height: 200,
                          decoration: BoxDecoration(
                             color: greyContainer,
                          ),
                       
                        child:
                        Column(   mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Row(
                            
                      crossAxisAlignment: CrossAxisAlignment.center,
                             children: <Widget>[
                               Container(
                                  padding: EdgeInsets.only(left:10),
                         height: 80,
                         width: 90,
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(50)
                                 ),
                                 child:    ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                             child: Hero(
                              tag:'',
                                child: Image(
                                  height: 40.0,
                                  width: 40.0,
                                  image: AssetImage('assets/d1.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),),
                               ),
                             
                           Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                      
                          children: <Widget>[
                             Container(
                               width: 140,
                      
                              padding: EdgeInsets.only(top:0,left:20),
                           child: Text(_loginusername,style: TextStyle(fontSize: 18),),),
                              Container(
                                 padding: EdgeInsets.only(left:20),
                           child: Text("Edit your profile",
                                                  style: TextStyle(
                                                      color: greyTextColor))),
                          
              
                          ]
                           ),
                           Row(
                            //  crossAxisAlignment: CrossAxisAlignment.start,
                            //  mainAxisAlignment: MainAxisAlignment.start,
                             children: <Widget>[
                            //  Padding(padding: EdgeInsets.only(left: 7,bottom: 45)),
                             Container(
                         
                                 padding: EdgeInsets.only(top:0,bottom: 40),

                           child:
                           IconButton(icon: Icon(Icons.edit, color: buttonColor), 
                           onPressed: (){
                           
                           Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) 
                      => Profilepage()));
                           }
                           )
                           )  
                             ],
                           )
      ,
      
  //                           Column(
  //                         //  crossAxisAlignment: CrossAxisAlignment.start,
  //                        mainAxisAlignment: MainAxisAlignment.start,
  //                             children: <Widget>[
  //                               Container(
                                 
  //                                  padding: EdgeInsets.only(top:110,right:1),
  //                                  child: RaisedButton(

  //                                    child:Text('SIGNOUT',style: TextStyle(color:Colors.white),) ,onPressed: (){
                        
  //  signout() ;
  //                                    },
  //                                    color: kprimarycolor) ,
  //                               )

  //                             ],
  //                           )


                             ]
                          ),Padding(padding: EdgeInsets.only(left: 80,top:20),child: 
           Container(
        height: 40,
        width: 75,
        child:
            RaisedButton(

                                     child:Text('SIGNOUT',style: TextStyle(color:buttonTextColor,fontSize: 10),) ,onPressed: (){
                        
   signout() ;
                                     },
                                     color: buttonColor) )),
                          ],
                        )
                         
                         
                           ), 
                          
                          ],
                        )
                      ),
                      Container(
                          padding:
                              EdgeInsets.only(top: 30,),
                          //  height: 60,
                          // width: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                           // mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Chatscreen()));
    },
    child: SizedBox(
    height: 40,
    width: 100,
    child: Container(
        decoration: BoxDecoration(
           color: greyContainer,
            borderRadius: BorderRadius.vertical(),
            border: Border.all(color: containerBorderColor)),
            padding: EdgeInsets.only(top:7,left: 16),
            child: Text(
                'INBOX',
                style: TextStyle(fontSize: 17,),
                textAlign: TextAlign.left,
            ),
        ),
    ),
),

                            InkWell(
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Selfassess()));
    },
    child: SizedBox(
    height: 40,
    width: 100,
    child: Container(                                                                                                                                                                                                                          
        decoration: BoxDecoration(
          color: greyContainer,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: containerBorderColor)),
            padding: EdgeInsets.only(top:7,left: 16),
            child: Text(
                'AVAILABILITY',
                style: TextStyle(fontSize: 17,),
                textAlign: TextAlign.left,
            ),
        ),
    ),
),
   
                            InkWell(
    onTap: (){  Navigator.push(context, MaterialPageRoute(builder: (context)=>EventSelect()));},
    child: SizedBox(
    height: 40,
    width: 100,
    child: Container(
        decoration: BoxDecoration(
          color: greyContainer,
           borderRadius: BorderRadius.circular(3),
            border: Border.all(color: containerBorderColor)),
            padding: EdgeInsets.only(top:7,left: 16),
            child: Text(
                'CALENDAR',
                style: TextStyle(fontSize: 17,),
                textAlign: TextAlign.left,
            ),
        ),
    ),
),

                            InkWell(
    onTap: (){
       Navigator.push(context, MaterialPageRoute(builder: (context)=>Upcomingappointment()));
       // Navigator.push(context, MaterialPageRoute(builder: (context)=>Selfassess()));
    },
    child: SizedBox(
    height: 40,
    width: 100,
    child: Container(
        decoration: BoxDecoration(
          color: greyContainer,
           borderRadius: BorderRadius.circular(3),
            border: Border.all(color: containerBorderColor)),
            padding: EdgeInsets.only(top:7,left: 16),
            child: Text(
                'APPOINTMENTS',
                style: TextStyle(fontSize: 17,),
                textAlign: TextAlign.left,
            ),
        ),
    ),
),


                            InkWell(
    onTap: (){
  //    Navigator.push(context, MaterialPageRoute(builder: (context)=>Chatscreen()));
    },
    child: SizedBox(
    height: 40,
    width: 100,
    child: Container(
        decoration: BoxDecoration(
          color: greyContainer,
           borderRadius: BorderRadius.circular(3),
            border: Border.all(color: containerBorderColor)),
            padding: EdgeInsets.only(top:7,left: 16),
            child: Text(
                'SETTINGS',
                style: TextStyle(fontSize: 17,),
                textAlign: TextAlign.left,
            ),
        ),
    ),
),


                            InkWell(
    onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Versionpage()));},
    child: SizedBox(
    height: 40,
    width: 100,
    child: Container(
        decoration: BoxDecoration(
          color: greyContainer,
           borderRadius: BorderRadius.circular(3),
            border: Border.all(color: containerBorderColor)),
            padding: EdgeInsets.only(top:7,left: 16),
            child: Text(
                'ABOUT',
                style: TextStyle(fontSize: 17,),
                textAlign: TextAlign.left,
            )
        ),
    ),
),

                               
                            ],
                          ))
                    ]),
              ],
            )),)
      ),
    );
  }
}
