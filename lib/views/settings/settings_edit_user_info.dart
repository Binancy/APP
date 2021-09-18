import 'package:binancy/utils/ui/icons.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../globals.dart';

class SettingsEditUserInfoView extends StatefulWidget {
  const SettingsEditUserInfoView({Key? key}) : super(key: key);

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
    setInitialData();
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
                    Center(
                        child:
                            Text("Tu configuración", style: titleCardStyle())),
                    const SpaceDivider(),
                    const SpaceDivider(),
                    BinancyButton(
                        context: context,
                        text: "Actualizar datos",
                        action: () {}),
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
        textInputAction: TextInputAction.next,
        onSubmitted: onSubmitted,
        inputFormatters: inputFormatters,
        keyboardType: TextInputType.emailAddress,
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
        context: context, text: "Cambia tu dia de pago", action: () {});
  }

  void setInitialData() {
    nameController.text = userData['nameUser'];
    firstSurnameController.text = userData['firstSurname'];
    lastSurnameController.text = userData['lastSurname'];
    selectedPayDay = userData['payDay'];
  }
}
