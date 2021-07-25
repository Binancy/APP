import 'package:binancy/globals.dart';
import 'package:binancy/utils/styles.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';

class DashboardSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(customBorderRadius)),
      child: Container(
        height: 300,
        padding: EdgeInsets.all(20),
        child: Stack(
          children: [
            Positioned(
                right: 0,
                left: 0,
                height: 300,
                child: Center(
                  child: SfRadialGauge(
                    animationDuration: 0.5,
                    axes: [
                      RadialAxis(
                        minimum: 0,
                        maximum: 2,
                        showLabels: false,
                        showTicks: false,
                        axisLineStyle: AxisLineStyle(
                          thickness: 15,
                          cornerStyle: CornerStyle.bothCurve,
                          color: accentColor,
                        ),
                        pointers: [
                          RangePointer(
                            value: 0.97,
                            cornerStyle: CornerStyle.bothCurve,
                            width: 15,
                            color: primaryColor,
                          )
                        ],
                      )
                    ],
                  ),
                )),
            Positioned(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Tu balance actual',
                  style: semititleStyle(),
                ),
                Text(
                  "-999.99€",
                  style: balanceValueStyle(),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: Text(
                    'En Julio has ingresado 2500€ y has gastado 2575€',
                    style: detailStyle(),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
