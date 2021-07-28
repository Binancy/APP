import 'package:binancy/globals.dart';
import 'package:binancy/utils/styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardChartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 375,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                  child: ClipPath(
                clipper: DashboardChartBackgroundClipper(),
                child: Container(
                  height: 375,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [primaryColor, secondaryColor])),
                ),
              )),
              Positioned(
                  child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    height: 50,
                    child: Center(
                      child: Text(
                        'Tu registro mensual',
                        style: whiteTitleCardStyle(),
                      ),
                    ),
                  ),
                  DashboardChart()
                ],
              ))
            ],
          ),
        )
      ],
    );
  }
}

class DashboardChartBackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

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
    return SizedBox(
      height: 275,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.only(left: 20, right: 20),
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
                                  y: 1350,
                                  width: barWidth,
                                  colors: [accentColor])
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
                                  y: 234,
                                  width: barWidth,
                                  colors: [accentColor])
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
                                  y: 234,
                                  width: barWidth,
                                  colors: [accentColor])
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
                                  y: 1232,
                                  width: barWidth,
                                  colors: [accentColor])
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
                                  y: 1232,
                                  width: barWidth,
                                  colors: [accentColor])
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
      ),
    );
  }
}
