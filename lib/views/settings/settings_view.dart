import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/controllers/providers/plans_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/dialogs/progress_dialog.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:binancy/views/advice/support_view.dart';
import 'package:binancy/views/enroll/login_view.dart';
import 'package:binancy/views/enroll/privacy_terms_view.dart';
import 'package:binancy/views/payments/premium_plans_view.dart';
import 'package:binancy/views/settings/settings_profile.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsView extends StatefulWidget {
  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return BinancyBackground(Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: appBarStyle(),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
          margin:
              const EdgeInsets.only(left: customMargin, right: customMargin),
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: BinancyIconHorizontal()),
                SliverToBoxAdapter(child: myDataCard(context)),
                const SliverToBoxAdapter(child: SpaceDivider()),
                SliverToBoxAdapter(
                    child: actionsCard(
                        context,
                        Provider.of<MovementsChangeNotifier>(context,
                            listen: false))),
                const SliverToBoxAdapter(child: SpaceDivider()),
                SliverToBoxAdapter(
                    child: BinancyButton(
                  context: context,
                  text: AppLocalizations.of(context)!.logout,
                  action: () async {
                    BinancyInfoDialog(
                        context, AppLocalizations.of(context)!.logout_confirm, [
                      BinancyInfoDialogItem(
                          AppLocalizations.of(context)!.cancel,
                          () => Navigator.pop(context)),
                      BinancyInfoDialogItem(
                          AppLocalizations.of(context)!.logout, () async {
                        Navigator.pop(context);
                        BinancyProgressDialog progressDialog =
                            BinancyProgressDialog(context: context)
                              ..showProgressDialog();
                        await Future.delayed(
                            const Duration(milliseconds: logoutMinTimeMS));
                        await Utils.clearSecureStorage();
                        userData.clear();
                        progressDialog.dismissDialog();
                        Navigator.pushAndRemoveUntil(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: LoginView()),
                            (route) => false);
                      }),
                    ]);
                  },
                )),
                const SliverToBoxAdapter(child: SpaceDivider()),
              ],
            ),
          )),
    ));
  }

  Widget myDataCard(BuildContext context) {
    List<Widget> widgetList = [
      BinancyHeaderRow(text: AppLocalizations.of(context)!.my_data),
      const LinearDivider(),
      BinancyDataRow(
          title: AppLocalizations.of(context)!.name,
          data: userData['nameUser'] ?? "-"),
      const LinearDivider(),
      BinancyDataRow(
          title: AppLocalizations.of(context)!.email,
          data: userData['email'] ?? "-"),
      const LinearDivider(),
      BinancyDataRow(
          title: AppLocalizations.of(context)!.current_plan,
          data: userData['planTitle']),
      const LinearDivider(),
      BinancyDataRow(
          title: AppLocalizations.of(context)!.version(appName),
          data: appVersion)
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

  Widget actionsCard(
      BuildContext context, MovementsChangeNotifier movementsChangeNotifier) {
    List<Widget> widgetList = [
      BinancyHeaderRow(text: AppLocalizations.of(context)!.actions),
      const LinearDivider(),
      BinancyActionRow(
          text: AppLocalizations.of(context)!.my_profile,
          action: () async => await Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeftWithFade,
                          child: const SettingsUserDataView()))
                  .then((value) async {
                if (value) {
                  BinancyProgressDialog binancyProgressDialog =
                      BinancyProgressDialog(context: context)
                        ..showProgressDialog();
                  await Utils.updateAllProviders(context);
                  binancyProgressDialog.dismissDialog();
                } else {
                  movementsChangeNotifier.updateMovements();
                }

                setState(() {});
              })),
      const LinearDivider(),
      BinancyActionRow(
          text: AppLocalizations.of(context)!.privacy_policy,
          action: () => Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeftWithFade,
                  child: const PrivacyAndTermsView()))),
      const LinearDivider(),
      BinancyActionRow(
          text: AppLocalizations.of(context)!.support,
          action: () => Navigator.push(
              context,
              PageTransition(
                  child: const SupportView(),
                  type: PageTransitionType.rightToLeftWithFade))),
      const LinearDivider(),
      Utils.showIfPlanIsEqualOrLower(userData['idPlan'], "binancy")
          ? BinancyActionRow(
              text: AppLocalizations.of(context)!.change_plan,
              action: () => Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeftWithFade,
                      child: MultiProvider(providers: [
                        ChangeNotifierProvider(
                            create: (_) => Provider.of<PlansChangeNotifier>(
                                context,
                                listen: false))
                      ], child: const PremiumPlansView()))),
            )
          : const SizedBox(),
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

class BinancyHeaderRow extends StatelessWidget {
  const BinancyHeaderRow({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: settingsRowHeight,
      padding: const EdgeInsets.only(left: customMargin, right: customMargin),
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

class BinancyDataRow extends StatelessWidget {
  const BinancyDataRow({
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
      padding: const EdgeInsets.only(left: customMargin, right: customMargin),
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

class BinancyActionRow extends StatelessWidget {
  const BinancyActionRow({Key? key, required this.text, required this.action})
      : super(key: key);

  final String text;
  final Function() action;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action,
        highlightColor: themeColor.withOpacity(0.1),
        splashColor: themeColor.withOpacity(0.1),
        child: Container(
          height: settingsRowHeight,
          padding:
              const EdgeInsets.only(left: customMargin, right: customMargin),
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
