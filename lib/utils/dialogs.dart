import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../globals.dart';

/// Shows a dialog, depending of the host platform, if host is iOS then will
/// show a CupertinoDialog, instead it will return a MaterialDialog.
class CustomDialog {
  late BuildContext context;
  String text = "";
  List<CustomDialogItem> listItems = [];

  CustomDialog(
      BuildContext context, String text, List<CustomDialogItem> listItems) {
    this.context = context;
    this.text = text;
    this.listItems = listItems;
    showCustomDialog();
  }

  void showCustomDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
                title: Text(appName),
                content: Text(text),
                actions: _parseActions(true),
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(customBorderRadius)),
                elevation: 5,
                title: Text(appName),
                content: Text(text),
                actions: _parseActions(false),
              ));
    }
  }

  List<Widget> _parseActions(bool isIOS) {
    List<Widget> actionsList = [];
    if (isIOS) {
      for (var item in listItems) {
        actionsList.add(
            CupertinoButton(child: Text(item.text), onPressed: item.action));
      }
    } else {
      for (var item in listItems) {
        actionsList
            .add(TextButton(onPressed: item.action, child: Text(item.text)));
      }
    }
    return actionsList;
  }
}

/// Creates an item for CustomDialog, this item contain a placeholder text of the item
/// and the action that will be realized when the user taps on it.
class CustomDialogItem {
  String text;
  Function() action;

  CustomDialogItem(this.text, this.action);
}
