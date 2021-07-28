import 'package:binancy/globals.dart';
import 'package:binancy/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardCreateButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> _listItems = [
      DashboardButtonCard(AppLocalizations.of(context)!.dashboard_button_income,
          Icons.call_received, () => null),
      DashboardButtonCard(
          AppLocalizations.of(context)!.dashboard_button_expense,
          Icons.send_rounded,
          () => null),
    ];

    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Center(
        child: SizedBox(
            height: 90,
            child: ListView.separated(
                shrinkWrap: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => _listItems[index],
                separatorBuilder: (context, index) => SizedBox(width: 20),
                itemCount: _listItems.length)),
      ),
    );
  }
}

class DashboardButtonCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function() action;

  DashboardButtonCard(this.text, this.icon, this.action);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(customBorderRadius),
        shadowColor: Colors.black.withOpacity(0.2),
        elevation: 5,
        child: InkWell(
          onTap: action,
          highlightColor: Colors.transparent,
          splashColor: accentColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(customBorderRadius),
          child: Container(
            height: 90,
            width: (MediaQuery.of(context).size.width / 2) - 45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(customBorderRadius),
                gradient: LinearGradient(
                    colors: [primaryColor, secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 36,
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  text,
                  style: addButtonStyle(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
