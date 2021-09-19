import 'dart:io';
import 'dart:ui';

import 'package:binancy/controllers/account_controller.dart';
import 'package:binancy/utils/dialogs/progress_dialog.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../globals.dart';
import '../widgets.dart';
import 'info_dialog.dart';

class BinancyPayDayDialog {
  final BuildContext context;
  final Function() refreshParent;

  int dialogPickerValue = userData['payDay'];

  BinancyPayDayDialog({required this.context, required this.refreshParent}) {
    showPayDayDialog(context);
  }

  void showPayDayDialog(BuildContext context) {
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
                              borderRadius:
                                  BorderRadius.circular(customBorderRadius)),
                          padding: const EdgeInsets.all(customMargin),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Selecciona tu principio de mes",
                                    style: dialogStyle()),
                                const SpaceDivider(),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          customBorderRadius),
                                      color: Colors.grey.withOpacity(0.1)),
                                  padding: const EdgeInsets.all(10),
                                  child: NumberPicker(
                                      minValue: 1,
                                      maxValue: 31,
                                      value: dialogPickerValue,
                                      onChanged: (value) => setDialogState(() {
                                            dialogPickerValue = value;
                                          })),
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
                                            Navigator.pop(context);
                                            BinancyProgressDialog
                                                binancyProgressDialog =
                                                BinancyProgressDialog(
                                                    context: context)
                                                  ..showProgressDialog();
                                            AccountController.updatePayDay(
                                                    dialogPickerValue)
                                                .then((value) {
                                              binancyProgressDialog
                                                  .dismissDialog();
                                              if (value) {
                                                userData['payDay'] =
                                                    dialogPickerValue;
                                                refreshParent();
                                                BinancyInfoDialog(
                                                    context,
                                                    "Principio de mes actualizado correctamente",
                                                    [
                                                      BinancyInfoDialogItem(
                                                          "Aceptar",
                                                          () => Navigator.pop(
                                                              context))
                                                    ]);
                                              } else {
                                                BinancyInfoDialog(
                                                    context,
                                                    "Error al actualizar el principio de mes",
                                                    [
                                                      BinancyInfoDialogItem(
                                                          "Aceptar",
                                                          () => Navigator.pop(
                                                              context))
                                                    ]);
                                              }
                                            });
                                          },
                                          child: Text("Cambiar día",
                                              style: inputStyle())),
                                    ))
                                  ],
                                )
                              ]),
                        ))),
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
                          Text("Selecciona tu principio de mes",
                              style: dialogStyle()),
                          const SpaceDivider(),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(customBorderRadius),
                                color: Colors.grey.withOpacity(0.1)),
                            padding: const EdgeInsets.all(10),
                            child: NumberPicker(
                                minValue: 1,
                                maxValue: 31,
                                value: dialogPickerValue,
                                onChanged: (value) => setDialogState(() {
                                      dialogPickerValue = value;
                                    })),
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
                                      Navigator.pop(context);
                                      BinancyProgressDialog
                                          binancyProgressDialog =
                                          BinancyProgressDialog(
                                              context: context)
                                            ..showProgressDialog();
                                      AccountController.updatePayDay(
                                              dialogPickerValue)
                                          .then((value) {
                                        binancyProgressDialog.dismissDialog();
                                        if (value) {
                                          userData['payDay'] =
                                              dialogPickerValue;
                                          refreshParent();
                                          BinancyInfoDialog(
                                              context,
                                              "Principio de mes actualizado correctamente",
                                              [
                                                BinancyInfoDialogItem(
                                                    "Aceptar",
                                                    () =>
                                                        Navigator.pop(context))
                                              ]);
                                        } else {
                                          BinancyInfoDialog(
                                              context,
                                              "Error al actualizar el principio de mes",
                                              [
                                                BinancyInfoDialogItem(
                                                    "Aceptar",
                                                    () =>
                                                        Navigator.pop(context))
                                              ]);
                                        }
                                      });
                                    },
                                    child: Text("Cambiar día",
                                        style: inputStyle())),
                              ))
                            ],
                          )
                        ]),
                  )),
        ),
      );
    }
  }
}
