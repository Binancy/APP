import 'package:binancy/controllers/providers/dashboard_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/category.dart';
import 'package:binancy/models/income.dart';
import 'package:binancy/models/savings_plan.dart';
import 'package:binancy/utils/dialogs.dart';
import 'package:binancy/utils/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class IncomeView extends StatefulWidget {
  @override
  _IncomeViewState createState() => _IncomeViewState();
}

class _IncomeViewState extends State<IncomeView> {
  Income selectedIncome = Income();
  bool allowEdit = true, createMode = false;

  TextEditingController valueController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  String parsedDate = "Fecha de realización";
  Category? selectedCategory;
  SavingsPlan? selectedSavingsPlan;

  @override
  Widget build(BuildContext context) {
    return BinancyBackground(Consumer<DashboardChangeNotifier>(
        builder: (context, value, child) => Scaffold(
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
                            onPressed: () => CustomDialog(context,
                                    "¿Estas seguro que quieres salir?", [
                                  CustomDialogItem(
                                      "Cancelar", () => Navigator.pop(context)),
                                  CustomDialogItem("Abortar", () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  })
                                ]))
                        : IconButton(
                            icon: Icon(Icons.close_outlined),
                            onPressed: () => CustomDialog(
                                context, "Estas seguro que quieres salir?", [
                              CustomDialogItem(
                                  "Canelar", () => Navigator.pop(context)),
                              CustomDialogItem("Abortar", () {
                                Navigator.pop(context);
                                setState(() {
                                  allowEdit = false;
                                });
                              })
                            ]),
                          ),
                title: Text(
                    createMode ? "Añade un ingreso" : "[DEBUG] - Income title",
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
                          SpaceDivider(),
                          savingsPlanSelector(context),
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
                                        createMode
                                            ? await insertIncome()
                                            : await updateIncome();
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
                    Icons.dashboard_rounded,
                    color: accentColor,
                    size: 36,
                  ),
                  SpaceDivider(
                    isVertical: true,
                  ),
                  Text(
                      selectedCategory != null
                          ? selectedCategory!.key
                          : "Selecciona una categoria",
                      style: inputStyle())
                ],
              )),
        ),
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

  Future<void> insertIncome() async {}

  Future<void> updateIncome() async {}
}
