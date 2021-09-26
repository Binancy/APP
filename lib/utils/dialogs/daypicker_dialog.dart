import 'dart:io';
import 'dart:ui';

import 'package:binancy/globals.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:binancy/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BinancyDayPickerDialog {
  final BuildContext context;
  final String title;
  final int? initialDate;
  BinancyDayPickerDialog(
      {required this.context, required this.title, this.initialDate});

  Future<int?> showDayPickerDialog() async {
    int dialogPickerValue = initialDate ?? Utils.getTodayDate().day;
    int? selectedDay;

    if (Platform.isIOS) {
      return showGeneralDialog(
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
                              borderRadius:
                                  BorderRadius.circular(customBorderRadius)),
                          padding: const EdgeInsets.all(customMargin),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(title, style: dialogStyle()),
                                const SpaceDivider(),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          customBorderRadius),
                                      color: Colors.grey.withOpacity(0.1)),
                                  padding: const EdgeInsets.all(10),
                                  child: ScrollConfiguration(
                                      behavior: MyBehavior(),
                                      child: NumberPicker(
                                          minValue: 1,
                                          maxValue: 31,
                                          value: dialogPickerValue,
                                          onChanged: (value) =>
                                              setDialogState(() {
                                                dialogPickerValue = value;
                                              }))),
                                ),
                                const SpaceDivider(),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              customBorderRadius)),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      height: 60,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            selectedDay = dialogPickerValue;
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .change_day,
                                              style: inputStyle())),
                                    ))
                                  ],
                                )
                              ]),
                        ))),
      ).then((value) => selectedDay);
    } else {
      return showGeneralDialog(
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
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(title, style: dialogStyle()),
                          const SpaceDivider(),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(customBorderRadius),
                                color: Colors.grey.withOpacity(0.1)),
                            padding: const EdgeInsets.all(10),
                            child: ScrollConfiguration(
                                behavior: MyBehavior(),
                                child: NumberPicker(
                                    minValue: 1,
                                    maxValue: 31,
                                    value: dialogPickerValue,
                                    onChanged: (value) => setDialogState(() {
                                          dialogPickerValue = value;
                                        }))),
                          ),
                          const SpaceDivider(),
                          Row(
                            children: [
                              Expanded(
                                  child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        customBorderRadius)),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                height: 60,
                                child: ElevatedButton(
                                    onPressed: () {
                                      selectedDay = dialogPickerValue;
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .change_day,
                                        style: inputStyle())),
                              ))
                            ],
                          )
                        ]),
                  )),
        ),
      ).then((value) => selectedDay);
    }
  }
}
