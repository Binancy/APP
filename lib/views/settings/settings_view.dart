import 'package:binancy/controllers/providers/plans_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:binancy/views/enroll/login_view.dart';
import 'package:binancy/views/premium/premium_plans_view.dart';
import 'package:binancy/views/settings/settings_user_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BinancyBackground(Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Ajustes",
          style: appBarStyle(),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
          margin: EdgeInsets.only(left: customMargin, right: customMargin),
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: BinancyIconHorizontal()),
                SliverToBoxAdapter(child: myDataCard(context)),
                SliverToBoxAdapter(child: SpaceDivider()),
                SliverToBoxAdapter(child: actionsCard(context)),
                SliverToBoxAdapter(child: SpaceDivider()),
                SliverToBoxAdapter(
                    child: BinancyButton(
                  context: context,
                  text: "Cerrar sesión",
                  action: () async {
                    BinancyInfoDialog(context,
                        "¿Estas seguro que quieres cerrar tu sesión?", [
                      BinancyInfoDialogItem(
                          "Cancelar", () => Navigator.pop(context)),
                      BinancyInfoDialogItem("Cerrar sesión", () {
                        Navigator.pop(context);
                        Utils.clearSecureStorage();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginView()),
                            (route) => false);
                      }),
                    ]);
                  },
                )),
                SliverToBoxAdapter(child: SpaceDivider()),
              ],
            ),
          )),
    ));
  }

  Widget myDataCard(BuildContext context) {
    List<Widget> widgetList = [
      SettingsHeaderRow(text: "Mis datos"),
      LinearDivider(),
      SettingsDataRow(title: "Nombre", data: userData['nameUser'] ?? "-"),
      LinearDivider(),
      SettingsDataRow(title: "Email", data: userData['email'] ?? "-"),
      LinearDivider(),
      SettingsDataRow(title: "Plan actual", data: userData['planTitle']),
      LinearDivider(),
      SettingsDataRow(title: "Versión de Binancy", data: appVersion)
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

  Widget actionsCard(BuildContext context) {
    List<Widget> widgetList = [
      SettingsHeaderRow(text: "Acciones"),
      LinearDivider(),
      SettingsActionRow(
          text: "Información de usuario",
          action: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => SettingsUserDataView()))),
      LinearDivider(),
      SettingsActionRow(text: "Notificaciones", action: () => null),
      LinearDivider(),
      SettingsActionRow(text: "Seguridad", action: () => null),
      LinearDivider(),
      Utils.currentPlanIsEqualOrLower(userData['idPlan'], "binancy")
          ? SettingsActionRow(
              text: "Cambiar de plan",
              action: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => MultiProvider(providers: [
                            ChangeNotifierProvider(
                                create: (_) =>
                                    Provider.of<PlansChangeNotifier>(context))
                          ], child: PremiumPlansView()))),
            )
          : SizedBox(),
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
            style: settingsHeaderTitleStyle(),
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
  const SettingsActionRow({Key? key, required this.text, required this.action})
      : super(key: key);

  final String text;
  final Function() action;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action,
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
