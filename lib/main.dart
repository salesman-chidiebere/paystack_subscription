import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PayStack Subscription',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PayStack Subscription Payment"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Builder(builder: (BuildContext context){
          return WebView(
            initialUrl: 'https://paystack.com/pay/subcri',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController){
              _controller.complete(webViewController);
            },
            onProgress: (int progress){
              print("progress $progress%");
            },
            javascriptChannels: <JavascriptChannel>{
              _toasterJavascriptChannel(context)
            },
          );
        },),
      ),
    );

  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context){
    return JavascriptChannel(
      name: 'Toaster',
      onMessageReceived: (JavascriptMessage message){
        Scaffold.of(context).showSnackBar(
          SnackBar(content:Text(message.message)),
        );
      }
    );
  }

}
