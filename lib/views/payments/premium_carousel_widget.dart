import 'package:binancy/globals.dart';
import 'package:binancy/models/announce.dart';
import 'package:binancy/models/offert.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:flutter/material.dart';

class PlansCarouselWidget extends StatelessWidget {
  final dynamic carouselWidget;

  const PlansCarouselWidget({Key? key, required this.carouselWidget})
      : assert(carouselWidget is Offert || carouselWidget is Announce);

  @override
  Widget build(BuildContext context) {
    if (carouselWidget is Offert) {
      return buildOffertWidget(context);
    } else if (carouselWidget is Announce) {
      return buildAnnounceWidget(context);
    }

    return const SizedBox();
  }

  Widget buildOffertWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: themeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(customBorderRadius)),
    );
  }

  Widget buildAnnounceWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(customMargin, 0, customMargin, 0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: themeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(customBorderRadius)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 75, width: 75, child: carouselWidget.icon),
          const SpaceDivider(customSpace: 5),
          Text(carouselWidget.title,
              style: accentTitleStyle(),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          const SpaceDivider(customSpace: 5),
          Text(
            carouselWidget.description,
            style: miniInputStyle(),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
