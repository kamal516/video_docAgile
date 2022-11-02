import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class ZoomWebMeeting extends StatelessWidget {
String _weburl;
  ZoomWebMeeting({Key key,url}): super(key: key){
     this._weburl=url;
  } 
  @override
  Widget build(BuildContext context) {
    return Container(
      child:     WebView(
          initialUrl:
              _weburl,
          javascriptMode: JavascriptMode.unrestricted,
        ),
    );
  }
}