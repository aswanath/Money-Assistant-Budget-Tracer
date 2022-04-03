import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


Color secondaryPurple = Color(0xFF6C0BA9);
Color incomeBlue = Color(0xFF0000FF);
Color expenseRed = Color(0xFFFF0000);
Color commonBlack = Color(0xFF000000);
Color dateGrey = Color(0xFF868686);
Color tileGrey = Color(0xFFE5E4EC);
Color searchTabGrey = Color(0xFFE4E4E4);
Color onBoarding = Color(0xFFFF8819);
Color commonWhite = Colors.white;
late double deviceWidth;
late double deviceHeight;


final DateFormat dateFormatterFull = DateFormat("dd-MM-yyyy");
final DateFormat dateFormatterDate = DateFormat("d MMM");
final DateFormat dateFormatterDay = DateFormat("E");
final DateFormat dateFormatterKey = DateFormat("MMdd");
final DateFormat dateFormatter = DateFormat("HHmmss");
final DateFormat dateFormatterMonth = DateFormat("MMM yyyy");
final DateFormat dateFormatterPeriod = DateFormat("ddMMyyyy");

final List<Color> paletteColor = [
  Colors.green,
  Colors.grey,
  Colors.greenAccent,
  Colors.purpleAccent,
  Colors.amberAccent,
  Colors.brown,
  Colors.blue,
  Colors.blueGrey,
  Colors.cyan,
  Colors.amber,
  Colors.deepOrangeAccent,
  Colors.red,
  Colors.lime,
  Colors.green,
  Colors.white12
];

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}




