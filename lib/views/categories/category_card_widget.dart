import 'package:binancy/globals.dart';
import 'package:binancy/models/category.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:flutter/material.dart';

class CategoryCardWidget extends StatelessWidget {
  final Category category;
  final BuildContext context;

  const CategoryCardWidget(
      {Key? key, required this.category, required this.context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {},
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
                  Text(
                      (category.categoryIncomes.length +
                                  category.categoryExpenses.length)
                              .toString() +
                          " movimientos",
                      style: miniAccentStyle())
                ],
              )),
              Icon(Icons.arrow_forward_ios_rounded,
                  color: accentColor, size: 20)
            ],
          ),
        ),
      ),
    );
  }
}
