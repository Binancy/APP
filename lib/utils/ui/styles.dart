import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color primaryColor = Color(0xff012457);
Color secondaryColor = Color(0xff054CCB);
Color accentColor = Color(0xffFDCB32);
Color textColor = Color(0xffffffff);
Color themeColor = Colors.black;

TextStyle dashboardHeaderItemTitleStyle() {
  return TextStyle(fontSize: 22, color: textColor, fontFamily: "OpenSans");
}

TextStyle dashboardHeaderItemActionStyle() {
  return TextStyle(fontSize: 13, color: accentColor, fontFamily: "OpenSans");
}

TextStyle appBarStyle() {
  return TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontFamily: "OpenSans",
      fontWeight: FontWeight.bold);
}

TextStyle whiteButtonStyle() {
  return TextStyle(color: Colors.white, fontSize: 18);
}

TextStyle dashboardActionButtonStyle() {
  return TextStyle(color: Colors.white, fontSize: 13, fontFamily: "OpenSans");
}

TextStyle titleCardStyle() {
  return TextStyle(
      color: textColor,
      decoration: TextDecoration.none,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      fontFamily: "OpenSans");
}

TextStyle settingsHeaderTitleStyle() {
  return TextStyle(
      color: accentColor,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      fontFamily: "OpenSans");
}

TextStyle accentTitleStyle() {
  return TextStyle(
      color: accentColor,
      fontSize: 22,
      decoration: TextDecoration.none,
      fontWeight: FontWeight.bold,
      fontFamily: "OpenSans");
}

TextStyle semititleStyle() {
  return TextStyle(
      color: textColor,
      fontSize: 15,
      decoration: TextDecoration.none,
      fontWeight: FontWeight.w500,
      fontFamily: "OpenSans");
}

TextStyle headerItemView() {
  return TextStyle(
      fontWeight: FontWeight.bold,
      fontFamily: "OpenSans",
      color: textColor,
      decoration: TextDecoration.none,
      fontSize: 30);
}

TextStyle balanceValueStyle() {
  return TextStyle(
      color: textColor,
      fontSize: 70,
      fontWeight: FontWeight.bold,
      fontFamily: "Segoe UI");
}

TextStyle savingsPlanTitleStyle(bool accent) {
  return TextStyle(
      color: accent ? accentColor : textColor,
      fontWeight: FontWeight.bold,
      fontFamily: "OpenSans",
      fontSize: 20);
}

TextStyle detailStyle() {
  return TextStyle(color: accentColor, fontSize: 15, fontFamily: "OpenSans");
}

TextStyle settingsKeyStyle() {
  return TextStyle(
      color: textColor,
      fontSize: 18,
      fontFamily: "OpenSans",
      fontWeight: FontWeight.bold);
}

TextStyle settingsValueStyle() {
  return TextStyle(color: accentColor, fontSize: 18, fontFamily: "OpenSans");
}

TextStyle buttonStyle() {
  return TextStyle(
      color: accentColor,
      fontSize: 22,
      fontWeight: FontWeight.bold,
      fontFamily: "OpenSans");
}

TextStyle inputStyle() {
  return TextStyle(color: textColor, fontSize: 18, fontFamily: "OpenSans");
}

TextStyle plansButtonStyle() {
  return TextStyle(
      color: themeColor,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      fontFamily: "OpenSans");
}

TextStyle accentStyle() {
  return TextStyle(
      color: accentColor,
      fontSize: 18,
      fontWeight: FontWeight.normal,
      fontFamily: "OpenSans",
      decoration: TextDecoration.none);
}

TextStyle miniInputStyle() {
  return TextStyle(color: textColor, fontSize: 14, fontFamily: "OpenSans");
}

TextStyle miniAccentStyle() {
  return TextStyle(color: accentColor, fontSize: 14, fontFamily: "OpenSans");
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
