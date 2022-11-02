import 'dart:async';
import 'dart:convert';
import 'package:doctoragileapp/screens/zoomwebmeeting.dart';
import 'package:doctoragileapp/webrtc_videoCall/signaling.dart';
import 'package:doctoragileapp/webrtc_videoCall/video_page.dart';
import 'package:doctoragileapp/widget/joinmeeting.dart';
import 'package:doctoragileapp/widget/zoommeeting.dart';
import 'package:flutter/material.dart';
import 'package:doctoragileapp/api.dart';
import 'package:doctoragileapp/color.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;
import 'package:doctoragileapp/messagelist.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:io' as io;

class Chatlist extends StatefulWidget {
  final String doctorname;
  final String holderid;
  Chatlist({this.doctorname, this.holderid});
  @override
  _TestcatState createState() => _TestcatState();
}

class _TestcatState extends State<Chatlist>
    with SingleTickerProviderStateMixin {
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String roomId;
  TextEditingController textEditingController = TextEditingController(text: '');
  bool recording = false;
  int _time = 0;
  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    // requestPermissions();
    // startTimer();
    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });
    signaling.openUserMedia(_localRenderer, _remoteRenderer);
    super.initState();

    getid();
    startTimer();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  static Database _db;
  static const String DB_NAME = "chat.db";
  static const String TABLE = "message";
  static const String Messagelist = "messagelist";
  static const String To = "to_id";
  static const String From = "from_id";
  static const String MessageDate = "messagedate";
  static const String Max = "maxdate";

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await chatdb();
    return _db;
  }

  chatdb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _createchatdb);
    return db;
  }

  _createchatdb(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE(   messageid  INTEGER PRIMARY KEY ,$To TEXT,$From TEXT,$MessageDate TEXT,$Messagelist TEXT)");
  }

  List messageslist = [];
  var selectmaxid;

  _chatlist() async {
    var dbClient = await db;
// dbClient.delete("message");

    var test = await dbClient.rawQuery(
        "Select * from $TABLE  where ($From=$_localid and $To='${widget.holderid}') or ($From='${widget.holderid}'  and $To=$_localid) order by messageid  desc LIMIT 15");

    // print(test);
    setState(() {
      messageslist = test;
    });

    selectmaxid = await dbClient.rawQuery(
        "select Max(messageid) AS maxid  FROM $TABLE  where ($From=$_localid and $To='${widget.holderid}') or ($From='${widget.holderid}'  and $To=$_localid)");

    // print(selectmaxid[0]["maxid"].toString());

    // print(messageslist);

    _getmessage();
  }

  void startTimer() {
    _timer = new Timer.periodic(new Duration(seconds: 1), (time) {
      _chatlist();
    });
  }

  @override
  void deactivate() {
    if (_timer.isActive) {
      _timer.cancel();
    } else {
      startTimer();
    }
    super.deactivate();
  }

  Timer _timer;
  bool openDialog;
  String _localid;
  String _localname;
  getid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _localid = preferences.getString("id");
      _localname = preferences.getString("name");
    });

    _chatlist();
  }

  List fetchmeassagedata;
  String messagedata;
  int modifyList;
  int donelist;

  TextEditingController message = new TextEditingController();

  Future<List> _getmessage() async {
    var dbClient = await db;

    final response = await http.post(apipath + '/getAllMessage', body: {
      "from_user_id": _localid,
      "to_user_id": widget.holderid,
      "messagechat_id": selectmaxid[0]["maxid"].toString(),
      'timezone': dateTime.timeZoneName
      // "created_at": selectmaxdate[0]["MAXDATE"].toString()
    }).then((result) async {
      // print(result.body);

      setState(() {
        fetchmeassagedata = jsonDecode(result.body);
      });

      for (int i = 0; i <= fetchmeassagedata.length - 1; i++) {
        var table =
            ("INSERT OR REPLACE INTO $TABLE (  'messageid', $To , $From ,$MessageDate  ,$Messagelist )   VALUES (${fetchmeassagedata[i]['messagechat_id']}, ${fetchmeassagedata[i]['to_user_id']},'${fetchmeassagedata[i]['from_user_id']}','${fetchmeassagedata[i]['created_at']}','${fetchmeassagedata[i]['message_summary']}')");
        dbClient.transaction((txn) async {
          // print(table);

          return await txn.rawInsert(table);
        });
      }
    });
  }

  DateTime dateTime = DateTime.now();
  Future<List> _sendmessage() async {
    final response = await http.post(apipath + '/addMessage', body: {
      "from_user_id": _localid,
      "to_user_id": widget.holderid,
      "message_summary": message.text,
      'timezone': dateTime.timeZoneName
    }).then((value) async {
      // print(value.body);
      setState(() {
        messagedata = value.body;
      });
      // print(messagedata);
      message.text = "";
      _getmessage();
    });
  }

  var confirmVideo;
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

  Map<String, dynamic> _getJwtToken;
  Map<String, dynamic> _getZoomToken;
  Map<String, dynamic> _getZakToken;
  var _zoomUserID = 'isv@agilemedconnect.com';
  bool _loading;
  Future<List> _getTokenCred(BuildContext context) async {
    setState(() {
      _loading = true;
      _loadingCall(_loading, context);
    });
    final response = await http.post(apipath + '/newmeetingforapp', body: {
      "email": "isv@agilemedconnect.com",
    }).then((value) async {
      // print(value.body);
      setState(() {
        _getJwtToken = jsonDecode(value.body);
      });

      var _jwtToken = _getJwtToken['token'];
      var _meetingID = _getJwtToken['meetingid'];
      var _zoomToken;

      final response = await http
          .get(
              'https://api.zoom.us/v2/users/isv@agilemedconnect.com/token?type=token&access_token=' +
                  _jwtToken)
          .then((zoomvalue) {
        // print(zoomvalue.body);

        setState(() {
          _getZoomToken = jsonDecode(zoomvalue.body);
          message.text = _getJwtToken['msg_url'].toString();
        });
        _zoomToken = _getZoomToken['token'];
      });
      var _zakToken;
      final response2 = await http
          .get(
              'https://api.zoom.us/v2/users/isv@agilemedconnect.com/token?type=zak&access_token=' +
                  _jwtToken)
          .then((jwtvalue) {
        // print(jwtvalue.body);
        setState(() {
          _getZakToken = jsonDecode(jwtvalue.body);
        });
        _zakToken = _getZakToken['token'];
        if (_zakToken != null) {
          setState(() {
            _loading = false;
            _loadingCall(_loading, context);
            _sendmessage();
          });
        }
      });

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return StartMeetingWidget(
                displayname: _localname,
                meetingId: _meetingID,
                zaktoken: _zakToken,
                zoomtoken: _zoomToken);
          },
        ),
      );
    });
  }

  Map<String, dynamic> getCred;
  String _joinUrl;

  // Future<List> _zoomMeeting(BuildContext context) async {
  //   final response = await http.post(apipath + '/newmeeting', body: {
  //     "email": "isv@agilemedconnect.com",
  //   }).then((value) async {
  //     print(value.body);

  //     setState(() {
  //       getCred = jsonDecode(value.body);
  //       _joinUrl = getCred['join_url'];
  //     });
  //     print(_joinUrl);
  //     var _replaceDomain =
  //         _joinUrl.replaceAll("https://zoom.us/j/", "**meeting:");
  //     setState(() {
  //       message.text = _replaceDomain;
  //     });
  //     if(openDialog!=true){
  //    _showDialog(context);
  //     }

  //     //  return _showConfirmation(context);
  //     //  var _replaceMeeting=_replaceDomain.replaceAll("https://zoom.us/s/", "").replaceAll("?", "&").replaceAll("=", "&").replaceAll("#", "&");
  //     // var _getMeetingCred=_replaceMeeting.split("&");
  //     _getmessage();
  //   });
  // }

  List<String> lst = ['MODIFY', 'DONE'];
  int selectedIndex = 0;
  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // _scrollToEnd() async {
  //   if (_needsScroll) {
  //     _needsScroll = false;
  //     _scrollController.animateTo(_scrollController.position.maxScrollExtent,
  //         duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  //   }
  // }
  var dd;
  Widget _senderbuttton(BuildContext context) {
    return Container(
      // color: primarylightcolor,
      margin: EdgeInsets.all(15.0),
      height: 61,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35.0),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 3), blurRadius: 5, color: Colors.grey)
                ],
              ),
              child: Row(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(right: 20)),
                  Expanded(
                    child: TextFormField(
                      controller: message,
                      decoration: InputDecoration(
                          hintText: "Type Something...",
                          border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 15),
          Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.videocam_rounded),
                  onPressed: () async {
                    roomId = await signaling.createRoom(_remoteRenderer);
                    // textEditingController.text = "start" + roomId;
                    //  _sendmessage();
                    setState(() {
                      confirmVideo = 1;
                      textEditingController.text = "start" + roomId;
                      dd = "start" + roomId;
                      message.text = dd;
                    });
                    _sendmessage();
                    print(dd);
                    // if (message.text != dd) {
                    //   _sendmessage();
                    //   message.clear();
                    // } else {
                    //   return;
                    // }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VideoPage(
                                  localvideo: _localRenderer,
                                  remotevideo: _remoteRenderer,
                                )));
                    // _getTokenCred(context);
                    // if (message.text != "") {
                    //   message.clear();
                    // } else {
                    //   return;
                    // }
                  }),
              Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration:
                      BoxDecoration(color: buttonColor, shape: BoxShape.circle),
                  child: IconButton(
                      icon: Icon(
                        Icons.send,
                        color: buttonTextColor,
                      ),
                      onPressed: () {
                        if (message.text != "") {
                          _sendmessage();
                          message.clear();
                        } else {
                          return;
                        }
                      }))
            ],
          )
        ],
      ),
    );
  }

  // void _showDialog(BuildContext context) {
  //   // flutter defined function
  //   //
  //   setState(() {
  //     openDialog=true;
  //   });
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       // return object of type Dialog
  //       return AlertDialog(

  //         content: Text(
  //             'Click on Join to start meeting Now !!'),
  //         actions: [
  //           FlatButton(
  //             textColor: Color(0xFF6200EE),
  //             onPressed: () {

  //               setState(() {
  //                 openDialog=false;
  //               });
  //               _getTokenCred(context);
  //                     //  Navigator.of(context).push(
  //                     //     MaterialPageRoute(
  //                     //       builder: (context) {
  //                     //         return ZoomWebMeeting(url:_joinUrl ,);
  //                     //       },
  //                     //     ),
  //                     //   );
  //             },
  //             child: Text('JOIN'),
  //           ),
  //           FlatButton(
  //             textColor: Color(0xFF6200EE),
  //             onPressed: () {
  //               setState(() {
  //                 openDialog=false;
  //                 message.text="";
  //               });

  //               Navigator.of(context).pop();
  //             },
  //             child: Text('CANCEL'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget chatdata(BuildContext context) {
    return Container(
      color: greyContainer,
      height: (MediaQuery.of(context).size.height - 180),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: SingleChildScrollView(
        child: ListView.builder(
            itemCount: messageslist == null ? 0 : messageslist.length,
            shrinkWrap: true,
            reverse: true,
            physics: NeverScrollableScrollPhysics(),
            // ignore: missing_return
            itemBuilder: (BuildContext context, int index) {
              String messagefrom = messageslist[index]['messagelist'];
              var _replaceMeeting = messagefrom
                  .replaceAll(":", "&")
                  .replaceAll("?", "&")
                  .replaceAll("=", "&");
              var _getMeetingCred = _replaceMeeting.split("&");
              var _replace = messagefrom
                  .replaceAll("/", "&")
                  .replaceAll("?", "&")
                  .replaceAll("#", "&");
              var _splittext = _replace.split("&");
              if (_localid == messageslist[index]['from_id']) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 7,
                    ),
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * .6),
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                      ),
                      child:
                          // message.text.startsWith("start")
                          // dd.startsWith("start")
                          _getMeetingCred[0].toString().startsWith("start"
                                  //"**meeting"
                                  )
                              ? IconButton(
                                  tooltip: "zoom meeting",
                                  icon: Icon(
                                    Icons.videocam,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    // setState(() {
                                    //   message.text=_getMeetingCred[1].toString();
                                    // });
                                    // Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //     builder: (context) {
                                    //       return MeetingWidget(
                                    //           displayname: "kamal",
                                    //           meetingId:
                                    //               _getMeetingCred[1].toString(),
                                    //           meetingPassword:
                                    //               _getMeetingCred[3].toString());
                                    //     },
                                    //   ),
                                    // );
                                  })
                              : Text(
                                  messageslist[index]['messagelist'],
                                  // fetchmeassagedata[index]['message_summary'],messagelist
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .apply(
                                        color: Colors.white,
                                      ),
                                ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                  ],
                );
              } else if (_localid != messageslist[index]['from_id']
                  //   fetchmeassagedata[index]['from_user_id'].toString()
                  ) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * .6),
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                      ),
                      child: Text(
                        messageslist[index]['messagelist'],
                        //   fetchmeassagedata[index]['message_summary'],

                        style: Theme.of(context).textTheme.bodyText2.apply(
                              color: Colors.black87,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 6, left: 0, right: 0, bottom: 1),
        // color: primarydarkcolor,
        child: new Container(
            decoration: new BoxDecoration(
                color: greyContainer,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(40.0),
                  topRight: const Radius.circular(40.0),
                  bottomLeft: const Radius.circular(1.0),
                  bottomRight: const Radius.circular(1.0),
                )),
            child: Column(
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
                                SizedBox(
                                  width: 100,
                                ),
                                Text(
                                  widget.doctorname,
                                  style: TextStyle(
                                      color: buttonTextColor, fontSize: 19),
                                ),
                                SizedBox(
                                  width: 100,
                                ),
                              ]),
                        ),
                        chatdata(context),
                        _senderbuttton(context)
                      ]),
                ])),
      ),
    ));
  }
}
