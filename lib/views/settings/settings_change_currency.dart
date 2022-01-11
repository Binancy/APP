import 'package:binancy/controllers/account_controller.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/dialogs/progress_dialog.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../globals.dart';

class SettingsChangeCurrencyView extends StatefulWidget {
  final Function() refreshParent;

  const SettingsChangeCurrencyView({Key? key, required this.refreshParent})
      : super(key: key);

  @override
  State<SettingsChangeCurrencyView> createState() =>
      _SettingsChangeCurrencyViewState();
}

class _SettingsChangeCurrencyViewState
    extends State<SettingsChangeCurrencyView> {
  String selectedCurrency = avaiableCurrencies.elementAt(userData['currency']);

  @override
  Widget build(BuildContext context) {
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
                        child: Text(
                            AppLocalizations.of(context)!.currency_header,
                            style: titleCardStyle())),
                    const SpaceDivider(),
                    BinancySelectorWidget(
                        hint: AppLocalizations.of(context)!.currency_header,
                        items: avaiableCurrencies,
                        selectedItem: selectedCurrency,
                        onChanged: (value) {
                          setState(() {
                            selectedCurrency = value;
                          });
                        }),
                    const SpaceDivider(),
                    BinancyButton(
                        context: context,
                        text: AppLocalizations.of(context)!
                            .currency_update_button,
                        action: () => checkData()),
                    SpaceDivider(
                        customSpace: MediaQuery.of(context).viewInsets.bottom)
                  ])),
        ));
  }

  void checkData() async {
    if (selectedCurrency !=
        avaiableCurrencies.elementAt(userData['currency'])) {
      BinancyProgressDialog progressDialog =
          BinancyProgressDialog(context: context);
      progressDialog.showProgressDialog();
      await AccountController.updateCurrency(
              avaiableCurrencies.indexOf(selectedCurrency))
          .then((success) {
        progressDialog.dismissDialog();
        if (success) {
          userData['currency'] = avaiableCurrencies.indexOf(selectedCurrency);
          currency = Utils.getCurrencyFromAvaiableCurrencyList();
          BinancyInfoDialog(
              context, AppLocalizations.of(context)!.currency_update_ok, [
            BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
              Navigator.pop(context);
              Navigator.pop(context);
            })
          ]);
        } else {
          BinancyInfoDialog(
              context, AppLocalizations.of(context)!.currency_update_ko, [
            BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
              Navigator.pop(context);
            })
          ]);
        }
      });
    } else {
      BinancyInfoDialog(
          context, AppLocalizations.of(context)!.currency_update_not_needed, [
        BinancyInfoDialogItem(AppLocalizations.of(context)!.close, () {
          Navigator.pop(context);
          Navigator.pop(context);
        }),
        BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
          Navigator.pop(context);
        })
      ]);
    }
  }
}
