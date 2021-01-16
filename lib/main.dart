import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iSalonAgent/views/BottomNavigation.dart';
import 'package:iSalonAgent/views/BottomNavigationBar.dart';
import 'package:iSalonAgent/views/HomePage.dart';
import 'package:iSalonAgent/views/LoginPage.dart';
import 'package:iSalonAgent/views/SplashScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/subjects.dart';
import 'package:flutter/services.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
  // of the `IOSFlutterLocalNotificationsPlugin` class
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  });

  runApp(EasyLocalization(
      path: 'assets/translations',
      supportedLocales: [Locale('en', 'UK'), Locale('ar', 'AE')],
      fallbackLocale: Locale('en', 'UK'),
      child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    /// To set orientation always portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return MaterialApp(
      title: 'ISalon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        backgroundColor: Color(0xff222327),
        primaryColor: Color(0xffceab67),
        fontFamily: 'Montserrat',
        iconTheme: IconThemeData(
          color: Colors.grey, //change your color here
        ),
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Color(0xffceab67)),
          subtitle: TextStyle(fontSize: 16, color: Colors.white),
          subhead: TextStyle(fontSize: 16, color: Colors.white),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Montserrat'),
          display1: TextStyle(
              fontSize: 14.0, fontFamily: 'Montserrat1', color: Colors.white),
          display2: TextStyle(
              fontSize: 14.0, fontFamily: 'Montserrat', color: Colors.black54),
        ),
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: SplashScreen(),
      //home: OrderConfirm(),
      // home: Payment(),

      /// Move splash screen to ChoseLogin Layout
      /// Routes
      routes: <String, WidgetBuilder>{
        // "onBoarding": (BuildContext context) => new OnboardingScreen(),
        "LoginScreen": (BuildContext context) => new LoginPage(),
        "HomeScreen": (BuildContext context) => new bottomNavigationBar(),
        "BookingScreen": (BuildContext context) => new bottomNavigation(),
        // "RegisterScreen": (BuildContext context) => new RegisterScreen(),
      },
    );
  }
}
