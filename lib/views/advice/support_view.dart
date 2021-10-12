import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:binancy/views/advice/advice_card.dart';
import 'package:binancy/views/settings/settings_view.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../globals.dart';

class SupportView extends StatefulWidget {
  const SupportView({Key? key}) : super(key: key);

  @override
  _SupportViewState createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {
  bool singletonAutoPass = false;
  late PageController advicePageController;
  int adviceCurrentPage = 0;
  List<AdviceCard> adviceCardList = [];
  GlobalKey scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    advicePageController = PageController(initialPage: adviceCurrentPage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    adviceCardList = buildSupportAdviceCards();
  }

  @override
  void dispose() {
    advicePageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!singletonAutoPass) {
      autoForwardAdvices();
    }

    return BinancyBackground(Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(AppLocalizations.of(context)!.support),
      ),
      body: Column(
        children: [
          const SpaceDivider(),
          SizedBox(
              height: 125,
              child: PageView(
                  controller: advicePageController,
                  onPageChanged: (value) => adviceCurrentPage = value,
                  children: adviceCardList)),
          const SpaceDivider(),
          Padding(
            padding:
                const EdgeInsets.only(left: customMargin, right: customMargin),
            child: Material(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(customBorderRadius),
              elevation: 0,
              child: InkWell(
                onTap: () => launch(Mailto(
                  to: [supportEmail],
                  subject: "Support - " + appName,
                ).toString()),
                borderRadius: BorderRadius.circular(customBorderRadius),
                child: Column(
                  children: [
                    const BinancyHeaderRow(text: "Envia un correo electrónico"),
                    const LinearDivider(),
                    Padding(
                      padding: const EdgeInsets.all(customMargin),
                      child: Text(
                        "Rellena y envia un correo electrónico al equipo de soporte explicando tu problema, " +
                            appName +
                            " usará el correo electrónico de tu cuenta para contestar",
                        style: inputStyle(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SpaceDivider(),
          Padding(
            padding:
                const EdgeInsets.only(left: customMargin, right: customMargin),
            child: Material(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(customBorderRadius),
              elevation: 0,
              child: InkWell(
                onTap: () {
                  BetterFeedback.of(context).show((feedback) async =>
                      BinancyInfoDialog(
                          context, "¡Reporte enviado correctamente!", [
                        BinancyInfoDialogItem(
                            AppLocalizations.of(context)!.accept,
                            () => Navigator.pop(context))
                      ]));
                },
                borderRadius: BorderRadius.circular(customBorderRadius),
                child: Column(
                  children: [
                    const BinancyHeaderRow(text: "Enviar feedback"),
                    const LinearDivider(),
                    Padding(
                      padding: const EdgeInsets.all(customMargin),
                      child: Text(
                        "Con esta opción podrás enviar una captura de pantalla, poder resaltar la zona concreta del problema y explicar el problema como comentario de la captura. Para poder ir a otras pantallas pulsa el icono \"Navigate\"",
                        style: inputStyle(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SpaceDivider(customSpace: 40),
          Center(
            child:
                Text("Correo electrónico de contacto", style: miniInputStyle()),
          ),
          Center(
            child: Text(supportEmail, style: accentStyle()),
          )
        ],
      ),
    ));
  }

  List<AdviceCard> buildSupportAdviceCards() {
    List<AdviceCard> supportAdviceCards = [];

    supportAdviceCards.add(AdviceCard(
        icon: SvgPicture.asset("assets/svg/dashboard_settings.svg"),
        text: appName +
            " te permite ponerte en contacto con el equipo de soporte de 2 maneras distintas."));

    supportAdviceCards.add(AdviceCard(
        icon: SvgPicture.asset("assets/svg/dashboard_settings.svg"),
        text:
            "Puedes contactar con soporte enviando un correo electrónico directamente y explicando el problema"));

    supportAdviceCards.add(AdviceCard(
        icon: SvgPicture.asset("assets/svg/dashboard_settings.svg"),
        text:
            "O también puedes hacer una captura de pantalla y comentar el problema tocando la opción \"Enviar feedback\""));

    return supportAdviceCards;
  }

  void autoForwardAdvices() async {
    singletonAutoPass = true;
    await Future.delayed(const Duration(seconds: autoPassAdviceInterval));
    adviceCurrentPage < adviceCardList.length - 1
        ? adviceCurrentPage++
        : adviceCurrentPage = 0;
    if (mounted) {
      advicePageController.animateToPage(adviceCurrentPage,
          duration: const Duration(milliseconds: adviceTransitionDuration),
          curve: Curves.easeOut);
      autoForwardAdvices();
    }
  }
}
