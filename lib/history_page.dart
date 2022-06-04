import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_project/search_food.dart';
import 'package:nutrition_project/settings_page.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import '../constants.dart';
import '../my_day_page.dart';
import 'firebase_helper_custom.dart';
import 'settings_page.dart';

var containerColor = const Color(0xFF323244);
var chartColor = const Color(0xFF4CAF50);
const textColor = Color(0xFFFFFCFC);
var aimedCalorie = 800.0;
var aimedCarbs = 250.0;
var aimedProtein = 80.0;
var aimedFat = 60.0;
var total;

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> with WidgetsBindingObserver {
  List<int> firstContainer() {
    var now = DateTime.now();
    String date = (now.day - 0).toString() +
        ".0" +
        (now.month.toString()) +
        "." +
        (now.year.toString());
    FireStore.getDocs(date);
    int carbs = FireStore.carbs;
    int proteins = FireStore.proteins;
    int fats = FireStore.fats;
    int totalCal = FireStore.totalCal;
    List<int> ingredients = [];
    ingredients.add(carbs);
    ingredients.add(proteins);
    ingredients.add(fats);
    ingredients.add(totalCal);
    return ingredients;
  }

  List<int> secondContainer() {
    var now = DateTime.now();
    String date = (now.day - 1).toString() +
        ".0" +
        (now.month.toString()) +
        "." +
        (now.year.toString());
    FireStore.getDocs1(date);
    int carbs = FireStore.carbs1;
    int proteins = FireStore.proteins1;
    int fats = FireStore.fats1;
    int totalCal = FireStore.totalCal1;
    List<int> ingredients = [];
    ingredients.add(carbs);
    ingredients.add(proteins);
    ingredients.add(fats);
    ingredients.add(totalCal);
    return ingredients;
  }

  List<int> thirdContainer() {
    var now = DateTime.now();
    String date = (now.day - 2).toString() +
        ".0" +
        (now.month.toString()) +
        "." +
        (now.year.toString());
    FireStore.getDocs2(date);
    int carbs = FireStore.carbs2;
    int proteins = FireStore.proteins2;
    int fats = FireStore.fats2;
    int totalCal = FireStore.totalCal2;
    List<int> ingredients = [];
    ingredients.add(carbs);
    ingredients.add(proteins);
    ingredients.add(fats);
    ingredients.add(totalCal);
    return ingredients;
  }

  List<int> fourthContainer() {
    var now = DateTime.now();
    String date = (now.day - 3).toString() +
        ".0" +
        (now.month.toString()) +
        "." +
        (now.year.toString());
    FireStore.getDocs3(date);
    int carbs = FireStore.carbs3;
    int proteins = FireStore.proteins3;
    int fats = FireStore.fats3;
    int totalCal = FireStore.totalCal3;
    List<int> ingredients = [];
    ingredients.add(carbs);
    ingredients.add(proteins);
    ingredients.add(fats);
    ingredients.add(totalCal);
    return ingredients;
  }

  List<int> fifthContainer() {
    var now = DateTime.now();
    String date = (now.day - 4).toString() +
        ".0" +
        (now.month.toString()) +
        "." +
        (now.year.toString());
    FireStore.getDocs4(date);
    int carbs = FireStore.carbs4;
    int proteins = FireStore.proteins4;
    int fats = FireStore.fats4;
    int totalCal = FireStore.totalCal4;
    List<int> ingredients = [];
    ingredients.add(carbs);
    ingredients.add(proteins);
    ingredients.add(fats);
    ingredients.add(totalCal);
    return ingredients;
  }

  List<int> sixthContainer() {
    var now = DateTime.now();
    String date = (now.day - 5).toString() +
        ".0" +
        (now.month.toString()) +
        "." +
        (now.year.toString());
    FireStore.getDocs5(date);
    int carbs = FireStore.carbs5;
    int proteins = FireStore.proteins5;
    int fats = FireStore.fats5;
    int totalCal = FireStore.totalCal5;
    List<int> ingredients = [];
    ingredients.add(carbs);
    ingredients.add(proteins);
    ingredients.add(fats);
    ingredients.add(totalCal);
    return ingredients;
  }

  List<int> seventhContainer() {
    var now = DateTime.now();
    String date = (now.day - 6).toString() +
        ".0" +
        (now.month.toString()) +
        "." +
        (now.year.toString());
    FireStore.getDocs6(date);
    int carbs = FireStore.carbs6;
    int proteins = FireStore.proteins6;
    int fats = FireStore.fats6;
    int totalCal = FireStore.totalCal6;
    List<int> ingredients = [];
    ingredients.add(carbs);
    ingredients.add(proteins);
    ingredients.add(fats);
    ingredients.add(totalCal);
    return ingredients;
  }

  void refreshPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => super.widget),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
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
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => super.widget),
                );
              },
              icon: const Icon(
                Icons.refresh,
                size: 28,
              ))
        ],
        automaticallyImplyLeading: false,
        title: const Text("Weekly Consumption Records"),
        centerTitle: true,
        backgroundColor: const Color(0xFF323244),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 10,
            child: ListView(
              itemExtent: 175,
              children: <Widget>[
                PastConsumption(
                    carbs: firstContainer()[0].toDouble(),
                    protein: firstContainer()[1].toDouble(),
                    fat: firstContainer()[2].toDouble(),
                    totalCal: firstContainer()[3].toDouble(),
                    pastIndex: 0),
                PastConsumption(
                    carbs: secondContainer()[0].toDouble(),
                    protein: secondContainer()[1].toDouble(),
                    fat: secondContainer()[2].toDouble(),
                    totalCal: secondContainer()[3].toDouble(),
                    pastIndex: 1),
                PastConsumption(
                    carbs: thirdContainer()[0].toDouble(),
                    protein: thirdContainer()[1].toDouble(),
                    fat: thirdContainer()[2].toDouble(),
                    totalCal: thirdContainer()[3].toDouble(),
                    pastIndex: 2),
                PastConsumption(
                    carbs: fourthContainer()[0].toDouble(),
                    protein: fourthContainer()[1].toDouble(),
                    fat: fourthContainer()[2].toDouble(),
                    totalCal: fourthContainer()[3].toDouble(),
                    pastIndex: 3),
                PastConsumption(
                    carbs: fifthContainer()[0].toDouble(),
                    protein: fifthContainer()[1].toDouble(),
                    fat: fifthContainer()[2].toDouble(),
                    totalCal: fifthContainer()[3].toDouble(),
                    pastIndex: 4),
                PastConsumption(
                    carbs: sixthContainer()[0].toDouble(),
                    protein: sixthContainer()[1].toDouble(),
                    fat: sixthContainer()[2].toDouble(),
                    totalCal: sixthContainer()[3].toDouble(),
                    pastIndex: 5),
                PastConsumption(
                    carbs: seventhContainer()[0].toDouble(),
                    protein: seventhContainer()[1].toDouble(),
                    fat: seventhContainer()[2].toDouble(),
                    totalCal: seventhContainer()[3].toDouble(),
                    pastIndex: 6),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Hero(
              tag: "bottom",
              child: ConvexAppBar.badge(
                const {},
                initialActiveIndex: 0,
                gradient: LinearGradient(colors: navigationBarColors),
                badgeColor: Colors.purple,
                items: const [
                  TabItem(
                    icon: Icon(
                      Icons.history,
                      color: Colors.cyan,
                      size: 35,
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
                      break;
                    case 1:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyDay()),
                      );
                      break;
                    case 2:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyFood()),
                      );
                      break;
                    case 3:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsPage()),
                      );
                      break;
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _RadialProgress extends StatelessWidget {
  final double height, width, progress;
  final double totalCalorie;
  final double totalCal;

  const _RadialProgress(
      {required this.totalCalorie,
      required this.height,
      required this.width,
      required this.progress,
      required this.totalCal});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter:
          _RadialPainter(progress: progress, total: total, totalCal: totalCal),
      child: SizedBox(
        height: height,
        width: width,
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: totalCalorie.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const TextSpan(text: "\n"),
                TextSpan(
                  text: "/" + aimedCalorie.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RadialPainter extends CustomPainter {
  final double progress;
  final double total;
  final double totalCal;

  _RadialPainter(
      {required this.progress, required this.total, required this.totalCal});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 10
      ..color = totalCal >= aimedCalorie ? Colors.redAccent : chartColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double relativeProgress = 360 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2),
      math.radians(-90),
      math.radians(-relativeProgress),
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class PastConsumption extends StatelessWidget {
  const PastConsumption(
      {required this.carbs,
      required this.protein,
      required this.fat,
      required this.pastIndex,
      required this.totalCal});

  final int pastIndex;
  final double carbs;
  final double protein;
  final double fat;
  final double totalCal;

  double getTotal(double carbs, double protein, double fat) {
    total = (carbs * 4 + protein * 4 + fat * 9);
    return totalCal;
  }

  double getProgress(double total) {
    return total / aimedCalorie;
  }

  double ifResult(double amount, double aim) {
    if (amount / aim >= 1) {
      return 1;
    }
    return amount / aim;
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(15),
        ),
        height: 150,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: _RadialProgress(
                  totalCal: totalCal,
                  totalCalorie: getTotal(carbs, protein, fat),
                  height: 100,
                  width: 100,
                  progress: getProgress(getTotal(carbs, protein, fat))),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _IngredientProgress(
                    ingredient: "Protein",
                    progress: ifResult(protein, aimedProtein),
                    progressColor: ifResult(protein, aimedProtein) >= 1
                        ? Colors.redAccent
                        : chartColor,
                    amount: protein,
                    width: 100,
                  ),
                  _IngredientProgress(
                    ingredient: "Carbs",
                    progress: ifResult(carbs, aimedCarbs),
                    progressColor: ifResult(carbs, aimedCarbs) >= 1
                        ? Colors.redAccent
                        : chartColor,
                    amount: carbs,
                    width: 100,
                  ),
                  _IngredientProgress(
                    ingredient: "Fats",
                    progress: ifResult(fat, aimedFat),
                    progressColor: ifResult(fat, aimedFat) >= 1
                        ? Colors.redAccent
                        : chartColor,
                    amount: fat,
                    width: 100,
                  ),
                ],
              ),
            ),
            Flexible(
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  "\n" +
                      (now.day - pastIndex).toString() +
                      ".0" +
                      (now.month.toString()) +
                      "." +
                      (now.year.toString()),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IngredientProgress extends StatelessWidget {
  final String ingredient;
  final double amount;
  final double progress, width;
  final Color progressColor;

  const _IngredientProgress(
      {required this.ingredient,
      required this.amount,
      required this.progress,
      required this.progressColor,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          ingredient.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 10,
                  width: width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.black12,
                  ),
                ),
                Container(
                  height: 10,
                  width: width * progress,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    color: progressColor,
                  ),
                )
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "$amount g",
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
