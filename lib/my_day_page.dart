import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nutrition_project/firebase_helper_custom.dart';
import 'package:nutrition_project/myday_helper.dart';
import 'package:nutrition_project/search_food.dart';
import 'package:nutrition_project/settings_page.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'history_page.dart';
import 'constants.dart';

import 'main.dart';

String placeHolderImageURL =
    "https://www.ipcc.ch/site/assets/uploads/sites/3/2019/10/img-placeholder.png";
enum Meal { breakfast, lunch, dinner }

var dailyCalorieAim = 3000;
var dailyCalorieConsumed = 0;

var dailyConsumedProtein = 80;
var dailyConsumedCarb = 60;
var dailyConsumedFat = 90;

var dailyProteinLimit = 120;
var dailyCarbLimit = 120;
var dailyFatLimit = 120;

bool secureMode = false;

var overConsumedColorGradient = [Colors.red, Colors.redAccent];
var normalConsumedColorGradient = [Colors.green, Colors.teal];
Color backgroundColor = Colors.black12;
var ccActiveCardColour = const Color(0xFF323244);
var ccInactiveCardColour = const Color(0xFF22263A);
var ccBottomContainerColour = const Color(0xFFEB1555);
TextStyle constCCFoodValueTextStyle = const TextStyle(
    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20);

TextStyle constCCMealTitleTextStyle = const TextStyle(
    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15);

class MyDay extends StatefulWidget {
  const MyDay({Key? key}) : super(key: key);

  @override
  State<MyDay> createState() => _MyDayState();
}

class _MyDayState extends State<MyDay> with WidgetsBindingObserver {
  late EndDayResults endDayResults;

  late MealCard breakfast;
  late MealCard lunch;
  late MealCard dinner;

  void setData() {
    List<Food> breakfastFoods = [];
    int breakfastTotalCalorie = 0;
    int breakfastTotalProtein = 0;
    int breakfastTotalCarb = 0;
    int breakfastTotalFat = 0;
    for (FoodData foodData in MyDayHelper.breakfast.foods) {
      breakfastFoods.add(Food(
          calorie: foodData.calorie,
          protein: foodData.protein,
          carb: foodData.carb,
          fat: foodData.fat,
          imageURL: foodData.imageURL));
      breakfastTotalCalorie += foodData.calorie;
      breakfastTotalProtein += foodData.protein;
      breakfastTotalCarb += foodData.carb;
      breakfastTotalFat += foodData.fat;
    }
    breakfast = MealCard(
        foods: breakfastFoods,
        title: 'Breakfast',
        totalCal: breakfastTotalCalorie,
        totalPro: breakfastTotalProtein,
        totalCarb: breakfastTotalCarb,
        totalFat: breakfastTotalFat);
    List<Food> lunchFoods = [];
    int lunchTotalCalorie = 0;
    int lunchTotalProtein = 0;
    int lunchTotalCarb = 0;
    int lunchTotalFat = 0;
    for (FoodData foodData in MyDayHelper.lunch.foods) {
      lunchFoods.add(Food(
          calorie: foodData.calorie,
          protein: foodData.protein,
          carb: foodData.carb,
          fat: foodData.fat,
          imageURL: foodData.imageURL));
      lunchTotalCalorie += foodData.calorie;
      lunchTotalProtein += foodData.protein;
      lunchTotalCarb += foodData.carb;
      lunchTotalFat += foodData.fat;
    }
    lunch = MealCard(
        foods: lunchFoods,
        title: 'Lunch',
        totalCal: lunchTotalCalorie,
        totalPro: lunchTotalProtein,
        totalCarb: lunchTotalCarb,
        totalFat: lunchTotalFat);
    List<Food> dinnerFoods = [];
    int dinnerTotalCalorie = 0;
    int dinnerTotalProtein = 0;
    int dinnerTotalCarb = 0;
    int dinnerTotalFat = 0;
    for (FoodData foodData in MyDayHelper.dinner.foods) {
      dinnerFoods.add(Food(
          calorie: foodData.calorie,
          protein: foodData.protein,
          carb: foodData.carb,
          fat: foodData.fat,
          imageURL: foodData.imageURL));
      dinnerTotalCalorie += foodData.calorie;
      dinnerTotalProtein += foodData.protein;
      dinnerTotalCarb += foodData.carb;
      dinnerTotalFat += foodData.fat;
    }
    dinner = MealCard(
        foods: dinnerFoods,
        title: 'Dinner',
        totalCal: dinnerTotalCalorie,
        totalPro: dinnerTotalProtein,
        totalCarb: dinnerTotalCarb,
        totalFat: dinnerTotalFat);
    dailyCalorieConsumed =
        breakfastTotalCalorie + lunchTotalCalorie + dinnerTotalCalorie;
    dailyConsumedProtein =
        breakfastTotalProtein + lunchTotalProtein + dinnerTotalProtein;
    dailyConsumedCarb = breakfastTotalCarb + lunchTotalCarb + dinnerTotalCarb;
    dailyConsumedFat = breakfastTotalFat + lunchTotalFat + dinnerTotalFat;
  }

