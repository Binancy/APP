import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const DashboardSummaryCard();
  }
}

class DashboardSummaryCard extends StatelessWidget {
  const DashboardSummaryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MovementsChangeNotifier>(
        builder: (context, provider, child) {
      double totalBalance =
          provider.getThisMonthIncomes() - provider.getThisMonthExpenses();
      double barPercentage = _getTotalBalance(
          provider.getThisMonthIncomes(), provider.getThisMonthExpenses());
      return Column(
        children: [
          Text(
            AppLocalizations.of(context)!.your_monthly_balance,
            style: titleCardStyle(),
          ),
          const SizedBox(
            height: customMargin,
          ),
          Container(
            height: (MediaQuery.of(context).size.height / 10 * 3.5),
            margin: const EdgeInsets.only(
              left: customMargin,
              right: customMargin,
            ),
            child: Stack(
              children: [
                Positioned(
                    height: (MediaQuery.of(context).size.height / 10 * 3.8),
                    width: MediaQuery.of(context).size.width - 42,
                    child: SizedBox(
                      height: (MediaQuery.of(context).size.height / 10 * 3.8),
                      child: radialGauge(barPercentage),
                    )),
                Positioned(
                    child: SizedBox(
                  height: (MediaQuery.of(context).size.height / 10 * 4),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          Utils.parseAmount(totalBalance, amountToRound: 1000),
                          style: balanceValueStyle(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 5,
                              right: MediaQuery.of(context).size.width / 5),
                          child: Text(
                            AppLocalizations.of(context)!
                                .dashboard_summary_widget_description(
                                    Utils.roundDown(
                                            provider.getThisMonthIncomes(), 0)
                                        .toStringAsFixed(0),
                                    Utils.roundDown(
                                            provider.getThisMonthExpenses(), 0)
                                        .toStringAsFixed(0),
                                    currency),
                            style: dashboardActionButtonStyle(),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                ))
              ],
            ),
          )
        ],
      );
    });
  }

  Widget radialGauge(double barPercentage) {
    return SfRadialGauge(
      axes: [
        RadialAxis(
          minimum: 0,
          maximum: 2,
          showLabels: false,
          showTicks: false,
          axisLineStyle: AxisLineStyle(
            thickness: 15,
            cornerStyle: CornerStyle.bothCurve,
            color: themeColor.withOpacity(0.1),
          ),
          pointers: [
            RangePointer(
              pointerOffset: 0,
              enableAnimation: true,
              animationDuration: 1500,
              animationType: AnimationType.ease,
              value: barPercentage,
              color: accentColor,
              cornerStyle: CornerStyle.bothCurve,
              width: 15,
            )
          ],
        )
      ],
      enableLoadingAnimation: true,
    );
  }

  double _getTotalBalance(double totalIncomes, double totalExpenses) {
    if (totalIncomes == totalExpenses) {
      return 1;
    } else if (totalIncomes == 0) {
      return 0;
    } else if (totalExpenses == 0) {
      return 2;
    } else if (totalIncomes > totalExpenses) {
      return 2 - (totalExpenses / totalIncomes);
    } else if (totalExpenses > totalIncomes) {
      return (totalIncomes / totalExpenses);
    }
    return 2;
  }
}
