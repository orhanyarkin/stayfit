import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:nutrition_project/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireStore {
  static final firestoreInstance = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  static late String dateTime;
  late String hourTime;
  static String? userID;
  static int carbs = 0;
  static int proteins = 0;
  static int fats = 0;
  static int totalCal = 0;

  static int carbs1 = 0;
  static int proteins1 = 0;
  static int fats1 = 0;
  static int totalCal1 = 0;

  static int carbs2 = 0;
  static int proteins2 = 0;
  static int fats2 = 0;
  static int totalCal2 = 0;

  static int carbs3 = 0;
  static int proteins3 = 0;
  static int fats3 = 0;
  static int totalCal3 = 0;

  static int carbs4 = 0;
  static int proteins4 = 0;
  static int fats4 = 0;
  static int totalCal4 = 0;

  static int carbs5 = 0;
  static int proteins5 = 0;
  static int fats5 = 0;
  static int totalCal5 = 0;

  static int carbs6 = 0;
  static int proteins6 = 0;
  static int fats6 = 0;
  static int totalCal6 = 0;

  FireStore(String dates) {
    dateTime = DateTime.now().toString();
    setUserId();
    //getDocs(dates);
  }

  static Future<void> getDocs(String dates) async {
    await setUserId();
    QuerySnapshot querySnapshot = await firestoreInstance
        .collection("users/$userID/food/$dates/day")
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      carbs = a.get("carbs");
      proteins = a.get("proteins");
      fats = a.get("fats");
      totalCal = a.get("totalCal");
    }
  }

  static Future<void> getDocs1(String dates) async {
    await setUserId();
    QuerySnapshot querySnapshot = await firestoreInstance
        .collection("users/$userID/food/$dates/day")
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      carbs1 = a.get("carbs");
      proteins1 = a.get("proteins");
      fats1 = a.get("fats");
      totalCal1 = a.get("totalCal");
    }
  }

  static Future<void> getDocs2(String dates) async {
    await setUserId();
    QuerySnapshot querySnapshot = await firestoreInstance
        .collection("users/$userID/food/$dates/day")
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      carbs2 = a.get("carbs");
      proteins2 = a.get("proteins");
      fats2 = a.get("fats");
      totalCal2 = a.get("totalCal");
    }
  }

  static Future<void> getDocs3(String dates) async {
    await setUserId();
    QuerySnapshot querySnapshot = await firestoreInstance
        .collection("users/$userID/food/$dates/day")
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      carbs3 = a.get("carbs");
      proteins3 = a.get("proteins");
      fats3 = a.get("fats");
      totalCal3 = a.get("totalCal");
    }
  }

  static Future<void> getDocs4(String dates) async {
    await setUserId();
    QuerySnapshot querySnapshot = await firestoreInstance
        .collection("users/$userID/food/$dates/day")
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      carbs4 = a.get("carbs");
      proteins4 = a.get("proteins");
      fats4 = a.get("fats");
      totalCal4 = a.get("totalCal");
    }
  }

  static Future<void> getDocs5(String dates) async {
    await setUserId();
    QuerySnapshot querySnapshot = await firestoreInstance
        .collection("users/$userID/food/$dates/day")
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      carbs5 = a.get("carbs");
      proteins5 = a.get("proteins");
      fats5 = a.get("fats");
      totalCal5 = a.get("totalCal");
    }
  }

  static Future<void> getDocs6(String dates) async {
    await setUserId();
    QuerySnapshot querySnapshot = await firestoreInstance
        .collection("users/$userID/food/$dates/day")
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      carbs6 = a.get("carbs");
      proteins6 = a.get("proteins");
      fats6 = a.get("fats");
      totalCal6 = a.get("totalCal");
    }
  }

  static Future setUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userID = prefs.getString('UID');
  }

  static date() {
    var now = DateTime.now();
    var formatter = DateFormat('dd.MM.yyyy');
    String formattedDate = formatter.format(now);
    dateTime = formattedDate;
  }

  Future<void> saveDaily(
    EndDayResults endDay,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userID = prefs.getString('UID');

    date();
    final firestoreInstance = FirebaseFirestore.instance;
    firestoreInstance
        .collection("users/$userID/food/$dateTime/day")
        .add({
          "carbs": endDay.carb,
          "proteins": endDay.protein,
          "fats": endDay.fat,
          "totalCal": endDay.calorie,
        })
        .then((_) {})
        .catchError((_) {});
  }
}
