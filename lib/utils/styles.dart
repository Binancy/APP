import 'package:flutter/material.dart';

Color primaryColor = Color(0xff054ECE);
Color secondaryColor = Color(0xff4186FF);
Color accentColor = Color(0xffDAE3F2);
Color textColor = Color(0xff5d5d5d);

TextStyle appBarStyle() {
  return TextStyle(color: Colors.white, fontSize: 22);
}

TextStyle whiteButtonStyle() {
  return TextStyle(color: Colors.white, fontSize: 18);
}

TextStyle addButtonStyle() {
  return TextStyle(color: Colors.white, fontSize: 13);
}

TextStyle titleCardStyle() {
  return TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold);
}

TextStyle semititleStyle() {
  return TextStyle(color: textColor, fontSize: 15);
}

TextStyle balanceValueStyle() {
  return TextStyle(
      color: primaryColor, fontSize: 50, fontWeight: FontWeight.bold);
}

TextStyle detailStyle() {
  return TextStyle(color: textColor, fontSize: 12);
}

TextStyle dashboardDateStyle() {
  return TextStyle(
      color: primaryColor, fontSize: 12, fontWeight: FontWeight.w600);
}

TextStyle dashboardCategoryStyle() {
  return TextStyle(
      color: secondaryColor, fontSize: 12, fontWeight: FontWeight.w600);
}

TextStyle dashboardDescriptionStyle() {
  return TextStyle(color: textColor, fontSize: 14);
}

TextStyle dashboardValueStyle() {
  return TextStyle(
      color: primaryColor, fontSize: 20, fontWeight: FontWeight.w600);
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
