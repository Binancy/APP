import 'package:binancy/globals.dart';
import 'package:binancy/utils/api/conn_api.dart';
import 'package:binancy/utils/api/endpoints.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/ui/icons.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:binancy/views/advice/advice_card.dart';
import 'package:binancy/views/enroll/loading_view.dart';
import 'package:binancy/views/enroll/privacy_terms_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool hidePass = true, hideConfirmPass = true, singletonAutoPass = false;
  bool termsPrivacyCheck = false;

  int adviceCurrentPage = 0, registerCurrentPage = 0;
  int autoPassAdviceInterval = 5;
  int adviceTransitionDuration = 500, registerTransitionDuration = 750;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController verifyPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController firstSurnameController = TextEditingController();
  TextEditingController lastSurnameController = TextEditingController();

  late PageController advicePageController, registerPageController;

  _RegisterViewState() {
    advicePageController = PageController(initialPage: adviceCurrentPage);

    registerPageController = PageController(initialPage: registerCurrentPage);
  }

  List<AdviceCard> adviceCardList = Utils.getAllAdviceCards();
  String parsedDate = "Tu fecha de nacimiento";

  @override
  Widget build(BuildContext context) {
    if (!singletonAutoPass) {
      autoForwardAdvices();
    }
    List<Widget> registerPageList = [
      registerFirstStep(context),
      registerSecondStep(context)
    ];

    return BinancyBackground(Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(slivers: [
          SliverAppBar(
            elevation: 0,
            centerTitle: true,
            title: Text("Paso " +
                (registerCurrentPage + 1).toString() +
                " de " +
                registerPageList.length.toString()),
            leading: registerCurrentPage != 0
                ? IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        registerCurrentPage--;
                      });
                      registerPageController.animateToPage(registerCurrentPage,
                          duration: Duration(
                              milliseconds: registerTransitionDuration),
                          curve: Curves.easeOut);
                    })
                : SizedBox(),
            backgroundColor: Colors.transparent,
            pinned: false,
            snap: true,
            floating: true,
          ),
          SliverToBoxAdapter(child: adviceSlider(context)),
          SliverToBoxAdapter(
              child: Center(
                  child: Text("Crea tu cuenta", style: titleCardStyle()))),
          SliverToBoxAdapter(
              child: Container(
            height: MediaQuery.of(context).size.height -
                (MediaQuery.of(context).padding.top +
                    MediaQuery.of(context).padding.bottom +
                    kToolbarHeight +
                    210),
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: registerPageController,
              onPageChanged: (value) => registerCurrentPage = value,
              children: registerPageList,
            ),
          )),
        ])));
  }

  Widget registerFirstStep(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SpaceDivider(),
            Container(
              margin: EdgeInsets.only(left: customMargin, right: customMargin),
              height: buttonHeight,
              padding: EdgeInsets.only(left: customMargin, right: customMargin),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(customBorderRadius),
                  color: themeColor.withOpacity(0.1)),
              alignment: Alignment.center,
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                style: inputStyle(),
                decoration: customInputDecoration(
                    "Correo electronico", BinancyIcons.email),
              ),
            ),
            SpaceDivider(),
            Container(
                margin:
                    EdgeInsets.only(left: customMargin, right: customMargin),
                height: buttonHeight,
                padding:
                    EdgeInsets.only(left: customMargin, right: customMargin),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(customBorderRadius),
                    color: themeColor.withOpacity(0.1)),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: TextField(
                      controller: passwordController,
                      obscureText: hidePass,
                      style: inputStyle(),
                      decoration:
                          customInputDecoration("Contraseña", BinancyIcons.key),
                    )),
                    IconButton(
                        icon: Icon(
                          BinancyIcons.eye,
                          color: accentColor,
                          size: 36,
                        ),
                        onPressed: () {
                          setState(() {
                            hidePass = !hidePass;
                          });
                        })
                  ],
                )),
            SpaceDivider(),
            Container(
                margin:
                    EdgeInsets.only(left: customMargin, right: customMargin),
                height: buttonHeight,
                padding:
                    EdgeInsets.only(left: customMargin, right: customMargin),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(customBorderRadius),
                    color: themeColor.withOpacity(0.1)),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: TextField(
                      controller: verifyPasswordController,
                      obscureText: hideConfirmPass,
                      style: inputStyle(),
                      decoration: customInputDecoration(
                          "Confirma tu contraseña", BinancyIcons.key),
                    )),
                    IconButton(
                        icon: Icon(
                          BinancyIcons.eye,
                          color: accentColor,
                          size: 36,
                        ),
                        onPressed: () {
                          setState(() {
                            hideConfirmPass = !hideConfirmPass;
                          });
                        })
                  ],
                )),
            SpaceDivider(),
            Container(
              height: buttonHeight,
              width: MediaQuery.of(context).size.width - (customMargin * 2),
              child: BinancyButton(
                  context: context,
                  text: "Continuar registro",
                  action: () => checkFirstStep()),
            )
          ],
        ),
        Column(
          children: [
            Text("¿Ya tienes cuenta?", style: inputStyle()),
            SpaceDivider(),
            Padding(
                padding:
                    EdgeInsets.only(left: customMargin, right: customMargin),
                child: BinancyButton(
                    context: context,
                    text: "Iniciar sesión",
                    action: () {
                      FocusScope.of(context).unfocus();
                      Navigator.pop(context);
                    }))
          ],
        )
      ],
    );
  }

  Widget registerSecondStep(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SpaceDivider(),
            Container(
              margin: EdgeInsets.only(left: customMargin, right: customMargin),
              height: buttonHeight,
              padding: EdgeInsets.only(left: customMargin, right: customMargin),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(customBorderRadius),
                  color: themeColor.withOpacity(0.1)),
              alignment: Alignment.center,
              child: TextField(
                controller: nameController,
                style: inputStyle(),
                decoration:
                    customInputDecoration("Tu nombre", BinancyIcons.user),
              ),
            ),
            SpaceDivider(),
            Container(
              margin: EdgeInsets.only(left: customMargin, right: customMargin),
              height: buttonHeight,
              padding: EdgeInsets.only(left: customMargin, right: customMargin),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(customBorderRadius),
                  color: themeColor.withOpacity(0.1)),
              alignment: Alignment.center,
              child: TextField(
                controller: firstSurnameController,
                style: inputStyle(),
                decoration: customInputDecoration(
                    "Tu primer apellido", BinancyIcons.user),
              ),
            ),
            SpaceDivider(),
            Container(
              margin: EdgeInsets.only(left: customMargin, right: customMargin),
              height: buttonHeight,
              padding: EdgeInsets.only(left: customMargin, right: customMargin),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(customBorderRadius),
                  color: themeColor.withOpacity(0.1)),
              alignment: Alignment.center,
              child: TextField(
                controller: lastSurnameController,
                style: inputStyle(),
                decoration: customInputDecoration(
                    "Tu segundo apellido", BinancyIcons.user),
              ),
            ),
            SpaceDivider(),
            Padding(
              padding: EdgeInsets.only(left: customMargin, right: customMargin),
              child: Material(
                color: themeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(customBorderRadius),
                child: InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1970),
                            lastDate: DateTime(DateTime.now().year + 1))
                        .then((value) {
                      setState(() {
                        parsedDate = DateFormat.yMd(
                                Localizations.localeOf(context).toLanguageTag())
                            .format(value!);
                      });
                    });
                  },
                  borderRadius: BorderRadius.circular(customBorderRadius),
                  highlightColor: Colors.transparent,
                  splashColor: themeColor.withOpacity(0.1),
                  child: Container(
                      height: buttonHeight,
                      padding: EdgeInsets.only(
                          left: customMargin, right: customMargin),
                      child: Row(
                        children: [
                          Icon(
                            BinancyIcons.calendar,
                            color: accentColor,
                            size: 36,
                          ),
                          SpaceDivider(
                            isVertical: true,
                          ),
                          Text(parsedDate, style: inputStyle())
                        ],
                      )),
                ),
              ),
            ),
            SpaceDivider(),
            Padding(
              padding: EdgeInsets.only(left: customMargin, right: customMargin),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                      checkColor: accentColor,
                      value: termsPrivacyCheck,
                      onChanged: (value) {
                        setState(() {
                          termsPrivacyCheck = !termsPrivacyCheck;
                        });
                      }),
                  Text(
                    "He leído y acepto los ",
                    style: miniInputStyle(),
                  ),
                  GestureDetector(
                    child: Text(
                      "términos y condiciones de uso",
                      style: miniAccentStyle(),
                    ),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PrivacyAndTermsView())),
                  )
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: customMargin, right: customMargin),
          child: BinancyButton(
              context: context,
              text: "Registrate",
              action: () {
                FocusScope.of(context).unfocus();
                checkSecondStep();
              }),
        )
      ],
    );
  }

  Widget adviceSlider(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: customMargin, bottom: customMargin),
      height: 125,
      width: MediaQuery.of(context).size.width,
      child: PageView(
        controller: advicePageController,
        children: adviceCardList,
        onPageChanged: (value) => adviceCurrentPage = value,
      ),
    );
  }

  void autoForwardAdvices() async {
    singletonAutoPass = true;
    await Future.delayed(Duration(seconds: autoPassAdviceInterval));
    adviceCurrentPage < adviceCardList.length - 1
        ? adviceCurrentPage++
        : adviceCurrentPage = 0;
    if (mounted) {
      advicePageController.animateToPage(adviceCurrentPage,
          duration: Duration(milliseconds: adviceTransitionDuration),
          curve: Curves.easeOut);
      autoForwardAdvices();
    }
  }

  void checkFirstStep() async {
    String email = emailController.text;
    String password = passwordController.text;
    String verifyPassword = verifyPasswordController.text;

    if (email.isNotEmpty && password.isNotEmpty && verifyPassword.isNotEmpty) {
      if (Utils.verifyEmail(email)) {
        if (password == verifyPassword) {
          if (Utils.verifySecurityPassword(password)) {
            setState(() {
              registerCurrentPage++;
              registerPageController.animateToPage(registerCurrentPage,
                  duration: Duration(milliseconds: registerTransitionDuration),
                  curve: Curves.easeOut);
            });
          } else {
            BinancyInfoDialog(
                context,
                "La contraseña introducida no es válida.\n\nLa contraseña debe tener una longitud mínima de 8 carácteres y contener como mínimo 1 mayúscula, 1 minúscula, 1 numéro y 1 carácter especial",
                [
                  BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))
                ]);
          }
        } else {
          BinancyInfoDialog(context, "Las contraseñas no coinciden...",
              [BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))]);
        }
      } else {
        BinancyInfoDialog(context, "El correo introducido no es válido...",
            [BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))]);
      }
    } else {
      BinancyInfoDialog(context, "Faltan datos por introducirse",
          [BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))]);
    }
  }

  void checkSecondStep() async {
    String name = nameController.text;
    String firstSurname = firstSurnameController.text;
    String lastSurname = lastSurnameController.text;

    if (name.isNotEmpty && parsedDate.isNotEmpty) {
      if (termsPrivacyCheck) {
        DateTime birthday =
            DateFormat.yMd(Localizations.localeOf(context).toLanguageTag())
                .parse(parsedDate);

        String email = emailController.text;
        String password = Utils.encrypt(passwordController.text);

        await makeRegister({
          "data": {
            "email": email,
            "password": password,
            "name": name,
            "firstSurname": firstSurname,
            "lastSurname": lastSurname,
            "birthday": Utils.toISOStandard(birthday)
          }
        });
      } else {
        BinancyInfoDialog(context, "Debes aceptar los términos y condiciones",
            [BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))]);
      }
    } else {
      BinancyInfoDialog(context, "Faltan datos por introducirse",
          [BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))]);
    }
  }

  Future<void> makeRegister(Map<String, dynamic> userData) async {
    ConnAPI connAPI = ConnAPI(APIEndpoints.REGISTER, "POST", false, userData);
    await connAPI.callAPI();
    if (connAPI.getStatus() == 200) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoadingView()),
          (route) => false);
    } else {
      BinancyInfoDialog(
          context,
          "Ha ocurrido un error al registrarte, intentalo más tarde",
          [BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))]);
    }
  }
}
