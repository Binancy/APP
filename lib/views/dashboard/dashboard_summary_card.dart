import 'package:binancy/globals.dart';
import 'package:binancy/utils/styles.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';

class DashboardSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 350,
        child: Stack(
          children: [
            Positioned(
              child: ClipPath(
                clipper: DashboardSummaryCardBackgroundClipper(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  color: primaryColor,
                ),
              ),
            ),
            Positioned(
                child: Center(
              child: DashboardSummaryCard(),
            ))
          ],
        ));
  }
}

class DashboardSummaryCardBackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height - 60);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class DashboardSummaryCard extends StatelessWidget {
  const DashboardSummaryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.2),
      margin: EdgeInsets.only(left: 20, right: 20),
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
                            gradient: SweepGradient(
                                colors: [primaryColor, secondaryColor]),
                            cornerStyle: CornerStyle.bothCurve,
                            width: 15,
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
