import 'package:binancy/globals.dart';
import 'package:binancy/models/expend.dart';
import 'package:binancy/models/income.dart';
import 'package:binancy/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardNotification extends StatelessWidget {
  dynamic _notification;

  DashboardNotification(this._notification);
  @override
  Widget build(BuildContext context) {
    bool isIncome = _notification is Income ? true : false;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(customBorderRadius)),
      shadowColor: Colors.black.withOpacity(0.2),
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(360)),
              child: Center(
                child: isIncome
                    ? Icon(
                        Icons.record_voice_over,
                        color: Colors.white,
                      )
                    : Icon(Icons.send, color: Colors.white),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMd().format(_notification.date),
                  style: dashboardDateStyle(),
                ),
                Text(
                  'Compras online',
                  style: dashboardCategoryStyle(),
                ),
                Text(
                  _notification.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: dashboardDescriptionStyle(),
                ),
              ],
            )),
            SizedBox(
              width: 10,
            ),
            Center(
              child: _notification.value % 1 == 0
                  ? Text(
                      (_notification.value).toStringAsFixed(0) + "€",
                      style: dashboardValueStyle(),
                    )
                  : Text(
                      (_notification.value).toStringAsFixed(2) + "€",
                      style: dashboardValueStyle(),
                    ),
            )
          ],
        ),
      ),
    );
  }
}

class DashboardSeeAllNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Material(
        color: primaryColor,
        borderRadius: BorderRadius.circular(customBorderRadius),
        shadowColor: Colors.black.withOpacity(0.2),
        elevation: 5,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(customBorderRadius),
          highlightColor: Colors.transparent,
          splashColor: accentColor.withOpacity(0.2),
          child: Container(
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'Ver todas las notificaciones',
                    style: whiteButtonStyle(),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
