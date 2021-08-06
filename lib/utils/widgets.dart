import 'package:binancy/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:binancy/globals.dart';
import 'package:flutter_svg/svg.dart';

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

class BinancyButton extends StatelessWidget {
  const BinancyButton(
      {Key? key,
      required this.context,
      required this.text,
      required this.action})
      : super(key: key);

  final BuildContext context;
  final String text;
  final Function() action;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: themeColor.withOpacity(0.1),
      elevation: 0,
      borderRadius: BorderRadius.circular(customBorderRadius),
      child: InkWell(
        onTap: action,
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(customBorderRadius),
        splashColor: themeColor.withOpacity(0.1),
        child: Container(
          height: buttonHeight,
          child: Center(
            child: Text(
              text,
              style: buttonStyle(),
            ),
          ),
        ),
      ),
    );
  }
}

class BalancyBackground extends StatelessWidget {
  const BalancyBackground(this.child, {Key? key}) : super(key: key);

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
      child: child,
    );
  }
}

class BinancyLogoVert extends StatelessWidget {
  const BinancyLogoVert({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        SizedBox(
          height: 200,
          width: 200,
          child: SvgPicture.asset(
            "assets/svg/binancy_icon.svg",
            color: textColor,
          ),
        ),
        Text(
          appName.toUpperCase(),
          style: TextStyle(
              color: textColor,
              fontSize: 50,
              letterSpacing: 15,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        )
      ],
    ));
  }
}