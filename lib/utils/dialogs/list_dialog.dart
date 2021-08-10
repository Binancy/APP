import 'dart:io';

import 'package:binancy/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';

class BinancyListDialog {
  late BuildContext context;
  String title = "";
  List<String> listOptions = [];
  int result = 0;
  Function(int result) action = (result) {};

  BinancyListDialog(BuildContext context, String text, List<String> listOptions,
      Function(int value) action) {
    this.context = context;
    this.title = title;
    this.listOptions = listOptions;
    this.action = action;
    showCustomDialog();
  }

  void showCustomDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
                title: Text(title),
                content: createListOptions(),
                actions: [actionButton(true)],
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(customBorderRadius)),
                elevation: 5,
                title: Text(title),
                content: createListOptions(),
                actions: [actionButton(false)],
              ));
    }
  }

  Widget actionButton(bool isIOS) {
    if (isIOS) {
      return CupertinoButton(child: Text("Aceptar"), onPressed: () => action);
    } else {
      return TextButton(onPressed: () => action, child: Text("Aceptar"));
    }
  }

  Widget createListOptions() {
    return Container(
      height: (MediaQuery.of(context).size.height / 10) * 6,
      width: MediaQuery.of(context).size.width - (customMargin * 2),
      child: ListView.builder(
          itemCount: categoryList.length,
          itemBuilder: (context, index) => RadioListTile(
              selected:
                  listOptions.indexOf(listOptions.elementAt(index)) == result,
              value: listOptions.elementAt(index),
              secondary: Text(listOptions.elementAt(index)),
              groupValue: String,
              onChanged: (value) {})),
    );
  }
}
