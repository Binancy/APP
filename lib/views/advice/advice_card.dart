import 'package:binancy/globals.dart';
import 'package:binancy/utils/styles.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:flutter/material.dart';

class AdviceCard extends StatelessWidget {
  const AdviceCard({Key? key, required this.icon, required this.text})
      : super(key: key);

  final Widget icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: customMargin, right: customMargin),
      decoration: BoxDecoration(
          color: themeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(customBorderRadius)),
      height: 125,
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          SizedBox(height: 60, width: 60, child: icon),
          SpaceDivider(isVertical: true),
          Expanded(child: Text(text, style: semititleStyle()))
        ],
      ),
    );
  }
}
