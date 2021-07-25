import 'package:flutter/material.dart';

Color primaryColor = Color(0xff054ECE);
Color secondaryColor = Color(0xff195AD2);
Color accentColor = Color(0xffDAE3F2);
Color textColor = Color(0xff5d5d5d);

TextStyle addButtonStyle() {
  return TextStyle(color: Colors.white, fontSize: 12);
}

TextStyle titleCardStyle() {
  return TextStyle(color: textColor, fontSize: 20);
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
