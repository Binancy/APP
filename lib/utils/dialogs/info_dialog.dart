import 'dart:io';
import 'dart:ui';
import 'package:binancy/utils/ui/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';

/// Shows a dialog, depending of the host platform, if host is iOS then will
/// show a CupertinoDialog, instead it will return a MaterialDialog.
class BinancyInfoDialog {
  late BuildContext context;
  String text = "";
  List<BinancyInfoDialogItem> listItems = [];

  BinancyInfoDialog(this.context, this.text, this.listItems) {
    listItems = listItems;
    showCustomDialog();
  }

  void showCustomDialog() {
    if (Platform.isIOS) {
      showGeneralDialog(
        context: context,
        barrierLabel: "",
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        transitionDuration:
            const Duration(milliseconds: progressDialogBlurAnimation),
        transitionBuilder: (context, anim1, anim2, child) => BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
          child: FadeTransition(
            child: child,
            opacity: anim1,
          ),
        ),
        pageBuilder: (context, animation, secondaryAnimation) =>
            CupertinoAlertDialog(
          content: Text(text),
          actions: _parseActions(true),
        ),
      );
    } else {
      showGeneralDialog(
        context: context,
        barrierLabel: "",
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        transitionDuration:
            const Duration(milliseconds: progressDialogBlurAnimation),
        transitionBuilder: (context, anim1, anim2, child) => BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
          child: FadeTransition(
            child: child,
            opacity: anim1,
          ),
        ),
        pageBuilder: (context, animation, secondaryAnimation) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(customBorderRadius)),
          elevation: 5,
          contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          content: Text(text, style: dialogStyle()),
          actions: _parseActions(false),
        ),
      );
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
class BinancyInfoDialogItem {
  String text;
  Function() action;

  BinancyInfoDialogItem(this.text, this.action);
}