  void setCalorieProgress(int aim, int consumed) {
    dailyCalorieAim = aim;
    dailyCalorieConsumed = consumed;
  }

  void addCalorieToProgress(int amount) {
    dailyCalorieConsumed += amount;
  }

  final firestoreInstance = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  late FlutterLocalNotificationsPlugin fltrNotification;
  bool hasInternet = true;

  Future<void> internetStatus() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasInternet = true;
      }
    } on SocketException catch (_) {
      hasInternet = false;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    internetStatus();
    super.initState();
    FirebaseFirestore.instance.collection("users").doc(user!.uid).get().then(
      (value) {
        loggedInUser = UserModel.fromMap(value.data());
        setState(() {});
      },
    );
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);

    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;
  }

  @override
  Widget build(BuildContext context) {
    setData();
    return Scaffold(
      backgroundColor: ccInactiveCardColour,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.save),
          onPressed: () async {
            await internetStatus();
            if (hasInternet == true) {
              flutterLocalNotificationsPlugin.show(
                0,
                "Stay Fit",
                "Your daily consumption has been saved",
                NotificationDetails(
                  android: AndroidNotificationDetails(channel.id, channel.name,
                      channelDescription: channel.description,
                      importance: Importance.high,
                      color: Colors.blue,
                      playSound: true,
                      styleInformation: const BigPictureStyleInformation(
                        DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
                        largeIcon: DrawableResourceAndroidBitmap(
                            "@mipmap/ic_launcher"),
                        htmlFormatContent: true,
                        htmlFormatContentTitle: true,
                      ),
                      icon: '@mipmap/ic_launcher'),
                ),
              );
            } else {
              flutterLocalNotificationsPlugin.show(
                1,
                "Stay Fit",
                "Couldn't save your data, No internet connection",
                NotificationDetails(
                  android: AndroidNotificationDetails(channel.id, channel.name,
                      channelDescription: channel.description,
                      importance: Importance.high,
                      color: Colors.blue,
                      playSound: true,
                      styleInformation: const BigPictureStyleInformation(
                        DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
                        largeIcon: DrawableResourceAndroidBitmap(
                            "@mipmap/ic_launcher"),
                        htmlFormatContent: true,
                        htmlFormatContentTitle: true,
                      ),
                      icon: '@mipmap/ic_launcher'),
                ),
              );
            }
            endDayResults = EndDayResults(
                calorie: dailyCalorieConsumed,
                protein: dailyConsumedProtein,
                carb: dailyConsumedCarb,
                fat: dailyConsumedFat);
            FireStore.userID = loggedInUser.uid;
            FireStore fireStore = FireStore("15.05.2022");
            fireStore.saveDaily(endDayResults);
          },
        ),
        backgroundColor: ccInactiveCardColour,
        title: const Text("My Day"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
                flex: 18,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: ccActiveCardColour,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 8),
                              color: ccActiveCardColour,
                              child: const DailyConsumptionProgress(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: SizedBox(
                                              width: 70,
                                              height: 20,
                                              child: Text(
                                                "Protein",
                                                style: constCCFoodValueTextStyle
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.normal),
                                              )),
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: 150,
                                          child: FAProgressBar(
                                            progressColor: Colors.green,
                                            backgroundColor: Colors.blueGrey,
                                            size: 8,
                                            currentValue:
                                                dailyConsumedProtein.toDouble(),
                                            maxValue:
                                                dailyProteinLimit.toDouble(),
                                            displayText: 'gr',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: SizedBox(
                                              width: 70,
                                              height: 20,
                                              child: Text(
                                                "Carb",
                                                style: constCCFoodValueTextStyle
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.normal),
                                              )),
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: 150,
                                          child: FAProgressBar(
                                            progressColor: Colors.green,
                                            backgroundColor: Colors.blueGrey,
                                            size: 8,
                                            currentValue:
                                                dailyConsumedCarb.toDouble(),
                                            maxValue: dailyCarbLimit.toDouble(),
                                            displayText: 'gr',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: SizedBox(
                                              width: 70,
                                              height: 20,
                                              child: Text(
                                                "Fat",
                                                style: constCCFoodValueTextStyle
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.normal),
                                              )),
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: 150,
                                          child: FAProgressBar(
                                            progressColor: Colors.green,
                                            backgroundColor: Colors.blueGrey,
                                            size: 8,
                                            currentValue:
                                                dailyConsumedFat.toDouble(),
                                            maxValue: dailyFatLimit.toDouble(),
                                            displayText: 'gr',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    breakfast,
                    const SizedBox(
                      height: 5,
                    ),
                    lunch,
                    const SizedBox(
                      height: 5,
                    ),
                    dinner,
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Hero(
                tag: "bottom",
                child: ConvexAppBar.badge(
                  const {},
                  initialActiveIndex: 1,
                  gradient: LinearGradient(colors: navigationBarColors),
                  badgeColor: Colors.purple,
                  items: const [
                    TabItem(
                      icon: Icon(
                        Icons.history,
                        color: Colors.grey,
                        size: 26,
                      ),
                    ),
                    TabItem(
                      icon: Icons.home,
                    ),
                    TabItem(
                      icon: Icons.search,
                    ),
                    TabItem(
                      icon: Icons.person,
                    ),
                  ],
                  curveSize: 0,
                  onTap: (int i) async {
                    switch (i) {
                      case 0:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HistoryPage()),
                        );
                        break;
                      case 1:
                        break;
                      case 2:
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyFood()),
                        );
                        break;
                      case 3:
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsPage()),
                        );
                        break;
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DailyConsumptionProgress extends StatefulWidget {
  const DailyConsumptionProgress();

  @override
  State<DailyConsumptionProgress> createState() =>
      _DailyConsumptionProgressState();
}

