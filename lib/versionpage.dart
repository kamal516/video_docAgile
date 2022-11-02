import 'package:doctoragileapp/color.dart';
import 'package:flutter/material.dart';

class Versionpage extends StatefulWidget {


  @override
  _VersionpageState createState() => _VersionpageState();
}

class _VersionpageState extends State<Versionpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: buttonColor,
        title: Text('About app'),

      ),
      body: Container(
        child:
        Center(child:Column(
          children: [
            Text('Agilemed',style: TextStyle(color:Colors.black,fontSize: 25),),
 Text('Version - 1.0',style: TextStyle(color:Colors.black,fontSize: 20),),

          ],
        )
       
       ) ),
    );
  }
}