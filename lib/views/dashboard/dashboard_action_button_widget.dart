import 'package:binancy/utils/ui/styles.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';

class ActionButtonWidget extends StatelessWidget {
  const ActionButtonWidget({
    Key? key,
    required this.context,
    required this.icon,
    required this.text,
    required this.action,
  }) : super(key: key);

  final BuildContext context;
  final Widget icon;
  final String text;
  final Function() action;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(customBorderRadius),
      color: Colors.transparent,
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(customBorderRadius),
        onTap: action,
        highlightColor: themeColor.withOpacity(0.1),
        splashColor: themeColor.withOpacity(0.1),
        child: SizedBox(
          height: (MediaQuery.of(context).size.height / 10) + 3,
          width: (MediaQuery.of(context).size.height / 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40, width: 40, child: Center(child: icon)),
              const SizedBox(height: 3),
              Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    text,
                    style: dashboardActionButtonStyle(),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
