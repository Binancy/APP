import 'dart:ui';

import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../globals.dart';

class BinancyProgressDialog {
  final BuildContext context;
  final String? customText;

  BinancyProgressDialog({required this.context, this.customText});

  void showProgressDialog() {
    showGeneralDialog(
        context: context,
        barrierColor: Colors.transparent,
        transitionDuration:
            const Duration(milliseconds: progressDialogBlurAnimation),
        transitionBuilder: (context, anim1, anim2, child) => BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
              child: FadeTransition(
                child: child,
                opacity: anim1,
              ),
            ),
        pageBuilder: (context, animation, secondaryAnimation) => Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(customBorderRadius),
                      color: Colors.white),
                  margin: const EdgeInsets.all(customMargin * 1.5),
                  padding: const EdgeInsets.all(customMargin),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    constraints: const BoxConstraints(minHeight: 100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(
                              backgroundColor: accentColor,
                              color: secondaryColor,
                              strokeWidth: 4.5,
                            )),
                        const SpaceDivider(isVertical: true),
                        Expanded(
                            child: Text(
                          customText ??
                              AppLocalizations.of(context)!.please_wait,
                          style: dialogStyle(),
                          textAlign: TextAlign.start,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ))
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  void dismissDialog() {
    Navigator.pop(context);
  }
}
