import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:nutrition_project/screens/login_page/loginpage.dart';
import 'constants.dart';
import 'my_day_page.dart';
import 'dart:developer' as dev;
import 'package:firebase_messaging/firebase_messaging.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage msg) async {
  await Firebase.initializeApp();
  dev.log("A background message has been received: ${msg.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await AndroidAlarmManager.initialize();

  runApp(const MyApp());
  const int helloAlarmID = 0;

  await AndroidAlarmManager.periodic(const Duration(seconds: 1), helloAlarmID,
      Constants.send_motivational_notification,
      allowWhileIdle: true, exact: true);
  Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Email And Password Login',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ShaderMask(
          shaderCallback: (rect) => const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.center,
            colors: [Colors.black, Colors.transparent],
          ).createShader(rect),
          blendMode: BlendMode.darken,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/main_page.jpeg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
              ),
            ),
          ),
        ),
        StreamBuilder(
          stream: myuser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              Object? user = snapshot.data;

              if (user == null) {
                return Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Column(
                    children: [
                      const Flexible(
                        child: Center(
                          child: Expanded(
                            child: Text(
                              'Welcome to \nStay Fit',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: MaterialButton(
                          elevation: 10,
                          height: 80,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()));
                          },
                          color: Colors.black54,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Text('Get Started',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  )),
                              Icon(Icons.arrow_forward_ios)
                            ],
                          ),
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return MyDay();
              }
            } else {
              return Scaffold(
                body: Center(
                  child: Text("loading"),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Stream<User?> get myuser {
    return FirebaseAuth.instance.authStateChanges().map((User? user) => (user));
  }
}
