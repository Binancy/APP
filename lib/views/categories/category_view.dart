// ignore_for_file: no_logic_in_create_state

import 'package:binancy/controllers/categories_controller.dart';
import 'package:binancy/controllers/providers/categories_change_notifier.dart';
import 'package:binancy/models/category.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/dialogs/progress_dialog.dart';
import 'package:binancy/utils/ui/icons.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../globals.dart';

class CategoryView extends StatefulWidget {
  final Category? selectedCategory;
  final bool allowEdit;

  const CategoryView({Key? key, this.allowEdit = false, this.selectedCategory})
      : super(key: key);

  @override
  State<CategoryView> createState() =>
      _CategoryViewState(selectedCategory, allowEdit);
}

class _CategoryViewState extends State<CategoryView> {
  Category? selectedCategory;
  bool allowEdit = false, createMode = false;
  Color selectedColour = themeColor;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  _CategoryViewState(this.selectedCategory, this.allowEdit);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkCategory();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
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
                checkCategory();
              });
              return true;
            })
          ]);
        }
        return true;
      },
      child: BinancyBackground(Consumer<CategoriesChangeNotifier>(
          builder: (context, categoriesProvider, child) => Scaffold(
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
                                    checkCategory();
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
                                                .goals_header
                                            : selectedCategory!.title,
                                        style: headerItemView(),
                                        textAlign: TextAlign.center)),
                                nameInputWidget(),
                                const SpaceDivider(),
                                descriptionInputWidget(),
                                const SpaceDivider(),
                                colourPickerWidget(context),
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
                                    ? AppLocalizations.of(context)!.add_goal
                                    : AppLocalizations.of(context)!.update_goal,
                                action: () async {
                                  await checkData(categoriesProvider);
                                }),
                          )
                        : const SizedBox(),
                    const SpaceDivider(),
                  ],
                ),
              ))),
    );
  }

  void checkCategory() {
    if (selectedCategory != null) {
      createMode = false;
      titleController.text = selectedCategory!.title;
      selectedColour = selectedCategory!.color;
      if (selectedCategory!.description != null) {
        descriptionController.text = selectedCategory!.description!;
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
        controller: titleController,
        style: inputStyle(),
        decoration: customInputDecoration(
            AppLocalizations.of(context)!.goal_title, BinancyIcons.tag),
      ),
    );
  }

  Widget colourPickerWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: customMargin, right: customMargin),
      child: Material(
        color: selectedColour.withOpacity(0.3),
        borderRadius: BorderRadius.circular(customBorderRadius),
        child: InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            if (allowEdit) {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                      content: BlockPicker(
                          pickerColor: selectedColour,
                          onColorChanged: (value) => setState(() {
                                selectedColour = value;
                                Navigator.pop(context);
                              }))));
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
                    BinancyIcons.palette,
                    color: accentColor,
                    size: 36,
                  ),
                  const SpaceDivider(
                    isVertical: true,
                  ),
                  Text("Cambia el color de la categoría", style: inputStyle())
                ],
              )),
        ),
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
            hintText: AppLocalizations.of(context)!.goal_description,
            hintStyle: inputStyle()),
        style: inputStyle(),
        maxLength: 300,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        minLines: null,
      ),
    );
  }

  Future<void> checkData(
      CategoriesChangeNotifier categoriesChangeNotifier) async {
    if (titleController.text.isNotEmpty) {
      if (createMode) {
        await insertCategory(categoriesChangeNotifier);
      } else {
        await updateCategory(categoriesChangeNotifier);
      }
    } else {
      BinancyInfoDialog(
          context, AppLocalizations.of(context)!.goal_invalid_title, [
        BinancyInfoDialogItem(
            AppLocalizations.of(context)!.accept, () => Navigator.pop(context))
      ]);
    }
  }

  Future<void> insertCategory(
      CategoriesChangeNotifier categoriesChangeNotifier) async {
    Category savingsPlan = Category()
      ..title = titleController.text
      ..description = descriptionController.text
      ..idUser = userData['idUser']
      ..isPredefined = false
      ..color = selectedColour;

    BinancyProgressDialog binancyProgressDialog =
        BinancyProgressDialog(context: context)..showProgressDialog();
    await CategoriesController.createCategory(savingsPlan).then((value) async {
      if (value) {
        await categoriesChangeNotifier.updateCategories(context);
        binancyProgressDialog.dismissDialog();
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.goal_add_success, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
            leaveScreen();
          })
        ]);
      } else {
        binancyProgressDialog.dismissDialog();
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.goal_add_fail, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
            Navigator.pop(context);
          })
        ]);
      }
    });
  }

  Future<void> updateCategory(
      CategoriesChangeNotifier categoriesChangeNotifier) async {
    Category category = Category()
      ..title = titleController.text
      ..idCategory = selectedCategory!.idCategory
      ..description = descriptionController.text
      ..color = selectedColour;

    BinancyProgressDialog binancyProgressDialog =
        BinancyProgressDialog(context: context)..showProgressDialog();
    await CategoriesController.updateCategory(category).then((value) async {
      if (value) {
        await categoriesChangeNotifier.updateCategories(context);
        binancyProgressDialog.dismissDialog();
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.goal_update_success, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
            setState(() {
              selectedCategory = category;
              allowEdit = false;
            });
            Navigator.pop(context);
          })
        ]);
      } else {
        binancyProgressDialog.dismissDialog();

        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.goal_update_fail, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
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
