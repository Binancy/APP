import 'package:binancy/globals.dart';
import 'package:binancy/models/savings_plan.dart';
import 'package:binancy/utils/ui/icons.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SavingsPlanView extends StatefulWidget {
  final SavingsPlan? selectedSavingsPlan;
  final bool allowEdit;

  SavingsPlanView({this.allowEdit = false, this.selectedSavingsPlan});

  @override
  _SavingsPlanViewState createState() =>
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
    return BinancyBackground(Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        brightness: Brightness.dark,
        actions: [
          createMode
              ? SizedBox()
              : IconButton(
                  onPressed: () {}, icon: Icon(Icons.more_horiz_rounded))
        ],
      ),
      body: Container(
          child: Column(
        children: [
          Expanded(
              child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView(
                    children: [
                      Container(
                          height: 175,
                          alignment: Alignment.center,
                          child: Text(
                              createMode
                                  ? "Añade una meta de ingresos"
                                  : selectedSavingsPlan!.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "OpenSans",
                                  color: textColor,
                                  fontSize: 30),
                              textAlign: TextAlign.center)),
                      nameInputWidget(),
                      SpaceDivider(),
                      amountInputWidget(),
                      SpaceDivider(),
                      datePicker(context),
                      SpaceDivider(),
                      descriptionInputWidget(),
                    ],
                  ))),
          allowEdit ? SpaceDivider() : SizedBox(),
          allowEdit
              ? Padding(
                  padding:
                      EdgeInsets.only(left: customMargin, right: customMargin),
                  child: BinancyButton(
                      context: context,
                      text: createMode
                          ? "Añadir meta de ahorro"
                          : "Actualizar meta de ahorro",
                      action: () {}),
                )
              : SizedBox(),
          SpaceDivider(),
        ],
      )),
    ));
  }

  Widget nameInputWidget() {
    return Container(
      margin: EdgeInsets.only(left: customMargin, right: customMargin),
      height: buttonHeight,
      padding: EdgeInsets.only(left: customMargin, right: customMargin),
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
      margin: EdgeInsets.only(left: customMargin, right: customMargin),
      height: buttonHeight,
      padding: EdgeInsets.only(left: customMargin, right: customMargin),
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

  Container descriptionInputWidget() {
    return Container(
      height: 200,
      margin: EdgeInsets.only(left: customMargin, right: customMargin),
      decoration: BoxDecoration(
          color: themeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(customBorderRadius)),
      padding: EdgeInsets.all(customMargin),
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
      padding: EdgeInsets.only(left: customMargin, right: customMargin),
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
              padding: EdgeInsets.only(left: customMargin, right: customMargin),
              child: Row(
                children: [
                  Icon(
                    BinancyIcons.calendar,
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

  void checkSavingsPlan() {
    if (selectedSavingsPlan != null) {
      createMode = false;
    } else {
      createMode = true;
      allowEdit = true;
    }
  }
}
