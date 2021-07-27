import 'package:binancy/globals.dart';
import 'package:binancy/models/expend.dart';
import 'package:binancy/models/income.dart';
import 'package:binancy/utils/styles.dart';
import 'package:flutter/material.dart';

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
    return Container();
  }
}
