import 'package:binancy/globals.dart';
import 'package:binancy/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardCreateButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: primaryColor,
            borderRadius: BorderRadius.circular(customBorderRadius),
            elevation: 5,
            child: InkWell(
              borderRadius: BorderRadius.circular(customBorderRadius),
              highlightColor: Colors.transparent,
              splashColor: accentColor.withOpacity(0.2),
              onTap: () {},
              child: Container(
                width: (MediaQuery.of(context).size.width / 2) - 30,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        AppLocalizations.of(context)!.dashboard_button_income,
                        overflow: TextOverflow.ellipsis,
                        style: addButtonStyle(),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Material(
            color: primaryColor,
            borderRadius: BorderRadius.circular(customBorderRadius),
            elevation: 5,
            child: InkWell(
              borderRadius: BorderRadius.circular(customBorderRadius),
              highlightColor: Colors.transparent,
              splashColor: accentColor.withOpacity(0.2),
              onTap: () {},
              child: Container(
                width: (MediaQuery.of(context).size.width / 2) - 30,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        AppLocalizations.of(context)!.dashboard_button_expense,
                        overflow: TextOverflow.ellipsis,
                        style: addButtonStyle(),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
