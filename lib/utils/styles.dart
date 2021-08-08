import 'package:flutter/material.dart';

Color primaryColor = Color(0xff012457);
Color secondaryColor = Color(0xff054CCB);
Color accentColor = Color(0xffFDCB32);
Color textColor = Color(0xffffffff);
Color themeColor = Colors.black;

TextStyle dashboardHeaderItemTitleStyle() {
  return TextStyle(fontSize: 22, color: textColor);
}

TextStyle dashboardHeaderItemActionStyle() {
  return TextStyle(fontSize: 13, color: accentColor);
}

TextStyle appBarStyle() {
  return TextStyle(color: Colors.white, fontSize: 25);
}

TextStyle whiteButtonStyle() {
  return TextStyle(color: Colors.white, fontSize: 18);
}

TextStyle dashboardActionButtonStyle() {
  return TextStyle(color: Colors.white, fontSize: 13);
}

TextStyle titleCardStyle() {
  return TextStyle(color: textColor, fontSize: 25, fontWeight: FontWeight.bold);
}

TextStyle accentTitleStyle() {
  return TextStyle(
      color: accentColor, fontSize: 25, fontWeight: FontWeight.bold);
}

TextStyle semititleStyle() {
  return TextStyle(color: textColor, fontSize: 15);
}

TextStyle balanceValueStyle() {
  return TextStyle(color: textColor, fontSize: 70, fontWeight: FontWeight.bold);
}

TextStyle detailStyle() {
  return TextStyle(color: textColor, fontSize: 15);
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

TextStyle settingsKeyStyle() {
  return TextStyle(color: textColor, fontSize: 20);
}

TextStyle settingsValueStyle() {
  return TextStyle(color: accentColor, fontSize: 20);
}

TextStyle buttonStyle() {
  return TextStyle(
      color: accentColor, fontSize: 25, fontWeight: FontWeight.bold);
}

TextStyle inputStyle() {
  return TextStyle(color: textColor, fontSize: 18);
}

TextStyle accentStyle() {
  return TextStyle(color: accentColor, fontSize: 18);
}

TextStyle miniInputStyle() {
  return TextStyle(color: textColor, fontSize: 14);
}

TextStyle miniAccentStyle() {
  return TextStyle(color: accentColor, fontSize: 14);
}

InputDecoration customInputDecoration(String text, IconData icon) {
  return InputDecoration(
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      labelText: text,
      labelStyle: inputStyle(),
      icon: Icon(
        icon,
        color: accentColor,
        size: 36,
      ));
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
