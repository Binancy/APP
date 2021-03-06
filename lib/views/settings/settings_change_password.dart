import 'package:binancy/controllers/account_controller.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/ui/icons.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../globals.dart';

class SettingsChangePassword {
  final BuildContext context;

  FocusNode currentPasswordFocus = FocusNode();
  FocusNode newPassword1Focus = FocusNode();
  FocusNode newPassword2Focus = FocusNode();

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPassword1Controller = TextEditingController();
  TextEditingController newPassword2Controller = TextEditingController();

  bool currentPasswordHidePass = true,
      newPassword1HidePass = true,
      newPassword2HidePass = true;

  SettingsChangePassword({required this.context}) {
    changePasswordDialog(context);
  }

  Future<dynamic> changePasswordDialog(BuildContext context) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top),
        barrierColor: themeColor.withOpacity(0.65),
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(customBorderRadius),
              topRight: Radius.circular(customBorderRadius)),
        ),
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (context, setModalState) => Material(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 0,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(customBorderRadius),
                    topRight: Radius.circular(customBorderRadius)),
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(customMargin),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [primaryColor, secondaryColor],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter)),
                  child: ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: SingleChildScrollView(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                              child: Text(
                                  AppLocalizations.of(context)!
                                      .change_password_header,
                                  style: titleCardStyle(),
                                  textAlign: TextAlign.center)),
                          const SpaceDivider(),
                          currentPasswordWidget(() => {
                                setModalState(() {
                                  currentPasswordHidePass =
                                      !currentPasswordHidePass;
                                })
                              }),
                          const SpaceDivider(),
                          newPassword1Widget(() => {
                                setModalState(() {
                                  newPassword1HidePass = !newPassword1HidePass;
                                })
                              }),
                          const SpaceDivider(),
                          newPassword2Widget(
                              () => {
                                    setModalState(() {
                                      newPassword2HidePass =
                                          !newPassword2HidePass;
                                    })
                                  },
                              () => setModalState(() {
                                    currentPasswordController.text = "";
                                    newPassword1Controller.text = "";
                                    newPassword2Controller.text = "";
                                  })),
                          const SpaceDivider(),
                          BinancyButton(
                              context: context,
                              text:
                                  AppLocalizations.of(context)!.change_password,
                              action: () =>
                                  changePassword(() => setModalState(() {
                                        currentPasswordController.text = "";
                                        newPassword1Controller.text = "";
                                        newPassword2Controller.text = "";
                                      }))),
                          SpaceDivider(
                              customSpace:
                                  MediaQuery.of(context).viewInsets.bottom),
                        ],
                      ))),
                ))));
  }

  Widget currentPasswordWidget(Function() onPressed) {
    return Container(
        height: buttonHeight,
        padding: const EdgeInsets.only(left: customMargin, right: customMargin),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(customBorderRadius),
            color: themeColor.withOpacity(0.1)),
        alignment: Alignment.center,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                focusNode: currentPasswordFocus,
                onSubmitted: (value) => newPassword1Focus.requestFocus(),
                controller: currentPasswordController,
                style: inputStyle(),
                autocorrect: false,
                enableSuggestions: false,
                obscureText: currentPasswordHidePass,
                decoration: customInputDecoration(
                    AppLocalizations.of(context)!.current_password,
                    BinancyIcons.key),
              ),
            ),
            IconButton(
                icon: Icon(
                  BinancyIcons.eye,
                  color: accentColor,
                  size: 36,
                ),
                onPressed: onPressed)
          ],
        ));
  }

  Widget newPassword1Widget(Function() onPressed) {
    return Container(
        height: buttonHeight,
        padding: const EdgeInsets.only(left: customMargin, right: customMargin),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(customBorderRadius),
            color: themeColor.withOpacity(0.1)),
        alignment: Alignment.center,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                focusNode: newPassword1Focus,
                onSubmitted: (value) => newPassword2Focus.requestFocus(),
                controller: newPassword1Controller,
                style: inputStyle(),
                autocorrect: false,
                enableSuggestions: false,
                obscureText: newPassword1HidePass,
                decoration: customInputDecoration(
                    AppLocalizations.of(context)!.new_password,
                    BinancyIcons.key),
              ),
            ),
            IconButton(
                icon: Icon(
                  BinancyIcons.eye,
                  color: accentColor,
                  size: 36,
                ),
                onPressed: onPressed)
          ],
        ));
  }

  Widget newPassword2Widget(Function() onPressed, Function() setModalState) {
    return Container(
        height: buttonHeight,
        padding: const EdgeInsets.only(left: customMargin, right: customMargin),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(customBorderRadius),
            color: themeColor.withOpacity(0.1)),
        alignment: Alignment.center,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                focusNode: newPassword2Focus,
                onSubmitted: (value) => changePassword(setModalState),
                controller: newPassword2Controller,
                style: inputStyle(),
                autocorrect: false,
                enableSuggestions: false,
                obscureText: newPassword2HidePass,
                decoration: customInputDecoration(
                    AppLocalizations.of(context)!.repeat_new_password,
                    BinancyIcons.key),
              ),
            ),
            IconButton(
                icon: Icon(
                  BinancyIcons.eye,
                  color: accentColor,
                  size: 36,
                ),
                onPressed: onPressed)
          ],
        ));
  }

  void changePassword(Function() setModalState) {
    FocusScope.of(context).unfocus();
    if (currentPasswordController.text.isNotEmpty) {
      if (Utils.encrypt(currentPasswordController.text) ==
          userData['password']) {
        if (newPassword1Controller.text.isNotEmpty &&
            newPassword2Controller.text.isNotEmpty) {
          if (newPassword1Controller.text == newPassword2Controller.text) {
            if (Utils.verifySecurityPassword(newPassword1Controller.text)) {
              AccountController.changePassword(
                  context, newPassword1Controller.text, () {
                setModalState();
                Navigator.pop(context);
                Navigator.pop(context);
              });
            } else {
              BinancyInfoDialog(
                  context, AppLocalizations.of(context)!.password_not_valid, [
                BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
                  Navigator.pop(context);
                  newPassword1Focus.requestFocus();
                })
              ]);
            }
          } else {
            BinancyInfoDialog(
                context, AppLocalizations.of(context)!.password_not_match, [
              BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
                Navigator.pop(context);
                newPassword1Focus.requestFocus();
              })
            ]);
          }
        } else {
          BinancyInfoDialog(
              context, AppLocalizations.of(context)!.password_not_empty, [
            BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
              Navigator.pop(context);
              if (newPassword1Controller.text.isEmpty) {
                newPassword1Focus.requestFocus();
              } else {
                newPassword2Focus.requestFocus();
              }
            })
          ]);
        }
      } else {
        BinancyInfoDialog(context,
            AppLocalizations.of(context)!.password_not_current_password, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
            Navigator.pop(context);
            currentPasswordFocus.requestFocus();
          })
        ]);
      }
    } else {
      BinancyInfoDialog(
          context, AppLocalizations.of(context)!.password_current_empty, [
        BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
          Navigator.pop(context);
          currentPasswordFocus.requestFocus();
        })
      ]);
    }
  }
}
