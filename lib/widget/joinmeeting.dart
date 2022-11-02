import 'dart:async';
import 'dart:io';

import 'package:flutter_zoom_plugin/zoom_view.dart';
import 'package:flutter_zoom_plugin/zoom_options.dart';

import 'package:flutter/material.dart';

class StartMeetingWidget extends StatelessWidget {
  ZoomOptions zoomOptions;
  ZoomMeetingOptions meetingOptions;

  Timer timer;

  StartMeetingWidget({Key key, displayname, meetingId, zoomtoken, zaktoken})
      : super(key: key) {
    this.zoomOptions = new ZoomOptions(
      domain: "zoom.us",
      appKey: "M3Nk5dW9BTLsVGDp792rlFoDOe9eusKg3OOW",
      appSecret: "MDz0Wzf2QJrfzNXTRsiU9b03i8eEkmRaYpQi",
      //  jwtToken: zaktoken
    );
    this.meetingOptions = new ZoomMeetingOptions(
        userId: displayname,
        displayName: displayname,
        meetingId: meetingId.toString(),
        zoomAccessToken: zaktoken.toString(),
        zoomToken: zoomtoken.toString(),
        disableDialIn: "true",
        disableDrive: "true",
        disableInvite: "true",
        disableShare: "true",
        noAudio: "false",
        noDisconnectAudio: "false");
  }

  bool _isMeetingEnded(String status) {
    var result = false;
    if (Platform.isAndroid)
      result = status == "MEETING_STATUS_DISCONNECTING" ||
          status == "MEETING_STATUS_FAILED";
    else
      result = status == "MEETING_STATUS_IDLE";
    return result;
  }

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return ZoomView(onViewCreated: (controller) {
      print("Created the view");

      controller.initZoom(this.zoomOptions).then((results) {
        print("initialised");
        print(results);

        if (results[0] == 0) {
          controller.zoomStatusEvents.listen((status) {
            print("Meeting Status Stream: " + status[0] + " - " + status[1]);
            if (_isMeetingEnded(status[0])) {
              Navigator.pop(context);
              timer?.cancel();
            }
          });

          print("listen on event channel");

          controller
              .startMeeting(this.meetingOptions)
              .then((joinMeetingResult) {
            timer = Timer.periodic(new Duration(seconds: 2), (timer) {
              controller
                  .meetingStatus(this.meetingOptions.meetingId)
                  .then((status) {
                print(
                    "Meeting Status Polling: " + status[0] + " - " + status[1]);
              });
            });
          });
        }
      }).catchError((error) {
        print("Error");
        print(error);
      });
    });
    // Scaffold(
    //   appBar: AppBar(
    //       title: Text('Loading meeting '),
    //   ),
    //   body: Padding(
    //     padding: EdgeInsets.all(16.0),
    //     child: ZoomView(onViewCreated: (controller) {

    //       print("Created the view");

    //       controller.initZoom(this.zoomOptions)
    //           .then((results) {

    //         print("initialised");
    //         print(results);

    //         if(results[0] == 0) {

    //           controller.zoomStatusEvents.listen((status) {
    //             print("Meeting Status Stream: " + status[0] + " - " + status[1]);
    //             if (_isMeetingEnded(status[0])) {
    //               Navigator.pop(context);
    //               timer?.cancel();
    //             }
    //           });

    //           print("listen on event channel");

    //           controller.startMeeting(this.meetingOptions)
    //               .then((joinMeetingResult) {

    //             timer = Timer.periodic(new Duration(seconds: 2), (timer) {
    //               controller.meetingStatus(this.meetingOptions.meetingId)
    //                   .then((status) {
    //                 print("Meeting Status Polling: " + status[0] + " - " + status[1]);
    //               });
    //             });

    //           });
    //         }

    //       }).catchError((error) {
    //         print("Error");
    //         print(error);
    //       });
    //     })
    //   ),
    // );
  }
}
