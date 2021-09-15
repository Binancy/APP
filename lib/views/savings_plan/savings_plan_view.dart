import 'package:binancy/controllers/providers/savings_plans_change_notifier.dart';
import 'package:binancy/controllers/savings_plan_controller.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/savings_plan.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/ui/icons.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SavingsPlanView extends StatefulWidget {
  final SavingsPlan? selectedSavingsPlan;
  final bool allowEdit;

  const SavingsPlanView({this.allowEdit = false, this.selectedSavingsPlan});

  @override
  _SavingsPlanViewState createState() =>
      // ignore: no_logic_in_create_state
      _SavingsPlanViewState(selectedSavingsPlan, allowEdit);
}

class _SavingsPlanViewState extends State<SavingsPlanView> {
  SavingsPlan? selectedSavingsPlan;
  bool allowEdit = false, createMode = false;
  String parsedDate = "Fecha límite";

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();

  _SavingsPlanViewState(this.selectedSavingsPlan, this.allowEdit);

  @override
  Widget build(BuildContext context) {
    checkSavingsPlan();
    return BinancyBackground(Consumer<SavingsPlanChangeNotifier>(
        builder: (context, savingsPlanProvider, child) => Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
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
                            onPressed: () => BinancyInfoDialog(context,
                                    "¿Estas seguro que quieres salir?", [
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
                                          ? "Añade una meta de ingresos"
                                          : selectedSavingsPlan!.name,
                                      style: headerItemView(),
                                      textAlign: TextAlign.center)),
                              nameInputWidget(),
                              const SpaceDivider(),
                              amountInputWidget(),
                              const SpaceDivider(),
                              datePicker(context),
                              const SpaceDivider(),
                              descriptionInputWidget(),
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
                                  ? "Añadir meta de ahorro"
                                  : "Actualizar meta de ahorro",
                              action: () async {
                                await checkData(savingsPlanProvider);
                              }),
                        )
                      : const SizedBox(),
                  const SpaceDivider(),
                ],
              ),
            )));
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
        decoration:
            customInputDecoration("Título de la meta", BinancyIcons.email),
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
        controller: totalAmountController,
        style: inputStyle(),
        decoration:
            customInputDecoration("Cantidad a ahorrar", BinancyIcons.calendar),
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
            hintText: "Añade una descripción a esta meta",
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
              showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1970),
                      lastDate: DateTime(DateTime.now().year + 1))
                  .then((value) {
                setState(() {
                  parsedDate = DateFormat.yMd(
                          Localizations.localeOf(context).toLanguageTag())
                      .format(value!);
                });
              });
            }
          },
          borderRadius: BorderRadius.circular(customBorderRadius),
          highlightColor: Colors.transparent,
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
                  Text(parsedDate, style: inputStyle())
                ],
              )),
        ),
      ),
    );
  }

  void checkSavingsPlan() {
    if (selectedSavingsPlan != null) {
      createMode = false;
      nameController.text = selectedSavingsPlan!.name;
      totalAmountController.text = selectedSavingsPlan!.amount.toString();
      if (selectedSavingsPlan!.limitDate != null) {
        parsedDate = Utils.toYMD(
            selectedSavingsPlan!.limitDate ?? DateTime.now(), context);
      }

      if (selectedSavingsPlan!.description != null) {
        descriptionController.text = selectedSavingsPlan!.description!;
      }
    } else {
      createMode = true;
      allowEdit = true;
    }
  }

  Future<void> checkData(
      SavingsPlanChangeNotifier savingsPlanChangeNotifier) async {
    if (nameController.text.isNotEmpty) {
      if (totalAmountController.text.isNotEmpty) {
        if (createMode) {
          await insertSavingsPlan(savingsPlanChangeNotifier);
        } else {
          await updateSavingsPlan(savingsPlanChangeNotifier);
        }
      } else {
        BinancyInfoDialog(
            context,
            "La meta de ahorros debe tener un valor objetivo",
            [BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))]);
      }
    } else {
      BinancyInfoDialog(context, "Debes introducir un titulo a la meta",
          [BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))]);
    }
  }

  Future<void> insertSavingsPlan(
      SavingsPlanChangeNotifier savingsPlanChangeNotifier) async {
    SavingsPlan savingsPlan = SavingsPlan()
      ..name = nameController.text
      ..description = descriptionController.text
      ..amount = double.parse(totalAmountController.text)
      ..idUser = userData['idUser']
      ..limitDate = Utils.isValidDateYMD(parsedDate, context)
          ? Utils.fromYMD(parsedDate, context)
          : null;

    await SavingsPlansController.addSavingsPlan(savingsPlan).then((value) {
      if (value) {
        BinancyInfoDialog(context, "Meta de ahorro añadida correctamente!", [
          BinancyInfoDialogItem("Aceptar", () async {
            await savingsPlanChangeNotifier.updateSavingsPlan();
            leaveScreen();
          })
        ]);
      } else {
        BinancyInfoDialog(context, "Error al añadir la meta de ahorro...", [
          BinancyInfoDialogItem("Aceptar", () {
            Navigator.pop(context);
          })
        ]);
      }
    });
  }

  Future<void> updateSavingsPlan(
      SavingsPlanChangeNotifier savingsPlanChangeNotifier) async {
    SavingsPlan savingsPlan = SavingsPlan()
      ..name = nameController.text
      ..description = descriptionController.text
      ..amount = double.parse(totalAmountController.text)
      ..idUser = userData['idUser']
      ..idSavingsPlan = selectedSavingsPlan!.idSavingsPlan
      ..limitDate = Utils.isValidDateYMD(parsedDate, context)
          ? Utils.fromYMD(parsedDate, context)
          : null;

    await SavingsPlansController.updateSavingsPlan(savingsPlan).then((value) {
      if (value) {
        BinancyInfoDialog(
            context, "Meta de ahorro actualizada correctamente!", [
          BinancyInfoDialogItem("Aceptar", () async {
            await savingsPlanChangeNotifier.updateSavingsPlan();
            setState(() {
              selectedSavingsPlan = savingsPlan;
              allowEdit = false;
            });
            Navigator.pop(context);
          })
        ]);
      } else {
        BinancyInfoDialog(context, "Error al actualizar la meta de ahorro...", [
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
