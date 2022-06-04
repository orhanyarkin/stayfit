import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:local_auth/local_auth.dart';
import 'package:nutrition_project/search_food.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'history_page.dart';
import 'main.dart';
import 'my_day_page.dart';

String userIDD = "asd";

class SettingsPage extends StatefulWidget {
  static String? userWidgetID;

  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with WidgetsBindingObserver {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  bool? _jailbroken;
  bool? _developerMode;

  Future<void> checkRooted() async {
    bool jailbroken;
    bool developerMode;

    try {
      jailbroken = await FlutterJailbreakDetection.jailbroken;
      developerMode = await FlutterJailbreakDetection.developerMode;
    } on PlatformException {
      jailbroken = true;
      developerMode = true;
    }

    if (!mounted) return;

    setState(() {
      _jailbroken = jailbroken;
      _developerMode = developerMode;
    });
  }

  Widget buildButton({
    required String text,
    required IconData icon,
    required VoidCallback onClicked,
  }) =>
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
        ),
        icon: Icon(icon, size: 26),
        label: Text(
          text,
          style: const TextStyle(fontSize: 20),
        ),
        onPressed: onClicked,
      );

  Widget buildText(String text, bool checked) => Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            checked
                ? const Icon(Icons.check, color: Colors.green, size: 24)
                : const Icon(Icons.close, color: Colors.red, size: 24),
            const SizedBox(width: 12),
            Text(text, style: const TextStyle(fontSize: 24)),
          ],
        ),
      );
  Future<void> initPlatformState() async {
    bool jailbroken;
    bool developerMode;
    try {
      jailbroken = await FlutterJailbreakDetection.jailbroken;
      developerMode = await FlutterJailbreakDetection.developerMode;
    } on PlatformException {
      jailbroken = true;
      developerMode = true;
    }

    if (!mounted) return;

    setState(() {
      _jailbroken = jailbroken;
      _developerMode = developerMode;
    });
  }

  @override
  void initState() {
    initPlatformState();
    checkRooted();
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
    FirebaseFirestore.instance.collection("users").doc(user!.uid).get().then(
      (value) {
        loggedInUser = UserModel.fromMap(value.data());
        setState(() {
          setUser();
        });
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

  void setUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.setString('UID', loggedInUser.uid!);
    });
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => MainPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ccInactiveCardColour,
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SettingsList(sections: [
                SettingsSection(
                  titlePadding: const EdgeInsets.all(20),
                  tiles: [
                    SettingsTile(
                      title: 'Personal Information',
                      subtitle: "Username: ${loggedInUser.firstName}"
                          "\nE-mail: ${loggedInUser.email}"
                          "\nUser ID: ${loggedInUser.uid}",
                      leading: const Icon(Icons.person),
                      onPressed: (BuildContext context) {},
                    ),
                    SettingsTile(
                      title: 'Daily Aim',
                      subtitle:
                          'Current aim: 3000 kcal \n 80 g protein: 250 g  carbohydrate \n 60 g fat',
                      leading: const Icon(Icons.military_tech),
                      onPressed: (BuildContext context) {},
                    ),
                    SettingsTile(
                      title: 'Log Out',
                      leading: const Icon(Icons.logout),
                      onPressed: (BuildContext context) async {
                        logout(context);
                      },
                    ),
                  ],
                ),
              ]),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ConvexAppBar.badge(
                const {},
                initialActiveIndex: 3,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyDay()),
                      );
                      break;
                    case 2:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyFood()),
                      );
                      break;
                    case 3:
                      if (kDebugMode) {
                        print("3");
                      }
                      break;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
