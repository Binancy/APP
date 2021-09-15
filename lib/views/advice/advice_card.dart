import 'package:binancy/globals.dart';
import 'package:binancy/utils/ui/styles.dart';
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
      constraints: const BoxConstraints(minHeight: adviceCardMinHeight),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: customMargin, right: customMargin),
      decoration: BoxDecoration(
          color: themeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(customBorderRadius)),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          SizedBox(height: 60, width: 60, child: icon),
          const SpaceDivider(isVertical: true),
          Expanded(child: Text(text, style: semititleStyle()))
        ],
      ),
    );
  }
}
