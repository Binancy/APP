import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';

class DashboardSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashboardSummaryCard();
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
      print(barPercentage);
      return Column(
        children: [
          Text(
            "Tu balance mensual",
            style: titleCardStyle(),
          ),
          SizedBox(
            height: customMargin,
          ),
          Container(
            height: (MediaQuery.of(context).size.height / 10 * 3.65),
            margin: EdgeInsets.only(
              left: customMargin,
              right: customMargin,
            ),
            child: Stack(
              children: [
                Positioned(
                    height: (MediaQuery.of(context).size.height / 10 * 4),
                    width: MediaQuery.of(context).size.width - 42,
                    child: Container(
                      height: (MediaQuery.of(context).size.height / 10 * 4),
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
                        totalBalance >= 1000 || totalBalance <= -1000
                            ? Text(
                                totalBalance.toStringAsFixed(0) + "€",
                                style: balanceValueStyle(),
                              )
                            : Text(
                                totalBalance.toStringAsFixed(2) + "€",
                                style: balanceValueStyle(),
                              ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 5,
                              right: MediaQuery.of(context).size.width / 5),
                          child: Text(
                            'En Julio has ingresado ' +
                                provider
                                    .getThisMonthIncomes()
                                    .ceilToDouble()
                                    .toStringAsFixed(0) +
                                '€ y has gastado ' +
                                provider
                                    .getThisMonthExpenses()
                                    .ceilToDouble()
                                    .toStringAsFixed(0) +
                                '€',
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

  SfRadialGauge radialGauge(double barPercentage) {
    return SfRadialGauge(
      axes: [
        RadialAxis(
          minimum: 0,
          maximum: 1,
          showLabels: false,
          showTicks: false,
          axisLineStyle: AxisLineStyle(
            thickness: 15,
            cornerStyle: CornerStyle.bothCurve,
            color: themeColor.withOpacity(0.1),
          ),
          pointers: [
            RangePointer(
              value: barPercentage,
              color: accentColor,
              cornerStyle: CornerStyle.bothCurve,
              width: 15,
            )
          ],
        )
      ],
    );
  }

  double _getTotalBalance(double totalIncomes, double totalExpenses) {
    if (totalIncomes == totalExpenses) {
      return 0.5;
    } else if (totalIncomes == 0) {
      return 0;
    } else if (totalExpenses == 0) {
      return 1;
    } else if (totalIncomes > totalExpenses) {
      if (totalIncomes / totalExpenses >= (summaryMaxDifference + 1)) {
        return 1;
      } else {
        return (totalIncomes / totalExpenses) / (summaryMaxDifference + 1);
      }
    } else if (totalExpenses > totalIncomes) {
      return (totalIncomes / totalExpenses) / 2;
    }

    return 1;
  }
}
