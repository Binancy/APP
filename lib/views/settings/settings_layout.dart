import 'package:binancy/globals.dart';
import 'package:binancy/utils/styles.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  double _rowHeight = 65;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Ajustes",
            style: appBarStyle(),
          ),
          centerTitle: true,
          elevation: 0,
          brightness: Brightness.dark,
        ),
        body: Container(
            child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView(
            padding: EdgeInsets.fromLTRB(
                customMargin, customMargin, customMargin, 0),
            children: [
              myDataCard(),
              SpaceDivider(),
              actionsCard(),
              SpaceDivider(),
              logoutButton()
            ],
          ),
        )),
      ),
    );
  }

  Widget myDataCard() {
    List<Widget> widgetList = [
      SettingsHeaderRow(text: "Mis datos"),
      LinearDivider(),
      SettingsDataRow(title: "Nombre", data: "John Doe"),
      LinearDivider(),
      SettingsDataRow(title: "Email", data: "john.doe@gmail.com"),
      LinearDivider(),
      SettingsDataRow(title: "Plan actual", data: "Free"),
      LinearDivider(),
      SettingsDataRow(title: "Versión de Binancy", data: "1.184.25.1")
    ];

    return Container(
        decoration: BoxDecoration(
            color: themeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(customBorderRadius)),
        child: Column(
          children: widgetList,
        ));
  }

  Widget actionsCard() {
    List<Widget> widgetList = [
      SettingsHeaderRow(text: "Acciones"),
      LinearDivider(),
      SettingsActionRow(text: "Notificaciones", action: () => null),
      LinearDivider(),
      SettingsActionRow(text: "Seguridad", action: () => null),
      LinearDivider(),
      SettingsActionRow(text: "Información de usuario", action: () => null),
      LinearDivider(),
      SettingsActionRow(
        text: "Cambiar de plan",
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

  Widget logoutButton() {
    return Material(
      color: themeColor.withOpacity(0.1),
      elevation: 0,
      borderRadius: BorderRadius.circular(customBorderRadius),
      child: InkWell(
        onTap: () {},
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(customBorderRadius),
        splashColor: themeColor.withOpacity(0.1),
        child: Container(
          height: buttonHeight,
          child: Center(
            child: Text(
              "Cerrar sesión",
              style: buttonStyle(),
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsHeaderRow extends StatelessWidget {
  const SettingsHeaderRow({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: settingsRowHeight,
      padding: EdgeInsets.only(left: customMargin, right: customMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: titleCardStyle(),
          )
        ],
      ),
    );
  }
}

class SettingsDataRow extends StatelessWidget {
  const SettingsDataRow({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);

  final String title;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: settingsRowHeight,
      padding: EdgeInsets.only(left: customMargin, right: customMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: settingsKeyStyle(),
          ),
          Text(
            data,
            style: settingsValueStyle(),
          )
        ],
      ),
    );
  }
}

class SettingsActionRow extends StatelessWidget {
  const SettingsActionRow(
      {Key? key, required this.text, required this.action, this.isLast = false})
      : super(key: key);

  final String text;
  final Function() action;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action,
        borderRadius: isLast
            ? BorderRadius.only(
                bottomLeft: Radius.circular(customBorderRadius),
                bottomRight: Radius.circular(customBorderRadius))
            : BorderRadius.zero,
        highlightColor: Colors.transparent,
        splashColor: themeColor.withOpacity(0.1),
        child: Container(
          height: settingsRowHeight,
          padding: EdgeInsets.only(left: customMargin, right: customMargin),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text,
                style: settingsKeyStyle(),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: accentColor,
                size: 18,
              )
            ],
          ),
        ),
      ),
    );
  }
}
