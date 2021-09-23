import 'package:binancy/controllers/expenses_controller.dart';
import 'package:binancy/controllers/incomes_controller.dart';
import 'package:binancy/controllers/providers/categories_change_notifier.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/category.dart';
import 'package:binancy/models/expend.dart';
import 'package:binancy/models/income.dart';
import 'package:binancy/utils/dialogs/date_dialog.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/ui/icons.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

enum MovementType { INCOME, EXPEND }

class MovementView extends StatefulWidget {
  final MovementType movementType;
  final dynamic selectedMovement;
  final bool allowEdit;

  const MovementView(
      {required this.movementType,
      this.selectedMovement,
      this.allowEdit = false});
  @override
  _MovementViewState createState() =>
      // ignore: no_logic_in_create_state
      _MovementViewState(selectedMovement, allowEdit);
}

class _MovementViewState extends State<MovementView> {
  bool allowEdit = false, createMode = false;
  dynamic selectedMovement;

  TextEditingController valueController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  String parsedDate = "Fecha de realización";

  Category? selectedCategory;

  _MovementViewState(this.selectedMovement, this.allowEdit);

  @override
  Widget build(BuildContext context) {
    checkMovement();

    return BinancyBackground(Consumer2<MovementsChangeNotifier,
            CategoriesChangeNotifier>(
        builder: (context, movementsProvider, categoriesProvider, child) =>
            Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                centerTitle: true,
                actions: [
                  !allowEdit && !createMode
                      ? IconButton(
                          icon: const Icon(Icons.more_horiz),
                          onPressed: () {
                            setState(() {
                              allowEdit = true;
                            });
                          })
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
                title: Text(
                    createMode
                        ? widget.movementType.index == 0
                            ? "Añade un ingreso"
                            : "Añade un gasto"
                        : selectedMovement.title,
                    style: appBarStyle()),
              ),
              backgroundColor: Colors.transparent,
              body: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        movementHeader(),
                        Text("Datos del movimiento", style: titleCardStyle()),
                        const SpaceDivider(),
                        movementNotes(),
                        const SpaceDivider(),
                        datePicker(context),
                        const SpaceDivider(),
                        categorySelector(context),
                        const SpaceDivider(),
                        allowEdit
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: customMargin, right: customMargin),
                                child: BinancyButton(
                                    context: context,
                                    text: createMode
                                        ? widget.movementType ==
                                                MovementType.INCOME
                                            ? "Añadir ingreso"
                                            : "Añadir gasto"
                                        : widget.movementType ==
                                                MovementType.INCOME
                                            ? "Actualizar ingreso"
                                            : "Actualizar gasto",
                                    action: () async {
                                      FocusScope.of(context).unfocus();
                                      await checkData(movementsProvider);
                                    }))
                            : const SizedBox()
                      ],
                    ),
                  )),
            )));
  }

  Container movementHeader() {
    return Container(
      decoration: BoxDecoration(
          color: themeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(customBorderRadius)),
      margin: const EdgeInsets.all(customMargin),
      padding: const EdgeInsets.fromLTRB(
          customMargin, 0, customMargin, customMargin),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [inputValue(), inputTitle()],
      ),
    );
  }

  Container movementNotes() {
    return Container(
      height: 150,
      margin: const EdgeInsets.only(left: customMargin, right: customMargin),
      decoration: BoxDecoration(
          color: themeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(customBorderRadius)),
      padding: const EdgeInsets.all(customMargin),
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        controller: noteController,
        readOnly: !allowEdit,
        expands: true,
        decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            counterStyle: detailStyle(),
            hintText: "Añade una nota a este movimiento",
            hintStyle: inputStyle()),
        style: inputStyle(),
        maxLength: 300,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        minLines: null,
      ),
    );
  }

  Padding datePicker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: customMargin, right: customMargin),
      child: Material(
        color: themeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(customBorderRadius),
        child: InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            if (allowEdit) {
              BinancyDatePicker binancyDatePicker = BinancyDatePicker(
                  context: context,
                  initialDate: Utils.isValidDateYMD(parsedDate, context)
                      ? Utils.fromYMD(parsedDate, context)
                      : DateTime.now());
              binancyDatePicker.showCustomDialog().then((value) {
                if (value != null) {
                  setState(() {
                    parsedDate = Utils.toYMD(value, context);
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
                  Text(parsedDate, style: inputStyle())
                ],
              )),
        ),
      ),
    );
  }

  Padding categorySelector(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: customMargin, right: customMargin),
      child: Material(
        color: themeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(customBorderRadius),
        child: Container(
            height: buttonHeight,
            padding:
                const EdgeInsets.only(left: customMargin, right: customMargin),
            child: Row(
              children: [
                Icon(
                  BinancyIcons.folder,
                  color: accentColor,
                  size: 36,
                ),
                const SpaceDivider(
                  isVertical: true,
                ),
                Expanded(
                    child: DropdownButton<Category>(
                        isExpanded: true,
                        hint: Text(
                          "Selecciona una categoría",
                          style: inputStyle(),
                        ),
                        onTap: () => FocusScope.of(context).unfocus(),
                        dropdownColor: themeColor.withOpacity(0.5),
                        elevation: 0,
                        iconDisabledColor: accentColor,
                        iconEnabledColor: accentColor,
                        value: selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                        style: inputStyle(),
                        underline: const SizedBox(),
                        items: categoryList
                            .map((e) => DropdownMenuItem<Category>(
                                value: e, child: Text(e.name)))
                            .toList()))
              ],
            )),
      ),
    );
  }

  TextField inputTitle() {
    return TextField(
      readOnly: !allowEdit,
      inputFormatters: [LengthLimitingTextInputFormatter(30)],
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.sentences,
      controller: titleController,
      cursorColor: accentColor,
      textAlign: TextAlign.center,
      style: accentTitleStyle(),
      decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintStyle: accentTitleStyle(),
          hintText: "Título del movimiento"),
    );
  }

  Widget inputValue() {
    return TextField(
      readOnly: !allowEdit,
      inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
      keyboardType: TextInputType.number,
      controller: valueController,
      cursorColor: Colors.white,
      textAlign: TextAlign.center,
      style: balanceValueStyle(),
      decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintStyle: balanceValueStyle(),
          hintText: "0.00€"),
    );
  }

  Future<void> checkData(
      MovementsChangeNotifier movementsChangeNotifier) async {
    if (valueController.text.isNotEmpty) {
      if (titleController.text.isNotEmpty) {
        if (Utils.validateStringDate(parsedDate)) {
          if (createMode) {
            switch (widget.movementType) {
              case MovementType.INCOME:
                await insertIncome(movementsChangeNotifier);
                break;
              case MovementType.EXPEND:
                await insertExpend(movementsChangeNotifier);
            }
          } else {
            switch (widget.movementType) {
              case MovementType.INCOME:
                await updateIncome(movementsChangeNotifier);
                break;
              case MovementType.EXPEND:
                await updateExpend(movementsChangeNotifier);
            }
          }
        } else {
          BinancyInfoDialog(
              context,
              "La fecha introducida no es válida o esta en blanco",
              [BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))]);
        }
      } else {
        BinancyInfoDialog(context, "Debes introducir un nombre al movimiento",
            [BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))]);
      }
    } else {
      BinancyInfoDialog(context, "Debes introducir un valor al movimiento",
          [BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))]);
    }
  }

  Future<void> insertIncome(MovementsChangeNotifier movementsProvider) async {
    Income income = Income()
      ..title = titleController.text
      ..value = double.parse(valueController.text)
      ..date = Utils.fromYMD(parsedDate, context)
      ..idUser = userData['idUser']
      ..description = noteController.text
      ..category = selectedCategory;

    await IncomesController.insertIncome(income).then((value) => {
          if (value)
            {
              BinancyInfoDialog(context, "Ingreso añadido correctamente!", [
                BinancyInfoDialogItem("Aceptar", () async {
                  await movementsProvider.updateMovements();
                  leaveScreen();
                })
              ])
            }
          else
            {
              BinancyInfoDialog(context, "Error al añadir el ingreso...", [
                BinancyInfoDialogItem("Aceptar", () {
                  Navigator.pop(context);
                })
              ])
            }
        });
  }

  Future<void> updateIncome(MovementsChangeNotifier movementsProvider) async {
    Income income = Income()
      ..title = titleController.text
      ..value = double.parse(valueController.text)
      ..date = Utils.fromYMD(parsedDate, context)
      ..idUser = userData['idUser']
      ..description = noteController.text
      ..category = selectedCategory
      ..idIncome = selectedMovement.idIncome;

    await IncomesController.updateIncome(income).then((value) => {
          if (value)
            {
              BinancyInfoDialog(context, "Ingreso actualizado correctamente!", [
                BinancyInfoDialogItem("Aceptar", () async {
                  await movementsProvider.updateMovements();
                  setState(() {
                    selectedMovement = income;
                    allowEdit = false;
                  });
                  Navigator.pop(context);
                })
              ])
            }
          else
            {
              BinancyInfoDialog(context, "Error al actualizar el ingreso...", [
                BinancyInfoDialogItem("Aceptar", () {
                  Navigator.pop(context);
                })
              ])
            }
        });
  }

  Future<void> insertExpend(MovementsChangeNotifier movementsProvider) async {
    Expend expend = Expend()
      ..title = titleController.text
      ..value = double.parse(valueController.text)
      ..date = Utils.fromYMD(parsedDate, context)
      ..idUser = userData['idUser']
      ..description = noteController.text
      ..category = selectedCategory;

    await ExpensesController.insertExpend(expend).then((value) => {
          if (value)
            {
              BinancyInfoDialog(context, "Gasto añadido correctamente!", [
                BinancyInfoDialogItem("Aceptar", () async {
                  await movementsProvider.updateMovements();
                  leaveScreen();
                })
              ])
            }
          else
            {
              BinancyInfoDialog(context, "Error al añadir el gasto...", [
                BinancyInfoDialogItem("Aceptar", () {
                  Navigator.pop(context);
                })
              ])
            }
        });
  }

  Future<void> updateExpend(MovementsChangeNotifier movementsProvider) async {
    print(selectedMovement.idExpend);

    Expend expend = Expend()
      ..title = titleController.text
      ..value = double.parse(valueController.text)
      ..date = Utils.fromYMD(parsedDate, context)
      ..idUser = userData['idUser']
      ..description = noteController.text
      ..category = selectedCategory
      ..idExpend = selectedMovement.idExpend;

    await ExpensesController.updateExpend(expend).then((value) => {
          if (value)
            {
              BinancyInfoDialog(context, "Ingreso actualizado correctamente!", [
                BinancyInfoDialogItem("Aceptar", () async {
                  await movementsProvider.updateMovements();
                  setState(() {
                    allowEdit = false;
                    selectedMovement = expend;
                  });
                  Navigator.pop(context);
                })
              ])
            }
          else
            {
              BinancyInfoDialog(context, "Error al actualizar el ingreso...", [
                BinancyInfoDialogItem("Aceptar", () {
                  Navigator.pop(context);
                })
              ])
            }
        });
  }

  void checkMovement() {
    if (selectedMovement != null) {
      createMode = false;
      selectedCategory = selectedMovement.category;

      titleController.text = selectedMovement.title;
      valueController.text = selectedMovement.value is int
          ? selectedMovement.value.toString()
          : (selectedMovement.value as double).toStringAsFixed(2);
      noteController.text = selectedMovement.description ?? "";

      parsedDate = Utils.toYMD(selectedMovement.date, context);
    } else {
      createMode = true;
    }
  }

  void leaveScreen() {
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
