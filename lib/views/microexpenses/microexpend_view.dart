import 'package:binancy/controllers/expenses_controller.dart';
import 'package:binancy/controllers/microexpenses_controller.dart';
import 'package:binancy/controllers/providers/microexpenses_change_notifier.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/category.dart';
import 'package:binancy/models/expend.dart';
import 'package:binancy/models/microexpend.dart';
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
  Category? selectedCategory;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode amountFocusNode = FocusNode();

  _MicroExpendViewState(this.selectedMicroExpend, this.allowEdit);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkMicroExpend();
  }

  @override
  void dispose() {
    titleController.dispose();
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
                checkMicroExpend();
              });
              return true;
            })
          ]);
        }
        return true;
      },
      child: BinancyBackground(Consumer<MicroExpensesChangeNotifier>(
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
                                    checkMicroExpend();
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
                                            .microexpend_header
                                        : selectedMicroExpend!.title,
                                    style: headerItemView(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                titleInputWidget(),
                                const SpaceDivider(),
                                amountInputWidget(),
                                const SpaceDivider(),
                                categorySelector(context),
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
                              text: AppLocalizations.of(context)!.add_expend,
                              action: () async => await addExpend(context))
                          : allowEdit
                              ? BinancyButton(
                                  context: context,
                                  text: createMode
                                      ? AppLocalizations.of(context)!
                                          .add_microexpend
                                      : AppLocalizations.of(context)!
                                          .update_microexpend,
                                  action: () async {
                                    await checkData(microExpensesProvider);
                                  })
                              : const SizedBox(),
                    ),
                    const SpaceDivider()
                  ],
                ),
              ))),
    );
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
        focusNode: nameFocusNode,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.next,
        readOnly: !allowEdit,
        keyboardType: TextInputType.name,
        controller: titleController,
        style: inputStyle(),
        decoration: customInputDecoration(
            AppLocalizations.of(context)!.microexpend_title, BinancyIcons.tag),
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
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: amountController,
        style: inputStyle(),
        decoration: customInputDecoration(
            AppLocalizations.of(context)!.microexpend_amount,
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
            hintText: AppLocalizations.of(context)!.microexpend_description,
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

  Widget categorySelector(BuildContext context) {
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
                        onChanged: allowEdit
                            ? (value) {
                                setState(() {
                                  selectedCategory = value;
                                });
                              }
                            : null,
                        style: inputStyle(),
                        underline: const SizedBox(),
                        items: categoryList
                            .map((e) => DropdownMenuItem<Category>(
                                value: e, child: Text(e.title)))
                            .toList()))
              ],
            )),
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

      if (selectedMicroExpend!.category != null) {
        selectedCategory = selectedMicroExpend!.category;
      }
    } else {
      createMode = true;
      allowEdit = true;
    }
  }

  Future<void> checkData(
      MicroExpensesChangeNotifier microExpensesProvider) async {
    nameFocusNode.unfocus();
    descriptionFocusNode.unfocus();
    amountFocusNode.unfocus();
    FocusScope.of(context).unfocus();

    if (titleController.text.isNotEmpty) {
      if (amountController.text.isNotEmpty) {
        if (createMode) {
          await insertMicroExpend(microExpensesProvider);
        } else {
          await updateMicroExpend(microExpensesProvider);
        }
      } else {
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.microexpend_invalid_amount, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept,
              () => Navigator.pop(context))
        ]);
      }
    } else {
      BinancyInfoDialog(
          context, AppLocalizations.of(context)!.microexpend_invalid_title, [
        BinancyInfoDialogItem(
            AppLocalizations.of(context)!.accept, () => Navigator.pop(context))
      ]);
    }
  }

  Future<void> insertMicroExpend(
      MicroExpensesChangeNotifier microExpensesProvider) async {
    MicroExpend microExpend = MicroExpend()
      ..title = titleController.text
      ..amount = double.parse(amountController.text)
      ..idUser = userData['idUser']
      ..idCategory =
          selectedCategory != null ? selectedCategory!.idCategory : null
      ..category = selectedCategory
      ..description = descriptionController.text;

    BinancyProgressDialog binancyProgressDialog =
        BinancyProgressDialog(context: context)..showProgressDialog();
    await MicroExpensesController.addMicroExpend(microExpend)
        .then((value) async {
      if (value) {
        await microExpensesProvider.updateMicroExpenses();
        binancyProgressDialog.dismissDialog();
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.microexpend_add_success, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
            leaveScreen();
          })
        ]);
      } else {
        binancyProgressDialog.dismissDialog();
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.microexpend_add_fail, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
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
      ..category = selectedCategory
      ..idCategory =
          selectedCategory != null ? selectedCategory!.idCategory : null
      ..description = descriptionController.text;

    BinancyProgressDialog binancyProgressDialog =
        BinancyProgressDialog(context: context)..showProgressDialog();
    await MicroExpensesController.updateMicroExpend(microExpend)
        .then((value) async {
      if (value) {
        await microExpensesProvider.updateMicroExpenses();
        binancyProgressDialog.dismissDialog();
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.microexpend_update_success, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
            setState(() {
              selectedMicroExpend = microExpend;
              allowEdit = false;
            });
            Navigator.pop(context);
          })
        ]);
      } else {
        binancyProgressDialog.dismissDialog();
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.microexpend_update_fail, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
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
      ..idCategory = selectedMicroExpend!.category != null
          ? selectedMicroExpend!.category!.idCategory
          : null
      ..category = selectedMicroExpend!.category
      ..title = selectedMicroExpend!.title;

    BinancyProgressDialog binancyProgressDialog =
        BinancyProgressDialog(context: context)..showProgressDialog();
    ExpensesController.insertExpend(microExpend).then((value) async {
      if (value) {
        await Provider.of<MovementsChangeNotifier>(context, listen: false)
            .updateMovements();
        binancyProgressDialog.dismissDialog();
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.microexpend_add_success, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
            leaveScreen();
          })
        ]);
      } else {
        binancyProgressDialog.dismissDialog();
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.microexpend_add_fail, [
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
