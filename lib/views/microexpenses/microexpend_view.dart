import 'package:binancy/controllers/expenses_controller.dart';
import 'package:binancy/controllers/microexpenses_controller.dart';
import 'package:binancy/controllers/providers/microexpenses_change_notifier.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/expend.dart';
import 'package:binancy/models/microexpend.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/ui/icons.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MicroExpendView extends StatefulWidget {
  final MicroExpend? selectedMicroExpend;
  final bool allowEdit;

  const MicroExpendView(
      {Key? key, this.allowEdit = false, this.selectedMicroExpend})
      : super(key: key);

  @override
  _MicroExpendViewState createState() =>
      // ignore: no_logic_in_create_state
      _MicroExpendViewState(selectedMicroExpend, allowEdit);
}

class _MicroExpendViewState extends State<MicroExpendView> {
  MicroExpend? selectedMicroExpend;
  bool allowEdit = false, createMode = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  _MicroExpendViewState(this.selectedMicroExpend, this.allowEdit);

  @override
  Widget build(BuildContext context) {
    checkMicroExpend();
    return BinancyBackground(Consumer<MicroExpensesChangeNotifier>(
        builder: (context, microExpensesProvider, child) => Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                backgroundColor: Colors.transparent,
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
                                      ? "Añade un gasto frecuente"
                                      : selectedMicroExpend!.title,
                                  style: headerItemView(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              titleInputWidget(),
                              const SpaceDivider(),
                              amountInputWidget(),
                              const SpaceDivider(),
                              descriptionInputWidget(),
                            ],
                          ))),
                  allowEdit ? const SpaceDivider() : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: customMargin, right: customMargin),
                    child: !createMode && !allowEdit
                        ? BinancyButton(
                            context: context,
                            text: "Añadir gasto",
                            action: () async => await addExpend(context))
                        : allowEdit
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: customMargin, right: customMargin),
                                child: BinancyButton(
                                    context: context,
                                    text: createMode
                                        ? "Añadir gasto frecuente"
                                        : "Actualizar gasto frecuente",
                                    action: () async {
                                      await checkData(microExpensesProvider);
                                    }),
                              )
                            : const SizedBox(),
                  ),
                  const SpaceDivider()
                ],
              ),
            )));
  }

  Widget titleInputWidget() {
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
        controller: titleController,
        style: inputStyle(),
        decoration: customInputDecoration(
            "Título del gasto frecuente", BinancyIcons.email),
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
        decoration:
            customInputDecoration("Importe del gasto", BinancyIcons.calendar),
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
            hintText: "Añade una descripción a este gasto frecuente",
            hintMaxLines: 3,
            hintStyle: inputStyle()),
        style: inputStyle(),
        maxLength: 300,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        minLines: null,
      ),
    );
  }

  void checkMicroExpend() {
    if (selectedMicroExpend != null) {
      createMode = false;
      titleController.text = selectedMicroExpend!.title;
      amountController.text =
          Utils.parseAmount(selectedMicroExpend!.amount, addCurreny: false);

      if (selectedMicroExpend!.description != null) {
        descriptionController.text = selectedMicroExpend!.description!;
      }
    } else {
      createMode = true;
      allowEdit = true;
    }
  }

  Future<void> checkData(
      MicroExpensesChangeNotifier microExpensesProvider) async {
    if (titleController.text.isNotEmpty) {
      if (amountController.text.isNotEmpty) {
        if (createMode) {
          await insertMicroExpend(microExpensesProvider);
        } else {
          await updateMicroExpend(microExpensesProvider);
        }
      } else {
        BinancyInfoDialog(context, "El gasto frecuente debe tener un importe",
            [BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))]);
      }
    } else {
      BinancyInfoDialog(
          context,
          "Debes introducir un titulo al gasto frecuente",
          [BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))]);
    }
  }

  Future<void> insertMicroExpend(
      MicroExpensesChangeNotifier microExpensesProvider) async {
    MicroExpend microExpend = MicroExpend()
      ..title = titleController.text
      ..amount = double.parse(amountController.text)
      ..idUser = userData['idUser']
      ..description = descriptionController.text;

    await MicroExpensesController.addMicroExpend(microExpend).then((value) {
      if (value) {
        BinancyInfoDialog(context, "Gasto frecuente añadido correctamente!", [
          BinancyInfoDialogItem("Aceptar", () async {
            await microExpensesProvider.updateMicroExpenses();
            leaveScreen();
          })
        ]);
      } else {
        BinancyInfoDialog(context, "Error al añadir el gasto frecuente...", [
          BinancyInfoDialogItem("Aceptar", () {
            Navigator.pop(context);
          })
        ]);
      }
    });
  }

  Future<void> updateMicroExpend(
      MicroExpensesChangeNotifier microExpensesProvider) async {
    MicroExpend microExpend = MicroExpend()
      ..title = titleController.text
      ..amount = double.parse(amountController.text)
      ..idUser = userData['idUser']
      ..idMicroExpend = selectedMicroExpend!.idMicroExpend
      ..description = descriptionController.text;

    await MicroExpensesController.updateMicroExpend(microExpend).then((value) {
      if (value) {
        BinancyInfoDialog(
            context, "Gasto frecuente actualizado correctamente!", [
          BinancyInfoDialogItem("Aceptar", () async {
            await microExpensesProvider.updateMicroExpenses();
            setState(() {
              selectedMicroExpend = microExpend;
              allowEdit = false;
            });
            Navigator.pop(context);
          })
        ]);
      } else {
        BinancyInfoDialog(
            context, "Error al actualizar el gasto frecuente...", [
          BinancyInfoDialogItem("Aceptar", () {
            Navigator.pop(context);
          })
        ]);
      }
    });
  }

  Future<void> addExpend(BuildContext context) async {
    Expend microExpend = Expend()
      ..idUser = userData['idUser']
      ..value = selectedMicroExpend!.amount
      ..description = selectedMicroExpend!.description
      ..date = DateTime.now()
      ..title = selectedMicroExpend!.title;

    ExpensesController.insertExpend(microExpend).then((value) {
      if (value) {
        BinancyInfoDialog(context, "Gasto frecuente añadido correctamente!", [
          BinancyInfoDialogItem("Aceptar", () async {
            await Provider.of<MovementsChangeNotifier>(context, listen: false)
                .updateMovements();
            leaveScreen();
          })
        ]);
      } else {
        BinancyInfoDialog(context, "Error al añadir el gasto frecuente...", [
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
