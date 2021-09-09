import 'package:binancy/models/microexpend.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';

class MicroExpendDialogCard extends StatefulWidget {
  final MicroExpend microExpend;
  final Function() action;

  const MicroExpendDialogCard(
      {Key? key, required this.microExpend, required this.action})
      : super(key: key);

  @override
  _MicroExpendDialogCardState createState() => _MicroExpendDialogCardState();
}

class _MicroExpendDialogCardState extends State<MicroExpendDialogCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(customMargin),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints: BoxConstraints(minHeight: 65 * 2),
            padding: EdgeInsets.all(customMargin),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.microExpend.title,
                    style: titleCardStyle(), textAlign: TextAlign.center),
                SpaceDivider(customSpace: 10),
                widget.microExpend.description != null
                    ? Text(widget.microExpend.description ?? "",
                        style: semititleStyle(),
                        maxLines: 5,
                        textAlign: TextAlign.center)
                    : SizedBox(),
                widget.microExpend.description != null
                    ? SpaceDivider(customSpace: 10)
                    : SizedBox(),
                Text(Utils.parseAmount(widget.microExpend.amount),
                    style: accentTitleStyle())
              ],
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(customBorderRadius),
                color: themeColor.withOpacity(0.1)),
          ),
          SpaceDivider(),
          BinancyButton(
              context: context, text: "Añadir gasto", action: widget.action)
        ],
      ),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(customBorderRadius),
              topRight: Radius.circular(customBorderRadius))),
    );
  }
}
