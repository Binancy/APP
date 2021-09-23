import 'package:binancy/controllers/providers/microexpenses_change_notifier.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:binancy/views/advice/advice_card.dart';
import 'package:binancy/views/microexpenses/microexpend_view.dart';
import 'package:binancy/views/microexpenses/microexpenses_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class MicroExpensesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BinancyBackground(
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text("Gastos rápidos", style: appBarStyle()),
            actions: [
              IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => MultiProvider(providers: [
                                ChangeNotifierProvider(
                                    create: (_) => Provider.of<
                                        MicroExpensesChangeNotifier>(context)),
                                ChangeNotifierProvider(
                                    create: (_) =>
                                        Provider.of<MovementsChangeNotifier>(
                                            context,
                                            listen: false))
                              ], child: const MicroExpendView()))),
                  icon: const Icon(Icons.add_rounded))
            ],
          ),
          body: Consumer2<MicroExpensesChangeNotifier, MovementsChangeNotifier>(
              builder: (context, microExpensesProvider, movementsProvider,
                      child) =>
                  Column(
                    children: [
                      AdviceCard(
                          icon: SvgPicture.asset(
                              "assets/svg/dashboard_add_expense.svg"),
                          text:
                              "Aqui podrás establecer movimientos que realizes con frequencia y poder añadirlos más rápidamente."),
                      const SpaceDivider(),
                      Center(
                          child: Text("Tus gastos rápidos",
                              style: titleCardStyle())),
                      Expanded(
                          child: Container(
                              margin: const EdgeInsets.all(customMargin),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(customBorderRadius),
                                child: ScrollConfiguration(
                                    behavior: MyBehavior(),
                                    child: StaggeredGridView.countBuilder(
                                      crossAxisCount: 2,
                                      itemCount: microExpensesProvider
                                          .microExpensesList.length,
                                      mainAxisSpacing: customMargin,
                                      crossAxisSpacing: customMargin,
                                      itemBuilder: (context, index) =>
                                          MicroExpendCard(
                                        microExpensesChangeNotifier:
                                            microExpensesProvider,
                                        microExpend: microExpensesProvider
                                            .microExpensesList
                                            .elementAt(index),
                                        movementsChangeNotifier:
                                            movementsProvider,
                                      ),
                                      staggeredTileBuilder: (index) =>
                                          const StaggeredTile.fit(1),
                                    )),
                              )))
                    ],
                  ))),
    );
  }
}