class _DailyConsumptionProgressState extends State<DailyConsumptionProgress> {
  String percentageModifier(double value) {
    return "/$dailyCalorieAim";
  }

  @override
  Widget build(BuildContext context) {
    return SleekCircularSlider(
      initialValue: (dailyCalorieConsumed / dailyCalorieAim) * 100,
      appearance: CircularSliderAppearance(
          size: 130,
          customWidths: CustomSliderWidths(handlerSize: 0),
          infoProperties: InfoProperties(
              topLabelText: "$dailyCalorieConsumed kcal",
              modifier: percentageModifier,
              mainLabelStyle:
                  const TextStyle(color: Colors.white, fontSize: 17),
              topLabelStyle:
                  const TextStyle(color: Colors.white, fontSize: 20)),
          angleRange: 340,
          customColors: CustomSliderColors(
              trackColor: Colors.cyan,
              progressBarColors: dailyCalorieConsumed > (dailyCalorieAim * 0.8)
                  ? overConsumedColorGradient
                  : normalConsumedColorGradient)),
    );
  }
}

class MealCard extends StatelessWidget {
  late List<Food> foods;
  late String title;
  int totalCal = 0;
  int totalPro = 0;
  int totalCarb = 0;
  int totalFat = 0;

  MealCard(
      {Key? key,
      required this.foods,
      required this.title,
      required this.totalCal,
      required this.totalPro,
      required this.totalCarb,
      required this.totalFat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            decoration: BoxDecoration(
              color: ccActiveCardColour,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: constCCMealTitleTextStyle,
                  ),
                  flex: 1,
                ),
                Flexible(
                  child: Row(
                    children: [
                      Flexible(
                        child: Consumer(
                          builder:
                              (BuildContext context, value, Widget? child) {
                            return ListView.builder(
                              itemCount: foods.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  children: [foods[index]],
                                );
                              },
                            );
                          },
                        ),
                        flex: 7,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        //Data here
                        flex: 4,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 10,
                                child: Row(
                                  children: [
                                    SizedBox(
                                        width: 25,
                                        child: Text(
                                          "Cal",
                                          style: constCCFoodValueTextStyle
                                              .copyWith(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15),
                                        )),
                                    SizedBox(
                                      height: 20,
                                      width: 90,
                                      child: FAProgressBar(
                                        progressColor: Colors.green,
                                        backgroundColor: Colors.blueGrey,
                                        size: 8,
                                        currentValue: totalCal.toDouble(),
                                        maxValue: 5000,
                                        displayText: 'kcal',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(flex: 1, child: Container()),
                              Flexible(
                                flex: 10,
                                child: Row(
                                  children: [
                                    SizedBox(
                                        width: 25,
                                        child: Text(
                                          "Pro",
                                          style: constCCFoodValueTextStyle
                                              .copyWith(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15),
                                        )),
                                    SizedBox(
                                      height: 20,
                                      width: 90,
                                      child: FAProgressBar(
                                        progressColor: Colors.green,
                                        backgroundColor: Colors.blueGrey,
                                        size: 8,
                                        currentValue: totalPro.toDouble(),
                                        maxValue: 100,
                                        displayText: 'gr',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(flex: 1, child: Container()),
                              Flexible(
                                flex: 10,
                                child: Row(
                                  children: [
                                    SizedBox(
                                        width: 25,
                                        child: Text(
                                          "Car",
                                          style: constCCFoodValueTextStyle
                                              .copyWith(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15),
                                        )),
                                    SizedBox(
                                      height: 20,
                                      width: 90,
                                      child: FAProgressBar(
                                        progressColor: Colors.green,
                                        backgroundColor: Colors.blueGrey,
                                        size: 8,
                                        currentValue: totalCarb.toDouble(),
                                        maxValue: 100,
                                        displayText: 'gr',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(flex: 1, child: Container()),
                              Flexible(
                                flex: 10,
                                child: Row(
                                  children: [
                                    SizedBox(
                                        width: 25,
                                        child: Text(
                                          "Fat",
                                          style: constCCFoodValueTextStyle
                                              .copyWith(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15),
                                        )),
                                    SizedBox(
                                      height: 20,
                                      width: 90,
                                      child: FAProgressBar(
                                        progressColor: Colors.green,
                                        backgroundColor: Colors.blueGrey,
                                        size: 8,
                                        currentValue: totalFat.toDouble(),
                                        displayText: 'gr',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  flex: 7,
                )
              ],
            ),
          ),
        ));
  }
}

class Food extends StatelessWidget {
  late int calorie;
  late int protein;
  late int carb;
  late int fat;
  late String imageURL;

  Food(
      {Key? key,
      required this.calorie,
      required this.protein,
      required this.carb,
      required this.fat,
      required this.imageURL})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          width: 150,
          decoration: BoxDecoration(
              color: Colors.green, borderRadius: BorderRadius.circular(15.0)),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                imageURL,
                height: 85,
                fit: BoxFit.fill,
              )),
        ));
  }
}
