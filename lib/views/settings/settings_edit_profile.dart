import 'package:binancy/controllers/account_controller.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/ui/icons.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

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

  String birthdayDate = "Tu fecha de nacimiento";
  int selectedPayDay = 0;
  bool firstRun = true;

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
                        child:
                            Text("Edita tu perfil", style: titleCardStyle())),
                    const SpaceDivider(),
                    inputWidget(
                        controller: nameController,
                        hintText: "Tu nombre",
                        icon: BinancyIcons.user,
                        onSubmitted: (value) =>
                            firstSurnameFocusNode.requestFocus()),
                    const SpaceDivider(),
                    inputWidget(
                        controller: firstSurnameController,
                        hintText: "Tu primer apellido",
                        icon: BinancyIcons.user,
                        onSubmitted: (value) =>
                            lastSurnameFocusNode.requestFocus()),
                    const SpaceDivider(),
                    inputWidget(
                        controller: lastSurnameController,
                        hintText: "Tu segundo apellido",
                        icon: BinancyIcons.user,
                        onSubmitted: (value) => lastSurnameFocusNode.unfocus()),
                    const SpaceDivider(),
                    inputDateWidget(dateString: birthdayDate),
                    const SpaceDivider(),
                    BinancyButton(
                        context: context,
                        text: "Actualizar perfil",
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

  Widget inputDateWidget({required String dateString}) {
    return Material(
      color: themeColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(customBorderRadius),
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1970),
                  lastDate: DateTime(DateTime.now().year + 1))
              .then((value) {
            setState(() {
              dateString = DateFormat.yMd(
                      Localizations.localeOf(context).toLanguageTag())
                  .format(value!);
            });
          });
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

  Widget inputNumberWidget() {
    return BinancyButton(
        context: context, text: "Cambia tu principio de mes", action: () {});
  }

  void checkData() {
    if (nameController.text.isNotEmpty) {
      if (nameController.text != userData['nameUser'] ||
          firstSurnameController.text != userData['firstSurname'] ||
          lastSurnameController.text != userData['lastSurname'] ||
          birthdayDate !=
              Utils.toYMD(
                  Utils.fromISOStandard(userData['birthday']), context)) {
        AccountController.updateProfile({
          'nameUser': nameController.text,
          'firstSurname': firstSurnameController.text,
          'lastSurname': lastSurnameController.text,
          'birthday': Utils.toISOStandard(Utils.fromYMD(birthdayDate, context))
        }).then((value) {
          if (value) {
            userData['nameUser'] = nameController.text;
            userData['firstSurname'] = firstSurnameController.text;
            userData['lastSurname'] = lastSurnameController.text;
            userData['birthday'] =
                Utils.toISOStandard(Utils.fromYMD(birthdayDate, context));
            widget.refreshParent();

            BinancyInfoDialog(context, "Datos actualizados correctamente", [
              BinancyInfoDialogItem("Aceptar", () {
                Navigator.pop(context);
                Navigator.pop(context);
              })
            ]);
          } else {
            BinancyInfoDialog(context, "Ha ocurrido un error", [
              BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))
            ]);
          }
        });
      } else {
        BinancyInfoDialog(context, "No hay cambios por aplicar",
            [BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))]);
      }
    } else {
      BinancyInfoDialog(context, "Debes introducir tu nombre",
          [BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))]);
    }
  }

  void setInitialData() {
    nameController.text = userData['nameUser'];
    firstSurnameController.text = userData['firstSurname'];
    lastSurnameController.text = userData['lastSurname'];
    selectedPayDay = userData['payDay'];
    birthdayDate =
        Utils.toYMD(Utils.fromISOStandard(userData['birthday']), context);
  }
}
