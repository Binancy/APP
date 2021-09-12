import 'package:binancy/controllers/account_controller.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/ui/icons.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/widgets.dart';
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
  FocusNode currentPasswordFocus = FocusNode();
  FocusNode newPassword1Focus = FocusNode();
  FocusNode newPassword2Focus = FocusNode();

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPassword1Controller = TextEditingController();
  TextEditingController newPassword2Controller = TextEditingController();

  bool currentPasswordHidePass = true,
      newPassword1HidePass = true,
      newPassword2HidePass = true;

  @override
  Widget build(BuildContext context) {
    return BinancyBackground(
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text("Tu información", style: appBarStyle())),
        body: ScrollConfiguration(
            behavior: MyBehavior(),
            child: Container(
                child: ListView(
              padding: EdgeInsets.all(customMargin),
              children: [
                userDataCard(),
                SpaceDivider(),
                myDataCard(context),
                SpaceDivider(),
                actionsCard(context)
              ],
            ))),
      ),
    );
  }

  Widget userDataCard() {
    return Container(
      height: 100,
      padding: EdgeInsets.all(customMargin),
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
      SettingsHeaderRow(text: "Mi información"),
      LinearDivider(),
      SettingsDataRow(title: "Registrado desde", data: "09/2021"),
      LinearDivider(),
      SettingsDataRow(title: "Tu inicio de mes", data: "01"),
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
      SettingsHeaderRow(text: "Acciones disponibles"),
      LinearDivider(),
      SettingsActionRow(
        text: "Cambiar contraseña",
        action: () => changePasswordDialog(context),
      ),
      LinearDivider(),
      SettingsActionRow(text: "Editar información", action: () => null),
      LinearDivider(),
      SettingsActionRow(
          text: "Borrar tus datos", action: () => confirmDeleteUserData()),
      LinearDivider(),
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

  Future<dynamic> changePasswordDialog(BuildContext context) {
    return showModalBottomSheet(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top),
        barrierColor: themeColor.withOpacity(0.65),
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(customBorderRadius),
              topRight: Radius.circular(customBorderRadius)),
        ),
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (context, setModalState) => Material(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 0,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(customBorderRadius),
                    topRight: Radius.circular(customBorderRadius)),
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(customMargin),
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
                              child: Text("Cambia tu contrseña",
                                  style: titleCardStyle(),
                                  textAlign: TextAlign.center)),
                          SpaceDivider(),
                          currentPasswordWidget(() => {
                                setModalState(() {
                                  currentPasswordHidePass =
                                      !currentPasswordHidePass;
                                })
                              }),
                          SpaceDivider(),
                          newPassword1Widget(() => {
                                setModalState(() {
                                  newPassword1HidePass = !newPassword1HidePass;
                                })
                              }),
                          SpaceDivider(),
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
                          SpaceDivider(),
                          BinancyButton(
                              context: context,
                              text: "Cambiar contraseña",
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

  Widget currentPasswordWidget(Function() onPressed) {
    return Container(
        height: buttonHeight,
        padding: EdgeInsets.only(left: customMargin, right: customMargin),
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
                    "Actual contraseña", BinancyIcons.key),
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
        padding: EdgeInsets.only(left: customMargin, right: customMargin),
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
                decoration:
                    customInputDecoration("Nueva contraseña", BinancyIcons.key),
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
        padding: EdgeInsets.only(left: customMargin, right: customMargin),
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
                    "Repite tu nueva contraseña", BinancyIcons.key),
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
          if (currentPasswordController.text != newPassword1Controller.text) {
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
                    context, "La nueva contraseña introducida no es válida", [
                  BinancyInfoDialogItem("Aceptar", () {
                    Navigator.pop(context);
                    newPassword1Focus.requestFocus();
                  })
                ]);
              }
            } else {
              BinancyInfoDialog(
                  context, "La nueva contraseña introducida no coincide", [
                BinancyInfoDialogItem("Aceptar", () {
                  Navigator.pop(context);
                  newPassword1Focus.requestFocus();
                })
              ]);
            }
          } else {
            BinancyInfoDialog(
                context,
                "Tu actual contraseña y la nueva que has introducido son las mismas",
                [
                  BinancyInfoDialogItem("Aceptar", () {
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
          BinancyInfoDialog(
              context, "La nueva contraseña no puede estar en blanco", [
            BinancyInfoDialogItem("Aceptar", () {
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
            "La contraseña que has introducido no es tu actual contraseña", [
          BinancyInfoDialogItem("Aceptar", () {
            Navigator.pop(context);
            currentPasswordFocus.requestFocus();
          })
        ]);
      }
    } else {
      BinancyInfoDialog(context, "Debes introducir tu contraseña", [
        BinancyInfoDialogItem("Aceptar", () {
          Navigator.pop(context);
          currentPasswordFocus.requestFocus();
        })
      ]);
    }
  }
}
