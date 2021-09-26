import 'package:binancy/controllers/account_controller.dart';
import 'package:binancy/utils/dialogs/date_dialog.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/dialogs/progress_dialog.dart';
import 'package:binancy/utils/ui/icons.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../globals.dart';

class SettingsEditUserInfoView extends StatefulWidget {
  final Function() refreshParent;

  const SettingsEditUserInfoView({Key? key, required this.refreshParent})
      : super(key: key);

  @override
  State<SettingsEditUserInfoView> createState() =>
      _SettingsEditUserInfoViewState();
}

class _SettingsEditUserInfoViewState extends State<SettingsEditUserInfoView> {
  TextEditingController nameController = TextEditingController(),
      firstSurnameController = TextEditingController(),
      lastSurnameController = TextEditingController();

  FocusNode nameFocusNode = FocusNode(),
      firstSurnameFocusNode = FocusNode(),
      lastSurnameFocusNode = FocusNode();

  String birthdayDate = "";
  int selectedPayDay = 0;
  bool firstRun = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    birthdayDate = AppLocalizations.of(context)!.birthday;
  }

  @override
  void dispose() {
    nameController.dispose();
    firstSurnameController.dispose();
    lastSurnameController.dispose();
    nameFocusNode.dispose();
    firstSurnameFocusNode.dispose();
    lastSurnameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (firstRun) {
      setInitialData();
      firstRun = false;
    }
    return Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(customBorderRadius),
                topRight: Radius.circular(customBorderRadius)),
            gradient: LinearGradient(
                colors: [primaryColor, secondaryColor],
                end: Alignment.bottomCenter,
                begin: Alignment.topCenter)),
        child: Material(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(customBorderRadius),
              topRight: Radius.circular(customBorderRadius)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: Colors.transparent,
          child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(customMargin),
                  children: [
                    Center(
                        child: Text(AppLocalizations.of(context)!.edit_profile,
                            style: titleCardStyle())),
                    const SpaceDivider(),
                    inputWidget(
                        controller: nameController,
                        hintText: AppLocalizations.of(context)!.your_name,
                        icon: BinancyIcons.user,
                        onSubmitted: (value) =>
                            firstSurnameFocusNode.requestFocus()),
                    const SpaceDivider(),
                    inputWidget(
                        controller: firstSurnameController,
                        hintText:
                            AppLocalizations.of(context)!.your_first_surname,
                        icon: BinancyIcons.user,
                        onSubmitted: (value) =>
                            lastSurnameFocusNode.requestFocus()),
                    const SpaceDivider(),
                    inputWidget(
                        controller: lastSurnameController,
                        hintText:
                            AppLocalizations.of(context)!.your_last_surname,
                        icon: BinancyIcons.user,
                        onSubmitted: (value) => lastSurnameFocusNode.unfocus()),
                    const SpaceDivider(),
                    inputDateWidget(
                        dateString: birthdayDate,
                        onFinish: (value) {
                          if (value != null) {
                            setState(() {
                              birthdayDate = Utils.toYMD(value, context);
                            });
                          }
                        }),
                    const SpaceDivider(),
                    BinancyButton(
                        context: context,
                        text: AppLocalizations.of(context)!.update_profile,
                        action: () => checkData()),
                    SpaceDivider(
                        customSpace: MediaQuery.of(context).viewInsets.bottom)
                  ])),
        ));
  }

  Widget inputWidget(
      {required TextEditingController controller,
      required String hintText,
      required IconData icon,
      required Function(String) onSubmitted,
      List<TextInputFormatter>? inputFormatters}) {
    return Container(
      height: buttonHeight,
      padding: const EdgeInsets.only(left: customMargin, right: customMargin),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(customBorderRadius),
          color: themeColor.withOpacity(0.1)),
      alignment: Alignment.center,
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.next,
        onSubmitted: onSubmitted,
        inputFormatters: inputFormatters,
        keyboardType: TextInputType.name,
        controller: controller,
        style: inputStyle(),
        decoration: customInputDecoration(hintText, icon),
      ),
    );
  }

  Widget inputDateWidget(
      {required String dateString, required Function(DateTime?) onFinish}) {
    return Material(
      color: themeColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(customBorderRadius),
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          BinancyDatePicker binancyDatePicker = BinancyDatePicker(
              context: context,
              initialDate: Utils.isValidDateYMD(dateString, context)
                  ? Utils.fromYMD(dateString, context)
                  : DateTime.now());
          binancyDatePicker.showCustomDialog().then((value) => onFinish(value));
        },
        borderRadius: BorderRadius.circular(customBorderRadius),
        highlightColor: themeColor.withOpacity(0.1),
        splashColor: themeColor.withOpacity(0.1),
        child: Container(
            height: buttonHeight,
            padding:
                const EdgeInsets.only(left: customMargin, right: customMargin),
            child: Row(
              children: [
                Icon(
                  BinancyIcons.calendar,
                  color: accentColor,
                  size: 36,
                ),
                const SpaceDivider(
                  isVertical: true,
                ),
                Text(dateString, style: inputStyle())
              ],
            )),
      ),
    );
  }

  void checkData() {
    FocusScope.of(context).unfocus();
    if (nameController.text.isNotEmpty) {
      if (hasChangedData()) {
        BinancyProgressDialog binancyProgressDialog =
            BinancyProgressDialog(context: context)..showProgressDialog();
        AccountController.updateProfile({
          'nameUser': nameController.text,
          'firstSurname': firstSurnameController.text,
          'lastSurname': lastSurnameController.text,
          'birthday': Utils.validateStringDate(birthdayDate)
              ? Utils.toISOStandard(Utils.fromYMD(birthdayDate, context))
              : null
        }).then((value) {
          if (value) {
            userData['nameUser'] = nameController.text;
            userData['firstSurname'] = firstSurnameController.text;
            userData['lastSurname'] = lastSurnameController.text;
            userData['birthday'] = Utils.validateStringDate(birthdayDate)
                ? Utils.toISOStandard(Utils.fromYMD(birthdayDate, context))
                : null;
            widget.refreshParent();
            binancyProgressDialog.dismissDialog();
            BinancyInfoDialog(
                context, AppLocalizations.of(context)!.profile_update_success, [
              BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
                Navigator.pop(context);
                Navigator.pop(context);
              })
            ]);
          } else {
            binancyProgressDialog.dismissDialog();
            BinancyInfoDialog(
                context, AppLocalizations.of(context)!.profile_update_fail, [
              BinancyInfoDialogItem(AppLocalizations.of(context)!.accept,
                  () => Navigator.pop(context))
            ]);
          }
        });
      } else {
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.profile_update_no_changes, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept,
              () => Navigator.pop(context))
        ]);
      }
    } else {
      BinancyInfoDialog(
          context, AppLocalizations.of(context)!.profile_invalid_name, [
        BinancyInfoDialogItem(
            AppLocalizations.of(context)!.accept, () => Navigator.pop(context))
      ]);
    }
  }

  void setInitialData() {
    nameController.text = userData['nameUser'];
    firstSurnameController.text = userData['firstSurname'] ?? "";
    lastSurnameController.text = userData['lastSurname'] ?? "";
    selectedPayDay = userData['payDay'];
    birthdayDate = userData['birthday'] != null
        ? Utils.toYMD(Utils.fromISOStandard(userData['birthday']), context)
        : AppLocalizations.of(context)!.set_birthday;
  }

  bool hasChangedData() {
    bool changedName = false,
        changedFirstSurname = false,
        changedLastName = false,
        changedDate = false;

    if (nameController.text.isEmpty) {
      changedName = userData['nameUser'] != null &&
          (userData['nameUser'] as String).isNotEmpty;
    } else {
      changedName = nameController.text != userData['nameUser'];
    }

    if (firstSurnameController.text.isEmpty) {
      changedFirstSurname = userData['firstSurname'] != null &&
          (userData['firstSurname'] as String).isNotEmpty;
    } else {
      changedFirstSurname =
          firstSurnameController.text != userData['firstSurname'];
    }

    if (lastSurnameController.text.isEmpty) {
      changedLastName = userData['lastSurname'] != null &&
          (userData['lastSurname'] as String).isNotEmpty;
    } else {
      changedLastName = lastSurnameController.text != userData['lastSurname'];
    }

    if (Utils.validateStringDate(birthdayDate)) {
      changedDate = birthdayDate !=
          Utils.toYMD(Utils.fromISOStandard(userData['birthday']), context);
    } else {
      changedDate = birthdayDate != userData['birthday'];
    }

    return changedName || changedFirstSurname || changedLastName || changedDate;
  }
}
