import 'package:binancy/controllers/account_controller.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/utils/dialogs/date_dialog.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/ui/icons.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:binancy/views/advice/advice_card.dart';
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

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode verifyPasswordFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();
  FocusNode firstSurnameFocusNode = FocusNode();
  FocusNode lastSurnameFocusNode = FocusNode();

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
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        registerCurrentPage--;
                      });
                      registerPageController.animateToPage(registerCurrentPage,
                          duration: Duration(
                              milliseconds: registerTransitionDuration),
                          curve: Curves.easeOut);
                    })
                : const SizedBox(),
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
              child: SizedBox(
            height: MediaQuery.of(context).size.height -
                (MediaQuery.of(context).padding.top +
                    MediaQuery.of(context).padding.bottom +
                    kToolbarHeight +
                    210),
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
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
            const SpaceDivider(),
            Container(
              margin: const EdgeInsets.only(
                  left: customMargin, right: customMargin),
              height: buttonHeight,
              padding: const EdgeInsets.only(
                  left: customMargin, right: customMargin),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(customBorderRadius),
                  color: themeColor.withOpacity(0.1)),
              alignment: Alignment.center,
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                focusNode: emailFocusNode,
                style: inputStyle(),
                onSubmitted: (value) => passwordFocusNode.requestFocus(),
                decoration: customInputDecoration(
                    "Correo electronico", BinancyIcons.email),
              ),
            ),
            const SpaceDivider(),
            Container(
                margin: const EdgeInsets.only(
                    left: customMargin, right: customMargin),
                height: buttonHeight,
                padding: const EdgeInsets.only(
                    left: customMargin, right: customMargin),
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
                      focusNode: passwordFocusNode,
                      style: inputStyle(),
                      onSubmitted: (value) =>
                          verifyPasswordFocusNode.requestFocus(),
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
            const SpaceDivider(),
            Container(
                margin: const EdgeInsets.only(
                    left: customMargin, right: customMargin),
                height: buttonHeight,
                padding: const EdgeInsets.only(
                    left: customMargin, right: customMargin),
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
                      focusNode: verifyPasswordFocusNode,
                      style: inputStyle(),
                      onSubmitted: (value) {
                        emailFocusNode.unfocus();
                        passwordFocusNode.unfocus();
                        verifyPasswordFocusNode.unfocus();
                        checkFirstStep();
                      },
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
            const SpaceDivider(),
            SizedBox(
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
            const SpaceDivider(),
            Padding(
                padding: const EdgeInsets.only(
                    left: customMargin, right: customMargin),
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
            const SpaceDivider(),
            Container(
              margin: const EdgeInsets.only(
                  left: customMargin, right: customMargin),
              height: buttonHeight,
              padding: const EdgeInsets.only(
                  left: customMargin, right: customMargin),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(customBorderRadius),
                  color: themeColor.withOpacity(0.1)),
              alignment: Alignment.center,
              child: TextField(
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                controller: nameController,
                style: inputStyle(),
                onSubmitted: (value) => firstSurnameFocusNode.requestFocus(),
                focusNode: nameFocusNode,
                decoration:
                    customInputDecoration("Tu nombre", BinancyIcons.user),
              ),
            ),
            const SpaceDivider(),
            Container(
              margin: const EdgeInsets.only(
                  left: customMargin, right: customMargin),
              height: buttonHeight,
              padding: const EdgeInsets.only(
                  left: customMargin, right: customMargin),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(customBorderRadius),
                  color: themeColor.withOpacity(0.1)),
              alignment: Alignment.center,
              child: TextField(
                controller: firstSurnameController,
                style: inputStyle(),
                onSubmitted: (value) => lastSurnameFocusNode.requestFocus(),
                focusNode: firstSurnameFocusNode,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: customInputDecoration(
                    "Tu primer apellido", BinancyIcons.user),
              ),
            ),
            const SpaceDivider(),
            Container(
              margin: const EdgeInsets.only(
                  left: customMargin, right: customMargin),
              height: buttonHeight,
              padding: const EdgeInsets.only(
                  left: customMargin, right: customMargin),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(customBorderRadius),
                  color: themeColor.withOpacity(0.1)),
              alignment: Alignment.center,
              child: TextField(
                controller: lastSurnameController,
                style: inputStyle(),
                onSubmitted: (value) {
                  nameFocusNode.unfocus();
                  firstSurnameFocusNode.unfocus();
                  lastSurnameFocusNode.unfocus();
                },
                focusNode: lastSurnameFocusNode,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: customInputDecoration(
                    "Tu segundo apellido", BinancyIcons.user),
              ),
            ),
            const SpaceDivider(),
            Padding(
              padding: const EdgeInsets.only(
                  left: customMargin, right: customMargin),
              child: Material(
                color: themeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(customBorderRadius),
                child: InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    BinancyDatePicker binancyDatePicker = BinancyDatePicker(
                        context: context,
                        initialDate: Utils.isValidDateYMD(parsedDate, context)
                            ? Utils.fromYMD(parsedDate, context)
                            : DateTime.now());
                    binancyDatePicker.showCustomDialog().then((value) {
                      if (value != null) {
                        setState(() {
                          parsedDate = Utils.toYMD(value, context);
                        });
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(customBorderRadius),
                  highlightColor: themeColor.withOpacity(0.1),
                  splashColor: themeColor.withOpacity(0.1),
                  child: Container(
                      height: buttonHeight,
                      padding: const EdgeInsets.only(
                          left: customMargin, right: customMargin),
                      child: Row(
                        children: [
                          Icon(
                            BinancyIcons.calendar,
                            color: accentColor,
                            size: 36,
                          ),
                          const SpaceDivider(
                            isVertical: true,
                          ),
                          Text(parsedDate, style: inputStyle())
                        ],
                      )),
                ),
              ),
            ),
            const SpaceDivider(),
            Padding(
              padding: const EdgeInsets.only(
                  left: customMargin, right: customMargin),
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
                  Expanded(
                      child: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PrivacyAndTermsView())),
                    child: RichText(
                        text: TextSpan(
                            text: "He leído y acepto ",
                            style: miniInputStyle(),
                            children: [
                          TextSpan(
                              text: "los términos y condiciones de " +
                                  appName +
                                  " y " +
                                  organizationName,
                              style: miniAccentStyle())
                        ])),
                  ))
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: customMargin, right: customMargin),
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
      margin: const EdgeInsets.only(top: customMargin, bottom: customMargin),
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
                  BinancyInfoDialogItem("Aceptar", () {
                    Navigator.pop(context);
                    passwordFocusNode.requestFocus();
                  })
                ]);
          }
        } else {
          BinancyInfoDialog(context, "Las contraseñas no coinciden...", [
            BinancyInfoDialogItem("Aceptar", () {
              Navigator.pop(context);
              passwordFocusNode.requestFocus();
            })
          ]);
        }
      } else {
        BinancyInfoDialog(context, "El correo introducido no es válido...", [
          BinancyInfoDialogItem("Aceptar", () {
            Navigator.pop(context);
            emailFocusNode.requestFocus();
          })
        ]);
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
        await AccountController.registerUser(context, {
          "email": email,
          "password": password,
          "nameUser": name,
          "payDay": 1,
          "firstSurname": firstSurname,
          "lastSurname": lastSurname,
          "birthday": Utils.toISOStandard(birthday),
          "registerDate": Utils.toISOStandard(Utils.getTodayDate()),
          'idPlan': "free",
          'planTitle': "Free"
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
}
