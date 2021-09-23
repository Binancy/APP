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
  String payDay = "Día de renovación";

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  _SubscriptionViewState(this.selectedSubscription, this.allowEdit);

  @override
  void initState() {
    super.initState();
    checkSubscription();
  }

  @override
  Widget build(BuildContext context) {
    return BinancyBackground(Consumer<SubscriptionsChangeNotifier>(
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
                    icon: const Icon(Icons.more_horiz_rounded))
                : const SizedBox()
          ],
          leading: !allowEdit
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context))
              : createMode
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => BinancyInfoDialog(
                              context, "¿Estas seguro que quieres salir?", [
                            BinancyInfoDialogItem(
                                "Cancelar", () => Navigator.pop(context)),
                            BinancyInfoDialogItem("Abortar", () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            })
                          ]))
                  : IconButton(
                      icon: const Icon(Icons.close_outlined),
                      onPressed: () => BinancyInfoDialog(
                          context, "Estas seguro que quieres salir?", [
                        BinancyInfoDialogItem(
                            "Canelar", () => Navigator.pop(context)),
                        BinancyInfoDialogItem("Abortar", () {
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
                                  ? "Añade una nueva suscripción"
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
                        descriptionInputWidget(),
                        const SpaceDivider()
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
                            ? "Añadir suscripción"
                            : "Actualizar suscripción",
                        action: () async {
                          await checkData(subscriptionsProvider);
                        }),
                  )
                : const SizedBox(),
            const SpaceDivider(),
          ],
        ),
      ),
    ));
  }

  void checkSubscription() {
    if (selectedSubscription != null) {
      createMode = false;
      nameController.text = selectedSubscription!.name;
      amountController.text =
          (selectedSubscription!.value as double).toStringAsFixed(2);
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
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.next,
        readOnly: !allowEdit,
        keyboardType: TextInputType.name,
        controller: nameController,
        style: inputStyle(),
        decoration: customInputDecoration(
            "Título de la suscripción", BinancyIcons.email),
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
        inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
        textInputAction: TextInputAction.next,
        readOnly: !allowEdit,
        keyboardType: TextInputType.number,
        controller: amountController,
        style: inputStyle(),
        decoration: customInputDecoration(
            "Importe de la suscripción", BinancyIcons.calendar),
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
            hintText: "Añade una descripción a esta suscripción",
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
                      title: "Selecciona el día de renovación");
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

  Future<void> checkData(
      SubscriptionsChangeNotifier subscriptionsProvider) async {
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
              context,
              "El día de renovación no es válido o esta en blanco",
              [BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))]);
        }
      } else {
        BinancyInfoDialog(context, "Debes introducir un valor a la suscripción",
            [BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))]);
      }
    } else {
      BinancyInfoDialog(context, "Debes introducir un titulo a la suscripción",
          [BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))]);
    }
  }

  Future<void> insertSubscription(
      SubscriptionsChangeNotifier subscriptionsProvider) async {
    Subscription subscription = Subscription()
      ..name = nameController.text
      ..idUser = userData['idUser']
      ..value = int.parse(amountController.text)
      ..payDay = int.parse(payDay)
      ..latestMonth = Month.NONE
      ..description = descriptionController.text;

    BinancyProgressDialog binancyProgressDialog =
        BinancyProgressDialog(context: context)..showProgressDialog();
    await SubscriptionsController.addSubscription(subscription).then((value) {
      binancyProgressDialog.dismissDialog();
      if (value) {
        BinancyInfoDialog(context, "Suscripción añadida correctamente!", [
          BinancyInfoDialogItem("Aceptar", () async {
            await subscriptionsProvider.updateSubscriptions();
            leaveScreen();
          })
        ]);
      } else {
        BinancyInfoDialog(context, "Error al añadir la suscripción...", [
          BinancyInfoDialogItem("Aceptar", () {
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
      ..value = int.parse(amountController.text)
      ..payDay = int.parse(payDay)
      ..idSubscription = selectedSubscription!.idSubscription
      ..latestMonth = selectedSubscription!.latestMonth
      ..description = descriptionController.text;

    BinancyProgressDialog binancyProgressDialog =
        BinancyProgressDialog(context: context)..showProgressDialog();
    await SubscriptionsController.updateSubscription(subscription)
        .then((value) {
      binancyProgressDialog.dismissDialog();
      if (value) {
        BinancyInfoDialog(context, "Suscripción actualizada correctamente!", [
          BinancyInfoDialogItem("Aceptar", () async {
            await subscriptionsProvider.updateSubscriptions();
            setState(() {
              selectedSubscription = subscription;
              allowEdit = false;
            });
            Navigator.pop(context);
          })
        ]);
      } else {
        BinancyInfoDialog(context, "Error al actualizar la suscripción...", [
          BinancyInfoDialogItem("Aceptar", () {
            Navigator.pop(context);
          })
        ]);
      }
    });
  }

  void leaveScreen() {
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
