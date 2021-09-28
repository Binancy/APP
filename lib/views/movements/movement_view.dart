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
                            onPressed: () => BinancyInfoDialog(
                                    context,
                                    AppLocalizations.of(context)!.exit_confirm,
                                    [
                                      BinancyInfoDialogItem(
                                          AppLocalizations.of(context)!.cancel,
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
                                  allowEdit = false;
                                });
                              })
                            ]),
                          ),
                title: Text(
                    createMode
                        ? widget.movementType.index == 0
                            ? AppLocalizations.of(context)!.add_income
                            : AppLocalizations.of(context)!.add_expend
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
                        Text(AppLocalizations.of(context)!.movement_data,
                            style: titleCardStyle()),
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
          hintText: AppLocalizations.of(context)!.movement_title),
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
    print(selectedMovement.idExpend);

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
