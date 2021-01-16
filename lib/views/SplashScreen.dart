import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iSalonAgent/main.dart';
import 'dart:async';
// import 'package:laundry/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
// //import 'package:laundry/service/push_notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';

// /// Component UI
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

// /// Component UI
class _SplashScreenState extends State<SplashScreen> {
  final MethodChannel platform =
      MethodChannel('crossingthestreams.io/resourceResolver');
  int _haveStarted;
  var _agentID;
  String _token;
  // final PushNotificationService _pushNotificationService =
  //     locator<PushNotificationService>();

  /// Setting duration in splash screen
  startTime() async {
    return new Timer(Duration(milliseconds: 6000), NavigatorPage);
  }

  /// To navigate layout change
  void NavigatorPage() {
    if (_agentID != null) {
      Navigator.of(context).pushReplacementNamed("HomeScreen");
    } else {
      Navigator.of(context).pushReplacementNamed("LoginScreen");
    }
  }

  Future<int> _getIntFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final startupNumber = prefs.getInt('startUpAppa');
    if (startupNumber == null) {
      return 0;
    } else {
      return startupNumber;
    }
  }

  // Future<void> _resetCounter() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setInt('startUpAppa', 0);
  // }

  Future<void> _incrementStartup() async {
    final prefs = await SharedPreferences.getInstance();
    //int lastStartupNumber = await _getIntFromSharedPref();
    final agentID = prefs.getInt('_id');
    setState(() {
      // _haveStarted = lastStartupNumber;
      _agentID = agentID;
    });
    // int currentStartupNumber = ++lastStartupNumber;
    // await prefs.setInt('startUpAppa', currentStartupNumber);
    await prefs.setString('fcm_client_token', _token);
    startTime();
  }

  // Future handleStartUpLogic() async {
  //   // Register for push notifications
  //   String _token = await _pushNotificationService.initialise();
  //   print('_token $_token');
  // }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Future<void> initialise() async {
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        _showNotification(
            message['notification']['title'], message['notification']['body']);
        // print("onMessage: ${message['notification']['body']}");
        // _showNotification(message['notification']['body']);
        //_showDialog();
        //_showNotification();

        // Navigator.of(context).pushNamedAndRemoveUntil(
        //     'HomeScreen', (Route<dynamic> route) => false);
        //_showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        _showNotification(
            message['notification']['title'], message['notification']['body']);
        // print("onLaunch: $message");
        //_navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        _showNotification(
            message['notification']['title'], message['notification']['body']);
        // print("onResume: $message");
        //_navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _token = token;
      });
      init();
      //storeFCM(token);
    });
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_client_token', _token);
  }

  /// Declare startTime to InitState
  @override
  void initState() {
    super.initState();
    initialise();
    //handleStartUpLogic();
    //startTime();
    _incrementStartup();
    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                // Navigator.of(context, rootNavigator: true).pop();
                // await Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) =>
                //         SecondScreen(receivedNotification.payload),
                //   ),
                // );
              },
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      // await Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => SecondScreen(payload)),
      // );
    });
  }

  Future<void> _showNotification(
      String contentTitle, String contentBody) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, '${contentTitle}', '$contentBody', platformChannelSpecifics,
        payload: 'item x');
  }

//   @override

//   /// Code Create UI Splash Screen
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        /// Set Background image in splash screen layout (Click to open code)
        decoration: BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.center,
            image: AssetImage('assets/images/splash.gif'),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
