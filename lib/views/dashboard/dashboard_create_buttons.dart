import 'package:binancy/globals.dart';
import 'package:binancy/utils/styles.dart';
import 'package:flutter/material.dart';

class DashboardCreateButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Card(
            elevation: 5,
            color: primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(customBorderRadius)),
            child: Padding(
              padding: EdgeInsets.all(18),
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
                    'Añade un ingreso',
                    overflow: TextOverflow.ellipsis,
                    style: addButtonStyle(),
                  )
                ],
              ),
            ),
          ),
          Card(
            elevation: 5,
            color: primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(customBorderRadius)),
            child: Padding(
              padding: EdgeInsets.all(18),
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
                    'Añade un ingreso',
                    overflow: TextOverflow.ellipsis,
                    style: addButtonStyle(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
