import 'package:binancy/build_configs.dart';
import 'package:binancy/controllers/expenses_controller.dart';
import 'package:binancy/controllers/incomes_controller.dart';
import 'package:binancy/controllers/providers/categories_change_notifier.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/category.dart';
import 'package:binancy/models/expend.dart';
import 'package:binancy/models/income.dart';
import 'package:binancy/models/savings_plan.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum MovementType { INCOME, EXPEND }

class MovementView extends StatefulWidget {
  final MovementType movementType;
  final dynamic selectedMovement;
  final bool allowEdit;

  MovementView(
      {required this.movementType,
      this.selectedMovement,
      this.allowEdit = false});
  @override
  _MovementViewState createState() =>
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
  SavingsPlan? selectedSavingsPlan;

  _MovementViewState(dynamic selectedMovement, bool allowEdit) {
    this.selectedMovement = selectedMovement;
    this.allowEdit = allowEdit;
  }

  @override
  Widget build(BuildContext context) {
    checkMovement();

    return BinancyBackground(Consumer2<MovementsChangeNotifier,
            CategoriesChangeNotifier>(
        builder: (context, movementsProvider, categoriesProvider, child) =>
            Scaffold(
              appBar: AppBar(
                elevation: 0,
                brightness: Brightness.dark,
                backgroundColor: Colors.transparent,
                centerTitle: true,
                actions: [
                  !allowEdit && !createMode
                      ? IconButton(
                          icon: Icon(Icons.more_horiz),
                          onPressed: () {
                            setState(() {
                              allowEdit = true;
                            });
                          })
                      : SizedBox()
                ],
                leading: !allowEdit
                    ? IconButton(
                        icon: Icon(Icons.arrow_back_ios_rounded),
                        onPressed: () => Navigator.pop(context))
                    : createMode
                        ? IconButton(
                            icon: Icon(Icons.arrow_back_ios_rounded),
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
                            icon: Icon(Icons.close_outlined),
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
              body: Container(
                child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          movementHeader(),
                          Text("Datos del movimiento", style: titleCardStyle()),
                          SpaceDivider(),
                          movementNotes(),
                          SpaceDivider(),
                          datePicker(context),
                          SpaceDivider(),
                          categorySelector(context),
                          BuildConfigs.enableSavingsPlan
                              ? SpaceDivider()
                              : SizedBox(),
                          BuildConfigs.enableSavingsPlan
                              ? savingsPlanSelector(context)
                              : SizedBox(),
                          SpaceDivider(),
                          SpaceDivider(),
                          allowEdit
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      left: customMargin, right: customMargin),
                                  child: BinancyButton(
                                      context: context,
                                      text: "Añadir ingreso",
                                      action: () async {
                                        await checkData(movementsProvider);
                                      }))
                              : SizedBox()
                        ],
                      ),
                    )),
              ),
            )));
  }

  Container movementHeader() {
    return Container(
      height: 185,
      decoration: BoxDecoration(
          color: themeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(customBorderRadius)),
      margin: EdgeInsets.all(customMargin),
      padding: EdgeInsets.all(customMargin),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [inputValue(), inputTitle()],
        ),
      ),
    );
  }

  Container movementNotes() {
    return Container(
      height: 150,
      margin: EdgeInsets.only(left: customMargin, right: customMargin),
      decoration: BoxDecoration(
          color: themeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(customBorderRadius)),
      padding: EdgeInsets.all(customMargin),
      child: TextField(
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
      padding: EdgeInsets.only(left: customMargin, right: customMargin),
      child: Material(
        color: themeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(customBorderRadius),
        child: InkWell(
          onTap: () => allowEdit
              ? showDatePicker(
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
                })
              : null,
          borderRadius: BorderRadius.circular(customBorderRadius),
          highlightColor: Colors.transparent,
          splashColor: themeColor.withOpacity(0.1),
          child: Container(
              height: buttonHeight,
              padding: EdgeInsets.only(left: customMargin, right: customMargin),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    color: accentColor,
                    size: 36,
                  ),
                  SpaceDivider(
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
      padding: EdgeInsets.only(left: customMargin, right: customMargin),
      child: Material(
        color: themeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(customBorderRadius),
        child: Container(
            height: buttonHeight,
            padding: EdgeInsets.only(left: customMargin, right: customMargin),
            child: Row(
              children: [
                Icon(
                  Icons.dashboard_rounded,
                  color: accentColor,
                  size: 36,
                ),
                SpaceDivider(
                  isVertical: true,
                ),
                Expanded(
                    child: DropdownButton<Category>(
                        isExpanded: true,
                        hint: Text(
                          "Selecciona una categoría",
                          style: inputStyle(),
                        ),
                        dropdownColor: themeColor.withOpacity(0.5),
                        elevation: 0,
                        iconDisabledColor: accentColor,
                        iconEnabledColor: accentColor,
                        value:
                            selectedCategory != null ? selectedCategory : null,
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                        style: inputStyle(),
                        underline: SizedBox(),
                        items: categoryList
                            .map((e) => DropdownMenuItem<Category>(
                                value: e, child: Text(e.name)))
                            .toList()))
              ],
            )),
      ),
    );
  }

  Padding savingsPlanSelector(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: customMargin, right: customMargin),
      child: Material(
        color: themeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(customBorderRadius),
        child: InkWell(
          onTap: () => showDatePicker(
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
          }),
          borderRadius: BorderRadius.circular(customBorderRadius),
          highlightColor: Colors.transparent,
          splashColor: themeColor.withOpacity(0.1),
          child: Container(
              height: buttonHeight,
              padding: EdgeInsets.only(left: customMargin, right: customMargin),
              child: Row(
                children: [
                  Icon(
                    Icons.account_balance_outlined,
                    color: accentColor,
                    size: 36,
                  ),
                  SpaceDivider(
                    isVertical: true,
                  ),
                  Text(
                      selectedSavingsPlan != null
                          ? "[DEBUG] - Selected saving plan"
                          : "No tienes ningún plan de ahorro",
                      style: inputStyle())
                ],
              )),
        ),
      ),
    );
  }

  TextField inputTitle() {
    return TextField(
      readOnly: !allowEdit,
      inputFormatters: [LengthLimitingTextInputFormatter(30)],
      keyboardType: TextInputType.name,
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

  Container inputValue() {
    return Container(
        height: 75,
        child: TextField(
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
        ));
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
                BinancyInfoDialogItem("Aceptar", () {
                  movementsProvider.updateDashboard();
                  gotoDashboard();
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
                BinancyInfoDialogItem("Aceptar", () {
                  movementsProvider.updateDashboard();
                  setState(() {
                    allowEdit = false;
                  });
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
                BinancyInfoDialogItem("Aceptar", () {
                  movementsProvider.updateDashboard();
                  gotoDashboard();
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
                BinancyInfoDialogItem("Aceptar", () {
                  movementsProvider.updateDashboard();
                  setState(() {
                    allowEdit = false;
                  });
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

  void gotoDashboard() {
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
