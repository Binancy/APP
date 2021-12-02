import 'package:binancy/globals.dart';
import 'package:binancy/utils/api/conn_api.dart';
import 'package:binancy/utils/api/endpoints.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/dialogs/progress_dialog.dart';
import 'package:binancy/utils/ui/icons.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:binancy/views/enroll/loading_view.dart';
import 'package:binancy/views/enroll/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:page_transition/page_transition.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool showPass = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode userFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        userFocusNode.unfocus();
        passwordFocusNode.unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: BinancyBackground(Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.fromLTRB(customMargin, 0, customMargin, 0),
              child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: Center(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const BinancyLogoVert(),
                              const SpaceDivider(),
                              inputEmailWidget(),
                              const SpaceDivider(),
                              inputPasswordWidget(),
                              const SpaceDivider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                            .forgot_password_1 +
                                        " ",
                                    style: inputStyle(),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .forgot_password_2,
                                    style: accentStyle(),
                                  )
                                ],
                              ),
                              const SpaceDivider(),
                              BinancyButton(
                                  context: context,
                                  text: AppLocalizations.of(context)!.login,
                                  action: () async {
                                    userFocusNode.unfocus();
                                    passwordFocusNode.unfocus();
                                    FocusScope.of(context).unfocus();
                                    await makeLogin();
                                  }),
                              const SpaceDivider(),
                              const SpaceDivider(),
                              Center(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .register_button_header,
                                  style: inputStyle(),
                                ),
                              ),
                              const SpaceDivider(),
                              BinancyButton(
                                  context: context,
                                  text: AppLocalizations.of(context)!.register,
                                  action: () {
                                    FocusScope.of(context).unfocus();
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            childCurrent: widget,
                                            type: PageTransitionType
                                                .rightToLeftJoined,
                                            child: RegisterView()));
                                  }),
                              const SpaceDivider(),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          ))),
    );
  }

  Future<void> makeLogin() async {
    String email = emailController.text;
    String password = Utils.encrypt(passwordController.text);

    if (email.isNotEmpty && passwordController.text.isNotEmpty) {
      if (Utils.verifyEmail(email)) {
        ConnAPI connAPI = ConnAPI(APIEndpoints.LOGIN, "POST", false,
            {'email': email, 'pass': password});
        BinancyProgressDialog progressDialog =
            BinancyProgressDialog(context: context)..showProgressDialog();
        await connAPI.callAPI();
        dynamic response = connAPI.getResponse();
        progressDialog.dismissDialog();
        if (response is BinancyException) {
          BinancyException exception = response;
          BinancyInfoDialog(context, exception.description, [
            BinancyInfoDialogItem(AppLocalizations.of(context)!.accept,
                () => Navigator.pop(context))
          ]);
        } else {
          int? statusResponse = connAPI.getStatus();
          switch (statusResponse) {
            case null:
              BinancyException exception = connAPI.getException()!;
              BinancyInfoDialog(context, exception.description, [
                BinancyInfoDialogItem(AppLocalizations.of(context)!.accept,
                    () => Navigator.pop(context))
              ]);
              break;
            case 200:
              userData = response[0];
              Navigator.pushAndRemoveUntil(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade, child: LoadingView()),
                  (route) => false);
              break;
            case 404:
              BinancyInfoDialog(
                  context, AppLocalizations.of(context)!.login_error_password, [
                BinancyInfoDialogItem(AppLocalizations.of(context)!.accept,
                    () => Navigator.pop(context))
              ]);
          }
        }
      } else {
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.email_not_valid, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
            Navigator.pop(context);
            userFocusNode.requestFocus();
          })
        ]);
      }
    } else {
      BinancyInfoDialog(
          context, AppLocalizations.of(context)!.register_data_needed, [
        BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
          Navigator.pop(context);
          if (emailController.text.isEmpty) {
            userFocusNode.requestFocus();
          } else if (passwordController.text.isEmpty) {
            passwordFocusNode.requestFocus();
          }
        })
      ]);
    }
  }

  Widget inputEmailWidget() {
    return Container(
      height: buttonHeight,
      padding: const EdgeInsets.only(left: customMargin, right: customMargin),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(customBorderRadius),
          color: themeColor.withOpacity(0.1)),
      alignment: Alignment.center,
      child: TextField(
        focusNode: userFocusNode,
        textInputAction: TextInputAction.next,
        onSubmitted: (value) {
          userFocusNode.unfocus();
          passwordFocusNode.requestFocus();
        },
        keyboardType: TextInputType.emailAddress,
        autofillHints: const [AutofillHints.email],
        controller: emailController,
        style: inputStyle(),
        decoration: customInputDecoration(
            AppLocalizations.of(context)!.email, BinancyIcons.email),
      ),
    );
  }

  Widget inputPasswordWidget() {
    return Container(
        height: buttonHeight,
        padding: const EdgeInsets.only(left: customMargin, right: customMargin),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(customBorderRadius),
            color: themeColor.withOpacity(0.1)),
        alignment: Alignment.center,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                focusNode: passwordFocusNode,
                onSubmitted: (value) async {
                  passwordFocusNode.unfocus();
                  await makeLogin();
                },
                controller: passwordController,
                style: inputStyle(),
                autocorrect: false,
                enableSuggestions: false,
                obscureText: showPass,
                decoration: customInputDecoration(
                    AppLocalizations.of(context)!.password, BinancyIcons.key),
              ),
            ),
            IconButton(
                icon: Icon(
                  BinancyIcons.eye,
                  color: accentColor,
                  size: 36,
                ),
                onPressed: () {
                  setState(() {
                    showPass = !showPass;
                  });
                })
          ],
        ));
  }
}
