import 'package:binancy/globals.dart';
import 'package:binancy/utils/styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardChart extends StatelessWidget {
  List<String> _listDates = [
    "Enero",
    "Febrero",
    "Marzo",
    "Abril",
    "Mayo",
    "Junio"
  ];

  double barWidth = 13, spaceBars = 20;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(customBorderRadius)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Tus registros',
              style: titleCardStyle(),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              height: 200,
              child: BarChart(
                BarChartData(
                    titlesData: FlTitlesData(
                        leftTitles: SideTitles(showTitles: false),
                        bottomTitles: SideTitles(
                            showTitles: true,
                            getTitles: (value) => _listDates[value.toInt()])),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    alignment: BarChartAlignment.center,
                    groupsSpace: spaceBars,
                    barGroups: [
                      BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                                y: 2500,
                                width: barWidth,
                                colors: [primaryColor]),
                            BarChartRodData(
                                y: 1350, width: barWidth, colors: [accentColor])
                          ],
                          barsSpace: 5),
                      BarChartGroupData(
                          x: 1,
                          barRods: [
                            BarChartRodData(
                                y: 3824,
                                width: barWidth,
                                colors: [primaryColor]),
                            BarChartRodData(
                                y: 234, width: barWidth, colors: [accentColor])
                          ],
                          barsSpace: 5),
                      BarChartGroupData(
                          x: 2,
                          barRods: [
                            BarChartRodData(
                                y: 543,
                                width: barWidth,
                                colors: [primaryColor]),
                            BarChartRodData(
                                y: 1232,
                                width: barWidth,
                                colors: [accentColor]),
                          ],
                          barsSpace: 5),
                      BarChartGroupData(
                          x: 3,
                          barRods: [
                            BarChartRodData(
                                y: 3824,
                                width: barWidth,
                                colors: [primaryColor]),
                            BarChartRodData(
                                y: 234, width: barWidth, colors: [accentColor])
                          ],
                          barsSpace: 5),
                      BarChartGroupData(
                          x: 4,
                          barRods: [
                            BarChartRodData(
                                y: 543,
                                width: barWidth,
                                colors: [primaryColor]),
                            BarChartRodData(
                                y: 1232, width: barWidth, colors: [accentColor])
                          ],
                          barsSpace: 5),
                      BarChartGroupData(
                          x: 5,
                          barRods: [
                            BarChartRodData(
                                y: 543,
                                width: barWidth,
                                colors: [primaryColor]),
                            BarChartRodData(
                                y: 1232, width: barWidth, colors: [accentColor])
                          ],
                          barsSpace: 5),
                    ]),
                swapAnimationDuration: Duration(milliseconds: 500),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.circle,
                      color: primaryColor,
                    ),
                    Text('Ingresos')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.circle,
                      color: accentColor,
                    ),
                    Text('Gastos')
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
