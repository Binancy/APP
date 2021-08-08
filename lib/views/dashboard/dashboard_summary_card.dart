import 'package:binancy/controllers/providers/dashboard_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/utils/styles.dart';
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
    return Consumer<DashboardChangeNotifier>(builder: (context, value, child) {
      double totalBalance = value.totalIncomes - value.totalExpenses;
      double barPercentage =
          _getTotalBalance(value.totalIncomes, value.totalExpenses);
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
                      child: SfRadialGauge(
                        enableLoadingAnimation: true,
                        animationDuration: 0.5,
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
                                value: 0.5,
                                color: accentColor,
                                cornerStyle: CornerStyle.bothCurve,
                                width: 15,
                              )
                            ],
                          )
                        ],
                      ),
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
                          "+75€",
                          style: balanceValueStyle(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 5,
                              right: MediaQuery.of(context).size.width / 5),
                          child: Text(
                            'En Julio has ingresado 2500€ y has gastado 2575€',
                            style: detailStyle(),
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

  double _getTotalBalance(double totalIncomes, double totalExpenses) {
    if (totalIncomes == totalExpenses) {
      return 0.5;
    } else if (totalIncomes == 0) {
      return 0;
    } else if (totalExpenses == 0) {
      return 1;
    } else if (totalIncomes > totalExpenses) {
      if (totalIncomes / totalExpenses >= 2) {
        return 1;
      } else {
        return (totalIncomes / totalExpenses) / 2;
      }
    } else if (totalExpenses > totalIncomes) {
      return (totalExpenses / totalIncomes) / 2;
    }

    return 1;
  }
}
