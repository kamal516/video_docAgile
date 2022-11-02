import 'package:doctoragileapp/webrtc_videoCall/signaling.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoPage extends StatefulWidget {
  RTCVideoRenderer localvideo;
  RTCVideoRenderer remotevideo;
  VideoPage({this.localvideo, this.remotevideo});
  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  Signaling signaling = Signaling();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("data"),
      // ),
      body: Column(
        children: [
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ignore: unrelated_type_equality_checks
                        widget.remotevideo.delegate.videoHeight == 0
                            ? Expanded(
                                flex: 7,
                                child: RTCVideoView(widget.localvideo,
                                    mirror: true))
                            : Expanded(
                                child: Column(
                                children: [
                                  Expanded(
                                      flex: 7,
                                      child: RTCVideoView(widget.localvideo,
                                          mirror: true)),
                                  Expanded(
                                      flex: 3,
                                      child: RTCVideoView(widget.remotevideo)),
                                ],
                              ))
                      ]))),
          Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: FloatingActionButton(
                  onPressed: () async {
                    signaling.hangUp(widget.localvideo);
                  },
                  child: Icon(
                    Icons.call_end,
                    color: Colors.white,
                  )))
          // Expanded(
          //     child: FloatingActionButton(
          //         onPressed: () async {
          //           signaling.hangUp(widget.localvideo);
          //         },
          //         child: Icon(
          //           Icons.call_end,
          //           color: Colors.white,
          //         ))),
        ],
      ),
    );
  }
}
