import 'dart:ui';
import 'package:binancy/controllers/account_controller.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/utils/dialogs/daypicker_dialog.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/dialogs/progress_dialog.dart';
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsUserDataView extends StatefulWidget {
  const SettingsUserDataView({Key? key}) : super(key: key);

  @override
  _SettingsUserDataViewState createState() => _SettingsUserDataViewState();
}

class _SettingsUserDataViewState extends State<SettingsUserDataView> {
  bool needsFullRefresh = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, needsFullRefresh);
        return false;
      },
      child: BinancyBackground(
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(AppLocalizations.of(context)!.my_profile,
                  style: appBarStyle())),
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
          // profilePicWidget(),
        ],
      ),
    );
  }

  Widget myDataCard(BuildContext context) {
    List<Widget> widgetList = [
      BinancyHeaderRow(text: AppLocalizations.of(context)!.my_data),
      const LinearDivider(),
      BinancyDataRow(
          title: AppLocalizations.of(context)!.registered_since,
          data: Utils.toYMD(
              Utils.fromISOStandard(userData['registerDate']), context)),
      const LinearDivider(),
      BinancyDataRow(
          title: AppLocalizations.of(context)!.birthday,
          data: userData['birthday'] != null
              ? Utils.toYMD(
                  Utils.fromISOStandard(userData['birthday']), context)
              : AppLocalizations.of(context)!.no_data),
      const LinearDivider(),
      BinancyDataRow(
          title: AppLocalizations.of(context)!.first_of_month,
          data: userData['payDay'].toString()),
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
      BinancyHeaderRow(text: AppLocalizations.of(context)!.actions),
      const LinearDivider(),
      BinancyActionRow(
          text: AppLocalizations.of(context)!.edit_profile,
          action: () => editUserInfo(context)),
      const LinearDivider(),
      BinancyActionRow(
          text: AppLocalizations.of(context)!.change_first_of_month,
          action: () {
            BinancyDayPickerDialog binancyDayPickerDialog =
                BinancyDayPickerDialog(
                    context: context,
                    title: AppLocalizations.of(context)!
                        .change_first_of_month_header,
                    initialDate: userData['payDay']);
            binancyDayPickerDialog.showDayPickerDialog().then((selectedDay) {
              if (selectedDay != null) {
                BinancyProgressDialog binancyProgressDialog =
                    BinancyProgressDialog(context: context)
                      ..showProgressDialog();
                AccountController.updatePayDay(selectedDay).then((value) {
                  binancyProgressDialog.dismissDialog();
                  if (value) {
                    userData['payDay'] = selectedDay;
                    setState(() {});
                    BinancyInfoDialog(context,
                        AppLocalizations.of(context)!.payday_change_success, [
                      BinancyInfoDialogItem(
                          AppLocalizations.of(context)!.accept,
                          () => Navigator.pop(context))
                    ]);
                  } else {
                    BinancyInfoDialog(context,
                        AppLocalizations.of(context)!.payday_change_fail, [
                      BinancyInfoDialogItem(
                          AppLocalizations.of(context)!.accept,
                          () => Navigator.pop(context))
                    ]);
                  }
                });
              }
            });
          }),
      const LinearDivider(),
      BinancyActionRow(
        text: AppLocalizations.of(context)!.change_password,
        action: () => SettingsChangePassword(context: context),
      ),
      const LinearDivider(),
      BinancyActionRow(
          text: AppLocalizations.of(context)!.delete_data,
          action: () => confirmDeleteUserData()),
      const LinearDivider(),
      BinancyActionRow(
        text: AppLocalizations.of(context)!.delete_account,
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
              "https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg"),
        ),
        onTap:
            () {} /* () => showCupertinoModalPopup(
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
                )) */
        );
  }

  void confirmDeleteUserData({bool skipVerification = false}) {
    if (!skipVerification) {
      BinancyInfoDialog(
          context,
          AppLocalizations.of(context)!
              .delete_data_description(appName, organizationName),
          [
            BinancyInfoDialogItem(AppLocalizations.of(context)!.cancel,
                () => Navigator.pop(context)),
            BinancyInfoDialogItem(AppLocalizations.of(context)!.delete_data,
                () {
              Navigator.pop(context);
              AccountController.deleteUserData(context).then((value) {
                if (!needsFullRefresh) {
                  needsFullRefresh = value;
                }
              });
            })
          ]);
    } else {
      AccountController.deleteUserData(context).then((value) {
        if (!needsFullRefresh) {
          needsFullRefresh = value;
        }
      });
    }
  }

  void confirmDeleteAccount() {
    BinancyInfoDialog(
        context,
        AppLocalizations.of(context)!
            .delete_account_description(appName, organizationName),
        [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.cancel,
              () => Navigator.pop(context)),
          BinancyInfoDialogItem(
              AppLocalizations.of(context)!.only_appName(appName), () {
            Navigator.pop(context);

            confirmDeleteUserData(skipVerification: true);
          }),
          BinancyInfoDialogItem(AppLocalizations.of(context)!.delete_account,
              () {
            Navigator.pop(context);
            AccountController.deleteAccount(context);
          })
        ]);
  }
}
