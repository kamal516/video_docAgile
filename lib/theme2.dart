import 'dart:convert';
import 'package:doctoragileapp/widget/bottomnavbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:doctoragileapp/api.dart';
import 'package:doctoragileapp/color.dart';
import 'package:http/http.dart' as http;
import 'package:doctoragileapp/screens/login.dart';
import 'package:doctoragileapp/triage/aptmntriage.dart';
import 'package:doctoragileapp/triage/triagedescp.dart';
import 'package:doctoragileapp/upcomingappntmnt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Categoryset extends StatefulWidget {
  @override
  _TestcatState createState() => _TestcatState();
}

class _TestcatState extends State<Categoryset> {
  String _token;
  _gettoken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _token = preferences.getString("token");
    });
  }

  String _catg(dynamic user) {
    return user['category'];
  }

  String _image(dynamic user) {
    return user['icon'];
  }

  int _id;
  String _description(dynamic user) {
    return user['description'];
  }

  bool press = true;
  void initState() {
    super.initState();
    _gettoken();
    press = false;
    _getScreen();
  }
  bool _homeScreen=false;
bool _chatScreen=false;
bool _serviceScreen;
bool _eventScreen=false;
_getScreen()async{
SharedPreferences preferences = await SharedPreferences.getInstance();
setState(() {
_serviceScreen=true;
});
preferences.setBool("HomePage", _homeScreen);
preferences.setBool("ChatPage", _chatScreen);
preferences.setBool("ServicePage", _serviceScreen);
preferences.setBool("EventPage", _eventScreen);
}





  final String apiUrl = apipath + '/triage_test';

  Future<List<dynamic>> fetchUsers() async {
    var result = await http.get(apiUrl);
    print(result.body);
    return json.decode(result.body);
  }

  var _firstPress = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: primarydarkcolor,
      bottomNavigationBar: BottomNavBar(),
      body: Container(
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
                        decoration: new BoxDecoration(
                            color: buttonColor,
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(40.0),
                              topRight: const Radius.circular(40.0),
                            )),
                        child: Row(children: <Widget>[
                          SizedBox(
                            width: 150,
                          ),
                          Text(
                            'SERVICE',
                            style: TextStyle(color: Colors.white, fontSize: 19),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ]),
                      ),
                    ]),
                Container(
                    height: (MediaQuery.of(context).size.height - 188),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.only(top: 4, left: 10, right: 10),
                    child: FutureBuilder(
                        future: fetchUsers(),
                        builder: (
                          BuildContext context,
                          AsyncSnapshot snapshot,
                        ) {
                          if (snapshot.hasData) {
                            print((snapshot.data[0]));
                            return ListView.builder(
                                itemCount: snapshot.data.length,

                                // itemCount: data==null?0:data.length,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  // List<dynamic> user =data;
                                  return Card(
                                      color: greyContainer,
                                      child: Row(children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Triagedescription(
                                                            id: snapshot.data[index][
                                                                'triage_test_id'],
                                                            cat: snapshot.data[
                                                                    index][
                                                                'category'],
                                                            desc: snapshot
                                                                    .data[index]
                                                                ['description'],
                                                            image: snapshot
                                                                    .data[index]
                                                                ['icon'])));
                                            //     _doctordata(index);
                                            // Navigator.pushReplacement(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) => Doctorinfo(
                                            //             //    detaildoctor:doctorbyiddata
                                            //             )));
                                          },
                                          child: Container(
                                            // height: 110,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color: greyContainer,
                                              borderRadius:
                                                  BorderRadius.vertical(),
                                            ),
                                            padding: EdgeInsets.only(
                                                top: 30, bottom: 25),
                                            child: SvgPicture.network(
                                                _image(snapshot.data[index])),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => Triagedescription(
                                                              id: snapshot
                                                                      .data[index]
                                                                  [
                                                                  'triage_test_id'],
                                                              cat: snapshot
                                                                      .data[index]
                                                                  ['category'],
                                                              desc: snapshot
                                                                      .data[index]
                                                                  [
                                                                  'description'],
                                                              image: snapshot
                                                                      .data[index]
                                                                  ['icon'])));
                                                },
                                                child: ListTile(
                                                    //  title: Text(result.body),
                                                    title: Text(_catg(
                                                        snapshot.data[index])),
                                                    subtitle: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            _description(
                                                                snapshot.data[
                                                                    index]),
                                                            maxLines:
                                                                press ? 20 : 3,
                                                            textAlign: TextAlign
                                                                .start),
                                                        InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => Triagedescription(
                                                                          id: snapshot.data[index]
                                                                              [
                                                                              'triage_test_id'],
                                                                          cat: snapshot.data[index]
                                                                              [
                                                                              'category'],
                                                                          desc: snapshot.data[index]
                                                                              [
                                                                              'description'],
                                                                          image:
                                                                              snapshot.data[index]['icon'])));
                                                              // setState(() {
                                                              //     press = !press;
                                                              // });
                                                            },
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                press
                                                                    ? Text(
                                                                        "Show Less",
                                                                        style: TextStyle(
                                                                            color:
                                                                                buttonColor,
                                                                            fontSize:
                                                                                14),
                                                                      )
                                                                    : Text(
                                                                        "Show More",
                                                                        style: TextStyle(
                                                                            color:
                                                                                buttonColor,
                                                                            fontSize:
                                                                                14),
                                                                      )
                                                              ],
                                                            ))
                                                      ],
                                                    )

                                                    //  Text(
                                                    //    _description( snapshot.data[index])  ),

                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) =>
                                                    //             Detailpage(
                                                    //                  doctor:
                                                    //                  snapshot.data[index]['username'],

                                                    //                 email: snapshot.data[index]['email'],

                                                    //                 holderid: snapshot.data[index]['user_id'].toString()

                                                    //                 )
                                                    //                 ));

                                                    ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ]));
                                });
                          }
                          return Center(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black)));
                        })),
              ],
            )),
      ),
    );
  }
}
