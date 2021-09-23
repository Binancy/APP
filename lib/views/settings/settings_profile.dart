import 'dart:ui';
import 'package:binancy/controllers/account_controller.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/dialogs/payday_dialog.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:binancy/views/settings/settings_change_password.dart';
import 'package:binancy/views/settings/settings_edit_profile.dart';
import 'package:binancy/views/settings/settings_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

class SettingsUserDataView extends StatefulWidget {
  const SettingsUserDataView({Key? key}) : super(key: key);

  @override
  _SettingsUserDataViewState createState() => _SettingsUserDataViewState();
}

class _SettingsUserDataViewState extends State<SettingsUserDataView> {
  @override
  Widget build(BuildContext context) {
    return BinancyBackground(
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text("Tu perfil", style: appBarStyle())),
        body: ScrollConfiguration(
            behavior: MyBehavior(),
            child: ListView(
              padding: const EdgeInsets.all(customMargin),
              children: [
                userDataCard(),
                const SpaceDivider(),
                myDataCard(context),
                const SpaceDivider(),
                actionsCard(context)
              ],
            )),
      ),
    );
  }

  Widget userDataCard() {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(customMargin),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: themeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(customBorderRadius)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Utils.getFullUsername(), style: titleCardStyle()),
              Text(userData['email'], style: detailStyle()),
            ],
          )),
          profilePicWidget(),
        ],
      ),
    );
  }

  Widget myDataCard(BuildContext context) {
    List<Widget> widgetList = [
      const SettingsHeaderRow(text: "Mis datos"),
      const LinearDivider(),
      SettingsDataRow(
          title: "Registrado desde",
          data: Utils.toYMD(
              Utils.fromISOStandard(userData['registerDate']), context)),
      const LinearDivider(),
      SettingsDataRow(
          title: "Fecha de nacimiento",
          data: Utils.toYMD(
              Utils.fromISOStandard(userData['birthday']), context)),
      const LinearDivider(),
      SettingsDataRow(
          title: "Principio de mes", data: userData['payDay'].toString()),
    ];

    return Container(
        decoration: BoxDecoration(
            color: themeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(customBorderRadius)),
        child: Column(
          children: widgetList,
        ));
  }

  Widget actionsCard(BuildContext context) {
    List<Widget> widgetList = [
      const SettingsHeaderRow(text: "Acciones disponibles"),
      const LinearDivider(),
      SettingsActionRow(
          text: "Edita tu perfil", action: () => editUserInfo(context)),
      const LinearDivider(),
      SettingsActionRow(
          text: "Cambiar principio de mes",
          action: () => BinancyPayDayDialog(
              context: context, refreshParent: () => setState(() {}))),
      const LinearDivider(),
      SettingsActionRow(
        text: "Cambiar contraseña",
        action: () => SettingsChangePassword(context: context),
      ),
      const LinearDivider(),
      SettingsActionRow(
          text: "Borrar tus datos", action: () => confirmDeleteUserData()),
      const LinearDivider(),
      SettingsActionRow(
        text: "Eliminar cuenta",
        action: () => confirmDeleteAccount(),
      ),
    ];

    return Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
            color: themeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(customBorderRadius)),
        child: Column(
          children: widgetList,
        ));
  }

  Future<dynamic> editUserInfo(BuildContext context) {
    return showModalBottomSheet(
      barrierColor: themeColor.withOpacity(0.65),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(customBorderRadius),
            topRight: Radius.circular(customBorderRadius)),
      ),
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              kToolbarHeight),
      context: context,
      builder: (context) =>
          SettingsEditUserInfoView(refreshParent: () => setState(() {})),
    );
  }

  Widget profilePicWidget() {
    return GestureDetector(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(360),
          child: Image.network(
              "https://res.cloudinary.com/multitaskapp/image/upload/v1623769717/profilePics/users/185.jpg"),
        ),
        onTap: () => showCupertinoModalPopup(
            context: context,
            builder: (context) => CupertinoActionSheet(
                  actions: [
                    CupertinoActionSheetAction(
                      child: const Text('Actualizar foto de perfil'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    CupertinoActionSheetAction(
                      child: const Text('Eliminar foto de perfil',
                          style: TextStyle(color: Colors.red)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                )));
  }

  void confirmDeleteUserData({bool skipVerification = false}) {
    if (!skipVerification) {
      BinancyInfoDialog(
          context,
          "¿Estas seguro que quieres eliminar todos tus datos? Tu cuenta seguirá estando activa para " +
              appName +
              " y los demás servicios que ofrece Appxs",
          [
            BinancyInfoDialogItem("Cancelar", () => Navigator.pop(context)),
            BinancyInfoDialogItem("Eliminar datos",
                () => AccountController.deleteUserData(context))
          ]);
    } else {
      AccountController.deleteUserData(context);
    }
  }

  List<DropdownMenuItem> generatePayDayDialog() {
    List<DropdownMenuItem> payDayNumbersList = [];
    for (var i = 0; i < 30; i++) {
      payDayNumbersList.add(DropdownMenuItem(
          enabled: true,
          value: i + 1,
          child: Text("(i + 1).toString()", style: dialogStyle())));
    }
    return payDayNumbersList;
  }

  void confirmDeleteAccount() {
    BinancyInfoDialog(
        context,
        "¿Estas seguro que quieres eliminar tu cuenta? Si eliminas tu cuenta también se eliminará esta cuenta para los demás servicios que ofrece Appxs, si solamente quieres eliminar tus datos de " +
            appName +
            " selecciona \"Solo " +
            appName +
            "\"",
        [
          BinancyInfoDialogItem("Cancelar", () => Navigator.pop(context)),
          BinancyInfoDialogItem("Solo Binancy",
              () => confirmDeleteUserData(skipVerification: true)),
          BinancyInfoDialogItem("Eliminar completamente",
              () => AccountController.deleteAccount(context))
        ]);
  }
}
