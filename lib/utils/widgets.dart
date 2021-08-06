import 'package:flutter/material.dart';
import 'package:binancy/globals.dart';

class LinearDivider extends StatelessWidget {
  const LinearDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: customMargin),
        child: Divider(
          color: Colors.white.withOpacity(0.1),
          height: 0,
        ));
  }
}

class SpaceDivider extends StatelessWidget {
  const SpaceDivider({Key? key, this.customSpace = 0}) : super(key: key);

  final customSpace;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: customSpace != 0 ? customSpace : customMargin);
  }
}
