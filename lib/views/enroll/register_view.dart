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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:page_transition/page_transition.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool hidePass = true, hideConfirmPass = true, singletonAutoPass = false;
  bool termsPrivacyCheck = false;

  int adviceCurrentPage = 0, registerCurrentPage = 0;

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

  List<AdviceCard> adviceCardList = [];
  String parsedDate = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    parsedDate = AppLocalizations.of(context)!.birthday;
    adviceCardList = Utils.getAllAdviceCards(context);
  }

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
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(AppLocalizations.of(context)!.register_steps(
              registerCurrentPage + 1, registerPageList.length)),
          leading: registerCurrentPage != 0
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      registerCurrentPage--;
                    });
                    registerPageController.animateToPage(registerCurrentPage,
                        duration: const Duration(
                            milliseconds: registerTransitionDuration),
                        curve: Curves.easeOut);
                  })
              : const SizedBox(),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView(children: [
            adviceSlider(context),
            Center(
                child: Text(AppLocalizations.of(context)!.create_your_account,
                    style: titleCardStyle())),
            SizedBox(
              height: MediaQuery.of(context).size.height -
                  (MediaQuery.of(context).padding.top +
                      MediaQuery.of(context).padding.bottom +
                      kToolbarHeight +
                      190),
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: registerPageController,
                onPageChanged: (value) => registerCurrentPage = value,
                children: registerPageList,
              ),
            ),
          ]),
        )));
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
                    AppLocalizations.of(context)!.email, BinancyIcons.email),
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
                      decoration: customInputDecoration(
                          AppLocalizations.of(context)!.password,
                          BinancyIcons.key),
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
                          AppLocalizations.of(context)!.repeat_new_password,
                          BinancyIcons.key),
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
                  text: AppLocalizations.of(context)!.continue_register,
                  action: () => checkFirstStep()),
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.login_button_header,
                style: inputStyle()),
            const SpaceDivider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  customMargin, 0, customMargin, customMargin),
              child: BinancyButton(
                  context: context,
                  text: AppLocalizations.of(context)!.login,
                  action: () {
                    FocusScope.of(context).unfocus();
                    Navigator.pop(context);
                  }),
            )
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
                decoration: customInputDecoration(
                    AppLocalizations.of(context)!.your_name, BinancyIcons.user),
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
                    AppLocalizations.of(context)!.your_first_surname,
                    BinancyIcons.user),
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
                    AppLocalizations.of(context)!.your_last_surname,
                    BinancyIcons.user),
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
                    onTap: () {
                      Utils.unfocusAll(List.of([
                        nameFocusNode,
                        firstSurnameFocusNode,
                        lastSurnameFocusNode
                      ]));
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeftWithFade,
                              child: const PrivacyAndTermsView()));
                    },
                    child: RichText(
                        text: TextSpan(
                            text: AppLocalizations.of(context)!
                                    .register_privacy_terms_1 +
                                " ",
                            style: miniInputStyle(),
                            children: [
                          TextSpan(
                              text: AppLocalizations.of(context)!
                                  .register_privacy_terms_2(
                                      appName, organizationName),
                              style: miniAccentStyle())
                        ])),
                  ))
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: customMargin, right: customMargin, bottom: customMargin),
          child: BinancyButton(
              context: context,
              text: AppLocalizations.of(context)!.register,
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
                  duration:
                      const Duration(milliseconds: registerTransitionDuration),
                  curve: Curves.easeOut);
            });
          } else {
            BinancyInfoDialog(
                context,
                AppLocalizations.of(context)!.password_not_valid +
                    AppLocalizations.of(context)!.password_requirements,
                [
                  BinancyInfoDialogItem(AppLocalizations.of(context)!.accept,
                      () {
                    Navigator.pop(context);
                    passwordFocusNode.requestFocus();
                  })
                ]);
          }
        } else {
          BinancyInfoDialog(
              context, AppLocalizations.of(context)!.password_not_match, [
            BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
              Navigator.pop(context);
              passwordFocusNode.requestFocus();
            })
          ]);
        }
      } else {
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.email_not_valid, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
            Navigator.pop(context);
            emailFocusNode.requestFocus();
          })
        ]);
      }
    } else {
      BinancyInfoDialog(
          context, AppLocalizations.of(context)!.register_data_needed, [
        BinancyInfoDialogItem(
            AppLocalizations.of(context)!.accept, () => Navigator.pop(context))
      ]);
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
        BinancyInfoDialog(context,
            AppLocalizations.of(context)!.register_invalid_terms(appName), [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept,
              () => Navigator.pop(context))
        ]);
      }
    } else {
      BinancyInfoDialog(
          context, AppLocalizations.of(context)!.register_data_needed, [
        BinancyInfoDialogItem(
            AppLocalizations.of(context)!.accept, () => Navigator.pop(context))
      ]);
    }
  }
}
