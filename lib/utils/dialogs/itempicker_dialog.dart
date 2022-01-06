import 'dart:io';
import 'dart:ui';

import 'package:binancy/utils/ui/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';

class BinancySelectorPickerDialog {
  final BuildContext context;
  final String title;
  final Icon? icon;
  final String hint;
  final bool allowEdit;
  final List<dynamic> items;
  final dynamic selectedItem;
  final Function(dynamic) onChanged;

  BinancySelectorPickerDialog(
      {required this.context,
      required this.title,
      required this.hint,
      required this.items,
      required this.selectedItem,
      required this.onChanged,
      this.allowEdit = true,
      this.icon});

  Future<void> showSelectorPickerDialog() async {
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
          pageBuilder: (_, animation, secondaryAnimation) =>
              CupertinoDialogAction(
                  child: StatefulBuilder(
                builder: (_, setDialogState) => Container(
                  margin: const EdgeInsets.all(customMargin),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(customBorderRadius)),
                  padding: const EdgeInsets.all(customMargin),
                  child: BinancySelectorWidget(
                      hint: hint,
                      items: items,
                      selectedItem: selectedItem,
                      onChanged: onChanged,
                      allowEdit: allowEdit,
                      icon: icon),
                ),
              )));
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
        pageBuilder: (_, animation, secondaryAnimation) => Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(customBorderRadius)),
          elevation: 5,
          child: StatefulBuilder(
            builder: (_, setDialogState) => Container(
              padding: const EdgeInsets.all(customMargin),
              child: BinancySelectorWidget(
                  hint: hint,
                  items: items,
                  selectedItem: selectedItem,
                  onChanged: onChanged,
                  allowEdit: allowEdit,
                  icon: icon),
            ),
          ),
        ),
      );
    }
  }
}
