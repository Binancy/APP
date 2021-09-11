import 'package:binancy/globals.dart';
import 'package:binancy/models/announce.dart';
import 'package:binancy/models/offert.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:flutter/material.dart';

class PlansCarouselWidget extends StatelessWidget {
  final dynamic carouselWidget;

  const PlansCarouselWidget({Key? key, required this.carouselWidget})
      : assert(carouselWidget is Offert || carouselWidget is Announce);

  @override
  Widget build(BuildContext context) {
    if (carouselWidget is Offert) {
      return buildOffertWidget();
    } else if (carouselWidget is Announce) {
      return buildAnnounceWidget();
    }

    return SizedBox();
  }

  Widget buildOffertWidget() {
    return Container(
      decoration: BoxDecoration(
          color: themeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(customBorderRadius)),
    );
  }

  Widget buildAnnounceWidget() {
    return Container(
      decoration: BoxDecoration(
          color: themeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(customBorderRadius)),
    );
  }
}
