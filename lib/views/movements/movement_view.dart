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
import 'package:binancy/utils/dialogs/progress_dialog.dart';
import 'package:binancy/utils/ui/icons.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  String parsedDate = "";

  Category? selectedCategory;

  _MovementViewState(this.selectedMovement, this.allowEdit);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    parsedDate = AppLocalizations.of(context)!.realization_date;
    checkMovement();
  }

  @override
  void dispose() {
    super.dispose();
    valueController.dispose();
    titleController.dispose();
    noteController.dispose();
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
                checkMovement();
              });
              return true;
            })
          ]);
        }
        return true;
      },
      child: BinancyBackground(Consumer2<MovementsChangeNotifier,
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
                            icon: const Icon(Icons.edit_rounded),
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
                              onPressed: () => BinancyInfoDialog(
                                      context,
                                      AppLocalizations.of(context)!
                                          .exit_confirm,
                                      [
                                        BinancyInfoDialogItem(
                                            AppLocalizations.of(context)!
                                                .cancel,
                                            () => Navigator.pop(context)),
                                        BinancyInfoDialogItem(
                                            AppLocalizations.of(context)!.abort,
                                            () {
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
                                    checkMovement();
                                    allowEdit = false;
                                  });
                                })
                              ]),
                            ),
                ),
                backgroundColor: Colors.transparent,
                body: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 125,
                            padding: const EdgeInsets.all(customMargin),
                            alignment: Alignment.center,
                            child: Text(
                                createMode
                                    ? widget.movementType.index == 0
                                        ? AppLocalizations.of(context)!
                                            .add_income
                                        : AppLocalizations.of(context)!
                                            .add_expend
                                    : selectedMovement.title,
                                style: headerItemView(),
                                textAlign: TextAlign.center),
                          ),
                          const SpaceDivider(),
                          movementHeader(),
                          const SpaceDivider(),
                          datePicker(context),
                          const SpaceDivider(),
                          categorySelector(context),
                          const SpaceDivider(),
                          movementNotes(),
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
                                              ? AppLocalizations.of(context)!
                                                  .add_income
                                              : AppLocalizations.of(context)!
                                                  .add_expend
                                          : widget.movementType ==
                                                  MovementType.INCOME
                                              ? AppLocalizations.of(context)!
                                                  .update_income
                                              : AppLocalizations.of(context)!
                                                  .update_expend,
                                      action: () async {
                                        FocusScope.of(context).unfocus();
                                        await checkData(movementsProvider);
                                      }))
                              : const SizedBox()
                        ],
                      ),
                    )),
              ))),
    );
  }

  Widget movementHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [inputTitle(), const SpaceDivider(), inputValue()],
    );
  }

  Widget movementNotes() {
    return Container(
      height: 170,
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
            hintText: AppLocalizations.of(context)!.movement_description,
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
                          AppLocalizations.of(context)!.select_category,
                          style: inputStyle(),
                        ),
                        onTap: () => FocusScope.of(context).unfocus(),
                        dropdownColor: primaryColor,
                        borderRadius: BorderRadius.circular(customBorderRadius),
                        isDense: true,
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
                        items: Provider.of<CategoriesChangeNotifier>(context)
                            .categoryList
                            .map((e) => DropdownMenuItem<Category>(
                                value: e, child: Text(e.title)))
                            .toList()))
              ],
            )),
      ),
    );
  }

  Widget inputTitle() {
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
            widget.movementType == MovementType.INCOME
                ? AppLocalizations.of(context)!.income_title
                : AppLocalizations.of(context)!.expend_title,
            BinancyIcons.email),
      ),
    );
  }

  Widget inputValue() {
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
        controller: valueController,
        style: inputStyle(),
        decoration: customInputDecoration(
            widget.movementType == MovementType.INCOME
                ? AppLocalizations.of(context)!.income_value
                : AppLocalizations.of(context)!.expend_value,
            BinancyIcons.calendar),
      ),
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
              context, AppLocalizations.of(context)!.movement_invalid_date, [
            BinancyInfoDialogItem(AppLocalizations.of(context)!.accept,
                () => Navigator.pop(context))
          ]);
        }
      } else {
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.movement_invalid_title, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept,
              () => Navigator.pop(context))
        ]);
      }
    } else {
      BinancyInfoDialog(
          context, AppLocalizations.of(context)!.movement_invalid_amount, [
        BinancyInfoDialogItem(
            AppLocalizations.of(context)!.accept, () => Navigator.pop(context))
      ]);
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

    BinancyProgressDialog binancyProgressDialog =
        BinancyProgressDialog(context: context)..showProgressDialog();
    await IncomesController.insertIncome(income).then((value) async {
      if (value) {
        await movementsProvider.updateMovements();
        binancyProgressDialog.dismissDialog();
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.income_add_success, [
          BinancyInfoDialogItem(
              AppLocalizations.of(context)!.accept, () => leaveScreen())
        ]);
      } else {
        binancyProgressDialog.dismissDialog();
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.income_add_fail, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
            Navigator.pop(context);
          })
        ]);
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

    BinancyProgressDialog binancyProgressDialog =
        BinancyProgressDialog(context: context)..showProgressDialog();
    await IncomesController.updateIncome(income).then((value) async {
      if (value) {
        await movementsProvider.updateMovements();
        binancyProgressDialog.dismissDialog();
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.income_update_success, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
            setState(() {
              selectedMovement = income;
              allowEdit = false;
            });
            Navigator.pop(context);
          })
        ]);
      } else {
        binancyProgressDialog.dismissDialog();
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.income_update_fail, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
            Navigator.pop(context);
          })
        ]);
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

    BinancyProgressDialog binancyProgressDialog =
        BinancyProgressDialog(context: context)..showProgressDialog();
    await ExpensesController.insertExpend(expend).then((value) async {
      if (value) {
        await movementsProvider.updateMovements();
        binancyProgressDialog.dismissDialog();
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.expend_add_success, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () async {
            leaveScreen();
          })
        ]);
      } else {
        binancyProgressDialog.dismissDialog();
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.expend_add_fail, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
            Navigator.pop(context);
          })
        ]);
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

    BinancyProgressDialog binancyProgressDialog =
        BinancyProgressDialog(context: context)..showProgressDialog();
    await ExpensesController.updateExpend(expend).then((value) async {
      if (value) {
        await movementsProvider.updateMovements();
        binancyProgressDialog.dismissDialog();
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.expend_update_success, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () async {
            setState(() {
              allowEdit = false;
              selectedMovement = expend;
            });
            Navigator.pop(context);
          })
        ]);
      } else {
        binancyProgressDialog.dismissDialog();
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.expend_update_fail, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
            Navigator.pop(context);
          })
        ]);
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
