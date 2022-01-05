import 'package:binancy/utils/ui/styles.dart';
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
        padding: const EdgeInsets.only(left: customMargin),
        child: Divider(
          color: Colors.white.withOpacity(0.1),
          height: 0,
        ));
  }
}

class SpaceDivider extends StatelessWidget {
  const SpaceDivider(
      {Key? key,
      this.customSpace = 0,
      this.isVertical = false,
      this.addDivider = false})
      : super(key: key);

  final double customSpace;
  final bool isVertical;
  final bool addDivider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isVertical
          ? 0
          : customSpace != 0
              ? customSpace
              : customMargin,
      width: isVertical
          ? customSpace != 0
              ? customSpace
              : customMargin
          : 0,
      child:
          addDivider ? const Center(child: LinearDivider()) : const SizedBox(),
    );
  }
}

class BinancyButton extends StatelessWidget {
  const BinancyButton(
      {Key? key,
      required this.context,
      required this.text,
      required this.action,
      this.wrapOnFinal = false})
      : super(key: key);

  final BuildContext context;
  final String text;
  final Function() action;
  final bool wrapOnFinal;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: themeColor.withOpacity(0.1),
      elevation: 0,
      borderRadius: wrapOnFinal
          ? const BorderRadius.only(
              bottomLeft: Radius.circular(customBorderRadius),
              bottomRight: Radius.circular(customBorderRadius))
          : BorderRadius.circular(customBorderRadius),
      child: InkWell(
        onTap: action,
        highlightColor: themeColor.withOpacity(0.1),
        borderRadius: wrapOnFinal
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(customBorderRadius),
                bottomRight: Radius.circular(customBorderRadius))
            : BorderRadius.circular(customBorderRadius),
        splashColor: themeColor.withOpacity(0.1),
        child: SizedBox(
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

class BinancyBackground extends StatelessWidget {
  const BinancyBackground(this.child, {Key? key}) : super(key: key);

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

class BinancyIconVertical extends StatefulWidget {
  const BinancyIconVertical({Key? key, this.showProgressIndicator = false})
      : super(key: key);

  final bool showProgressIndicator;

  @override
  State<BinancyIconVertical> createState() => _BinancyIconVerticalState();
}

class _BinancyIconVerticalState extends State<BinancyIconVertical> {
  double progressIndicatorSize = 0;

  @override
  Widget build(BuildContext context) {
    revealProgressIndicator();
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
            padding: const EdgeInsets.all(customMargin),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icons/binancy_icon.png",
                ),
                AnimatedContainer(
                  height: progressIndicatorSize,
                  width: progressIndicatorSize,
                  duration: const Duration(
                      milliseconds: splashScreenProgressIndicatorTransitionMS),
                  child: CircularProgressIndicator(
                    strokeWidth: 5,
                    backgroundColor: themeColor.withOpacity(0.1),
                    color: accentColor,
                  ),
                )
              ],
            ))));
  }

  void revealProgressIndicator() {
    if (widget.showProgressIndicator) {
      Future.delayed(const Duration(
              milliseconds: splashScreenTimeToShowProgressIndicatorMS))
          .then((value) => setState(() {
                progressIndicatorSize = 75;
              }));
    }
  }
}

class BinancyIconHorizontal extends StatelessWidget {
  const BinancyIconHorizontal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
            padding: const EdgeInsets.all(customMargin),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icons/binancy_icon_h.png",
                ),
              ],
            ))));
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
