import 'package:binancy/controllers/categories_controller.dart';
import 'package:binancy/controllers/providers/categories_change_notifier.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/category.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/dialogs/progress_dialog.dart';
import 'package:binancy/utils/ui/icons.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/views/categories/category_view.dart';
import 'package:binancy/views/movements/movements_all_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class CategoryCardWidget extends StatelessWidget {
  final Category category;
  final BuildContext context;
  final CategoriesChangeNotifier categoriesChangeNotifier;
  final MovementsChangeNotifier movementsChangeNotifier;

  const CategoryCardWidget(
      {Key? key,
      required this.category,
      required this.context,
      required this.categoriesChangeNotifier,
      required this.movementsChangeNotifier})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          onTap: () => category.categoryIncomes.isEmpty &&
                  category.categoryExpenses.isEmpty
              ? null
              : Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                    child: MultiProvider(
                      providers: [
                        ChangeNotifierProvider(
                          create: (_) => movementsChangeNotifier,
                        ),
                        ChangeNotifierProvider(
                          create: (_) => categoriesChangeNotifier,
                        )
                      ],
                      child: AllMovementView(selectedCategory: category),
                    ),
                  )),
          highlightColor: themeColor.withOpacity(0.1),
          splashColor: themeColor.withOpacity(0.1),
          child: Container(
            padding: const EdgeInsets.all(customMargin),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category.title, style: semititleStyle()),
                    Text(countMovementsText(), style: miniAccentStyle())
                  ],
                )),
                category.categoryIncomes.isEmpty &&
                        category.categoryExpenses.isEmpty
                    ? const SizedBox()
                    : Icon(Icons.arrow_forward_ios_rounded,
                        color: accentColor, size: 20)
              ],
            ),
          ),
        ),
      ),
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.2,
      actions: category.isPredefined ? null : savingsPlansActions(),
      secondaryActions: category.isPredefined ? null : savingsPlansActions(),
    );
  }

  List<Widget> savingsPlansActions() {
    return [
      IconSlideAction(
        caption: AppLocalizations.of(context)!.delete,
        foregroundColor: accentColor,
        color: Colors.transparent,
        icon: BinancyIcons.delete,
        onTap: () async {
          BinancyProgressDialog binancyProgressDialog =
              BinancyProgressDialog(context: context)..showProgressDialog();
          await CategoriesController.deleteCategory(category)
              .then((value) async {
            if (value) {
              await categoriesChangeNotifier.updateCategories(context);
              await movementsChangeNotifier.updateMovements();
              binancyProgressDialog.dismissDialog();
              BinancyInfoDialog(context,
                  AppLocalizations.of(context)!.category_delete_success, [
                BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
                  Navigator.of(context, rootNavigator: true).pop();
                })
              ]);
            } else {
              binancyProgressDialog.dismissDialog();
              BinancyInfoDialog(context,
                  AppLocalizations.of(context)!.category_delete_error, [
                BinancyInfoDialogItem(AppLocalizations.of(context)!.accept,
                    () => Navigator.of(context, rootNavigator: true).pop())
              ]);
            }
          });
        },
      ),
      IconSlideAction(
        caption: AppLocalizations.of(context)!.edit,
        icon: BinancyIcons.edit,
        foregroundColor: accentColor,
        color: Colors.transparent,
        onTap: () => Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeftWithFade,
              child: MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (_) =>
                        Provider.of<CategoriesChangeNotifier>(context),
                  )
                ],
                child:
                    CategoryView(allowEdit: true, selectedCategory: category),
              ),
            )),
      )
    ];
  }

  String countMovementsText() {
    int totalMovements =
        category.categoryIncomes.length + category.categoryExpenses.length;
    if (totalMovements == 1) {
      return totalMovements.toString() +
          " " +
          AppLocalizations.of(context)!.movement_singular;
    } else {
      return totalMovements.toString() +
          " " +
          AppLocalizations.of(context)!.movement_plural;
    }
  }
}
