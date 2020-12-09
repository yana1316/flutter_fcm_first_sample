import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter FCM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter FCM First Sample'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _token = "Waiting...";
  String _message = "Waiting...";

  @override
  void initState() {
    super.initState();

    /// iOS用 PUSH通知の許可確認
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    /// FCM token の取得
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _token = token;
      });
      print("token: $_token");
    });

    /// メッセージ受信時の処理
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        setState(() {
          _message = "onMessage: $message";
        });
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        setState(() {
          _message = "onLaunch: $message";
        });
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        setState(() {
          _message = "onResume: $message";
        });
        print("onResume: $message");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Your token'),
            Text(_token),
            Divider(),
            Text('Message'),
            Text(_message),
          ],
        ),
      ),
    );
  }
}
