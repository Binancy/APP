// ignore_for_file: no_logic_in_create_state

import 'package:binancy/controllers/providers/subscriptions_change_notifier.dart';
import 'package:binancy/controllers/subscriptions_controller.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/subscription.dart';
import 'package:binancy/utils/dialogs/daypicker_dialog.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/dialogs/progress_dialog.dart';
import 'package:binancy/utils/ui/icons.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:binancy/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SubscriptionView extends StatefulWidget {
  final bool allowEdit;
  final Subscription? selectedSubscription;
  const SubscriptionView({this.selectedSubscription, this.allowEdit = false});

  @override
  _SubscriptionViewState createState() =>
      _SubscriptionViewState(selectedSubscription, allowEdit);
}

class _SubscriptionViewState extends State<SubscriptionView> {
  Subscription? selectedSubscription;
  bool allowEdit = false, createMode = false;
  String payDay = "";

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode amountFocusNode = FocusNode();

  bool ignoreCheckoutThisMonth = false;

  _SubscriptionViewState(this.selectedSubscription, this.allowEdit);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    payDay = AppLocalizations.of(context)!.subscription_day;
    checkSubscription();
  }

  @override
  void dispose() {
    nameController.dispose();
    nameFocusNode.dispose();
    descriptionController.dispose();
    descriptionFocusNode.dispose();
    amountController.dispose();
    amountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (createMode) {
          BinancyInfoDialog(
              context, AppLocalizations.of(context)!.exit_confirm, [
            BinancyInfoDialogItem(AppLocalizations.of(context)!.cancel, () {
              Navigator.pop(context);
              return false;
            }),
            BinancyInfoDialogItem(AppLocalizations.of(context)!.abort, () {
              Navigator.pop(context);
              Navigator.pop(context);
              return true;
            })
          ]);
        } else if (allowEdit) {
          BinancyInfoDialog(
              context, AppLocalizations.of(context)!.exit_confirm, [
            BinancyInfoDialogItem(AppLocalizations.of(context)!.cancel, () {
              Navigator.pop(context);
              return false;
            }),
            BinancyInfoDialogItem(AppLocalizations.of(context)!.abort, () {
              Navigator.pop(context);
              allowEdit = false;
              setState(() {
                checkSubscription();
              });
              return true;
            })
          ]);
        }
        return true;
      },
      child: BinancyBackground(Consumer<SubscriptionsChangeNotifier>(
        builder: (context, subscriptionsProvider, child) => Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            elevation: 0,
            actions: [
              !createMode && !allowEdit
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          allowEdit = true;
                        });
                      },
                      icon: const Icon(BinancyIcons.edit))
                  : const SizedBox()
            ],
            leading: !allowEdit
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context))
                : createMode
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => BinancyInfoDialog(context,
                                AppLocalizations.of(context)!.exit_confirm, [
                              BinancyInfoDialogItem(
                                  AppLocalizations.of(context)!.cancel,
                                  () => Navigator.pop(context)),
                              BinancyInfoDialogItem(
                                  AppLocalizations.of(context)!.abort, () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              })
                            ]))
                    : IconButton(
                        icon: const Icon(Icons.close_outlined),
                        onPressed: () => BinancyInfoDialog(context,
                            AppLocalizations.of(context)!.exit_confirm, [
                          BinancyInfoDialogItem(
                              AppLocalizations.of(context)!.cancel,
                              () => Navigator.pop(context)),
                          BinancyInfoDialogItem(
                              AppLocalizations.of(context)!.abort, () {
                            Navigator.pop(context);
                            setState(() {
                              checkSubscription();
                              allowEdit = false;
                            });
                          })
                        ]),
                      ),
          ),
          body: Column(
            children: [
              Expanded(
                  child: ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: ListView(
                        children: [
                          Container(
                            height: 125,
                            padding: const EdgeInsets.all(customMargin),
                            alignment: Alignment.center,
                            child: Text(
                                createMode
                                    ? AppLocalizations.of(context)!
                                        .add_subscription_header
                                    : selectedSubscription!.name,
                                style: headerItemView(),
                                textAlign: TextAlign.center),
                          ),
                          nameInputWidget(),
                          const SpaceDivider(),
                          amountInputWidget(),
                          const SpaceDivider(),
                          datePicker(context),
                          const SpaceDivider(),
                          createMode
                              ? ignoreCheckoutWidget()
                              : const SizedBox(),
                          createMode ? const SpaceDivider() : const SizedBox(),
                          descriptionInputWidget(),
                          const SpaceDivider(),
                        ],
                      ))),
              allowEdit ? const SpaceDivider() : const SizedBox(),
              allowEdit
                  ? Padding(
                      padding: const EdgeInsets.only(
                          left: customMargin, right: customMargin),
                      child: BinancyButton(
                          context: context,
                          text: createMode
                              ? AppLocalizations.of(context)!.add_subscription
                              : AppLocalizations.of(context)!
                                  .update_subscription,
                          action: () async {
                            await checkData(subscriptionsProvider);
                          }),
                    )
                  : const SizedBox(),
              const SpaceDivider(),
            ],
          ),
        ),
      )),
    );
  }

  void checkSubscription() {
    if (selectedSubscription != null) {
      createMode = false;
      nameController.text = selectedSubscription!.name;
      amountController.text = selectedSubscription!.value.toString();
      payDay = selectedSubscription!.payDay.toString();
      if (selectedSubscription!.description != null) {
        descriptionController.text = selectedSubscription!.description!;
      }
    } else {
      createMode = true;
      allowEdit = true;
    }
  }

  Widget nameInputWidget() {
    return Container(
      margin: const EdgeInsets.only(left: customMargin, right: customMargin),
      height: buttonHeight,
      padding: const EdgeInsets.only(left: customMargin, right: customMargin),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(customBorderRadius),
          color: themeColor.withOpacity(0.1)),
      alignment: Alignment.center,
      child: TextField(
        focusNode: nameFocusNode,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.next,
        readOnly: !allowEdit,
        keyboardType: TextInputType.name,
        controller: nameController,
        style: inputStyle(),
        decoration: customInputDecoration(
            AppLocalizations.of(context)!.subscription_title, BinancyIcons.tag),
      ),
    );
  }

  Widget amountInputWidget() {
    return Container(
      margin: const EdgeInsets.only(left: customMargin, right: customMargin),
      height: buttonHeight,
      padding: const EdgeInsets.only(left: customMargin, right: customMargin),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(customBorderRadius),
          color: themeColor.withOpacity(0.1)),
      alignment: Alignment.center,
      child: TextField(
        focusNode: amountFocusNode,
        inputFormatters: [
          DecimalTextInputFormatter(decimalRange: 2, currency: currency)
        ],
        textInputAction: TextInputAction.next,
        readOnly: !allowEdit,
        keyboardType: TextInputType.number,
        controller: amountController,
        style: inputStyle(),
        decoration: customInputDecoration(
            AppLocalizations.of(context)!.subscription_amount,
            BinancyIcons.piggy_bank),
      ),
    );
  }

  Widget descriptionInputWidget() {
    return Container(
      height: descriptionWidgetHeight,
      margin: const EdgeInsets.only(left: customMargin, right: customMargin),
      decoration: BoxDecoration(
          color: themeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(customBorderRadius)),
      padding: const EdgeInsets.all(customMargin),
      child: TextField(
        focusNode: descriptionFocusNode,
        textCapitalization: TextCapitalization.sentences,
        controller: descriptionController,
        readOnly: !allowEdit,
        expands: true,
        decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            counterStyle: detailStyle(),
            hintText: AppLocalizations.of(context)!.subscription_description,
            hintStyle: inputStyle()),
        style: inputStyle(),
        maxLength: 300,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        minLines: null,
      ),
    );
  }

  Widget datePicker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: customMargin, right: customMargin),
      child: Material(
        color: themeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(customBorderRadius),
        child: InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            if (allowEdit) {
              BinancyDayPickerDialog binancyDayPickerDialog =
                  BinancyDayPickerDialog(
                      context: context,
                      initialDate: int.tryParse(payDay),
                      title: AppLocalizations.of(context)!.subscription_day);
              binancyDayPickerDialog.showDayPickerDialog().then((value) {
                if (value != null) {
                  setState(() {
                    payDay = value.toString();
                  });
                }
              });
            }
          },
          borderRadius: BorderRadius.circular(customBorderRadius),
          highlightColor: themeColor.withOpacity(0.1),
          splashColor: themeColor.withOpacity(0.1),
          child: Container(
              height: buttonHeight,
              padding: const EdgeInsets.only(
                  left: customMargin, right: customMargin),
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
                  Text(payDay, style: inputStyle())
                ],
              )),
        ),
      ),
    );
  }

  Widget ignoreCheckoutWidget() {
    return Padding(
        padding: const EdgeInsets.only(left: customMargin, right: customMargin),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
                checkColor: accentColor,
                value: ignoreCheckoutThisMonth,
                onChanged: (value) {
                  allowEdit
                      ? setState(() {
                          ignoreCheckoutThisMonth = !ignoreCheckoutThisMonth;
                        })
                      : null;
                }),
            GestureDetector(
                onTap: () => setState(() {
                      ignoreCheckoutThisMonth = !ignoreCheckoutThisMonth;
                    }),
                child: Text(
                    AppLocalizations.of(context)!
                        .subscription_ignore_this_month,
                    style: inputStyle())),
            IconButton(
                onPressed: () => BinancyInfoDialog(
                        context,
                        AppLocalizations.of(context)!
                            .subscription_renew_description(appName),
                        [
                          BinancyInfoDialogItem(
                              AppLocalizations.of(context)!.accept,
                              () => Navigator.pop(context))
                        ]),
                icon: Icon(Icons.help_outline_rounded, color: accentColor))
          ],
        ));
  }

  Future<void> checkData(
      SubscriptionsChangeNotifier subscriptionsProvider) async {
    nameFocusNode.unfocus();
    descriptionFocusNode.unfocus();
    amountFocusNode.unfocus();
    FocusScope.of(context).unfocus();

    if (nameController.text.isNotEmpty) {
      if (amountController.text.isNotEmpty) {
        if (int.tryParse(payDay) != null) {
          if (createMode) {
            await insertSubscription(subscriptionsProvider);
          } else {
            await updateSubscription(subscriptionsProvider);
          }
        } else {
          BinancyInfoDialog(
              context, AppLocalizations.of(context)!.subscription_invalid_day, [
            BinancyInfoDialogItem(AppLocalizations.of(context)!.accept,
                () => Navigator.pop(context))
          ]);
        }
      } else {
        BinancyInfoDialog(context,
            AppLocalizations.of(context)!.subscription_invalid_amount, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept,
              () => Navigator.pop(context))
        ]);
      }
    } else {
      BinancyInfoDialog(
          context, AppLocalizations.of(context)!.subscription_invalid_title, [
        BinancyInfoDialogItem(
            AppLocalizations.of(context)!.accept, () => Navigator.pop(context))
      ]);
    }
  }

  Future<void> insertSubscription(
      SubscriptionsChangeNotifier subscriptionsProvider) async {
    Subscription subscription = Subscription()
      ..name = nameController.text
      ..idUser = userData['idUser']
      ..value = double.parse(amountController.text)
      ..payDay = int.parse(payDay)
      ..latestMonth = ignoreCheckoutThisMonth
          ? Utils.thisMonthEnun(Utils.getTodayDate())
          : Month.NONE
      ..description = descriptionController.text;

    BinancyProgressDialog binancyProgressDialog =
        BinancyProgressDialog(context: context)..showProgressDialog();
    await SubscriptionsController.addSubscription(subscription)
        .then((value) async {
      if (value) {
        await subscriptionsProvider.updateSubscriptions();
        binancyProgressDialog.dismissDialog();
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.subscription_add_success, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
            leaveScreen();
          })
        ]);
      } else {
        binancyProgressDialog.dismissDialog();
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.subscription_add_fail, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
            Navigator.pop(context);
          })
        ]);
      }
    });
  }

  Future<void> updateSubscription(
      SubscriptionsChangeNotifier subscriptionsProvider) async {
    Subscription subscription = Subscription()
      ..name = nameController.text
      ..idUser = userData['idUser']
      ..value = double.parse(amountController.text)
      ..payDay = int.parse(payDay)
      ..idSubscription = selectedSubscription!.idSubscription
      ..latestMonth = selectedSubscription!.latestMonth
      ..description = descriptionController.text;

    BinancyProgressDialog binancyProgressDialog =
        BinancyProgressDialog(context: context)..showProgressDialog();
    await SubscriptionsController.updateSubscription(subscription)
        .then((value) async {
      if (value) {
        await subscriptionsProvider.updateSubscriptions();
        binancyProgressDialog.dismissDialog();
        BinancyInfoDialog(context,
            AppLocalizations.of(context)!.subscription_update_success, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
            setState(() {
              selectedSubscription = subscription;
              allowEdit = false;
            });
            Navigator.pop(context);
          })
        ]);
      } else {
        binancyProgressDialog.dismissDialog();
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.subscription_update_fail, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
            Navigator.pop(context);
          })
        ]);
      }
    });
  }

  void leaveScreen() {
    nameFocusNode.unfocus();
    descriptionFocusNode.unfocus();
    amountFocusNode.unfocus();
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
