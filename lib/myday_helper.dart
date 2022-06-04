import 'package:nutrition_project/constants.dart';

class MyDayHelper{
static Meal breakfast = Meal();
static Meal lunch = Meal();
static Meal dinner = Meal();
static void addBreakfast(FoodData foodData){
  breakfast.foods.add(foodData);
}

static void addLunch(FoodData foodData){
  lunch.foods.add(foodData);
}
static void addDinner(FoodData foodData){
  dinner.foods.add(foodData);
}
}
class Meal {
  List<FoodData> foods = [];

}
