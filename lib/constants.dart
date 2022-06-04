import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'my_day_page.dart';
import 'package:flutter/material.dart';

var navigationBarColors = [ccActiveCardColour, ccInactiveCardColour];

class UserCustom {
  static String USERID = "00000";

  static void setUserID(String uid) {
    USERID = uid;
  }
}

class FoodData {
  late int calorie;
  late int protein;
  late int carb;
  late int fat;
  late String imageURL;

  FoodData(
      {required this.calorie,
      required this.protein,
      required this.carb,
      required this.fat,
      required this.imageURL});
}

TextStyle ccNormalWhite = TextStyle(color: Colors.white, fontSize: 11);

class UserModel {
  String? uid;
  String? email;
  String? firstName;

  UserModel({this.uid, this.email, this.firstName});

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
    };
  }
}

class EndDayResults {
  late int calorie;
  late int protein;
  late int carb;
  late int fat;

  EndDayResults(
      {required this.calorie,
      required this.protein,
      required this.carb,
      required this.fat});
}

class Constants {
  static var alarmManagerQuotes = [
    "Winning and losing isn't everything. Sometimes, the journey is just as important as the outcome.",
    "The hard days are what make you stronger.",
    "Start where you are. Use what you have. Do what you can.",
    "It's never too late to change old habits.",
    "It’s okay to struggle, but it’s not okay to give up on yourself or your dreams.",
    "We all have dreams. But in order to make dreams come into reality, it takes an awful lot of determination, dedication, self-discipline, and effort.",
    "It's not about perfect. It's about effort. And when you bring that effort every single day, that's where transformation happens.",
    "Life changes very quickly, in a very positive way, if you let it.",
    "There may be tough times, but the difficulties which you face will make you more determined",
    "Life is about challenges and how we face up to them."
  ];

  static void send_motivational_notification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int quoteIndex = (prefs.getInt('quote index') ?? 0);

    final DateTime now = DateTime.now();
    final int isolateId = Isolate.current.hashCode;
    print(
        "[$now] ${alarmManagerQuotes[quoteIndex]} isolate=${isolateId} function='$send_motivational_notification'   quote index = $quoteIndex");

    flutterLocalNotificationsPlugin.show(
      1,
      "Stay Fit",
      "${alarmManagerQuotes[quoteIndex]}",
      NotificationDetails(
        android: AndroidNotificationDetails(channel.id, channel.name,
            channelDescription: channel.description,
            importance: Importance.high,
            playSound: true,
            color: Color(0xFF323244),
            styleInformation: const BigTextStyleInformation(""),
            icon: '@mipmap/ic_launcher'),
      ),
    );

    await prefs.setInt('quote index', quoteIndex + 1);
    if (quoteIndex + 1 > alarmManagerQuotes.length - 1) {
      await prefs.setInt('quote index', 0);
    }
  }
}
