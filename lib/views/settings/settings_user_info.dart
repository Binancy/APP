import 'package:binancy/globals.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:binancy/views/settings/settings_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsUserDataView extends StatefulWidget {
  const SettingsUserDataView({Key? key}) : super(key: key);

  @override
  _SettingsUserDataViewState createState() => _SettingsUserDataViewState();
}

class _SettingsUserDataViewState extends State<SettingsUserDataView> {
  @override
  Widget build(BuildContext context) {
    return BinancyBackground(Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          title: Text("Tu información", style: appBarStyle())),
      body: Container(
        child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: ListView(
              padding: EdgeInsets.all(customMargin),
              children: [
                userDataCard(),
                SpaceDivider(),
                myDataCard(context),
                SpaceDivider(),
                actionsCard(context)
              ],
            )),
      ),
    ));
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
      SettingsActionRow(text: "Cambiar contraseña", action: () {}),
      LinearDivider(),
      SettingsActionRow(text: "Editar información", action: () => null),
      LinearDivider(),
      SettingsActionRow(text: "Borrar tus datos", action: () => null),
      LinearDivider(),
      SettingsActionRow(
        text: "Eliminar cuenta",
        action: () => null,
        isLast: true,
      ),
    ];

    return Container(
        decoration: BoxDecoration(
            color: themeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(customBorderRadius)),
        child: Column(
          children: widgetList,
        ));
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
}
