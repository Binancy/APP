import 'package:binancy/globals.dart';
import 'package:binancy/utils/api/conn_api.dart';
import 'package:binancy/utils/api/endpoints.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/ui/icons.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:binancy/views/enroll/loading_view.dart';
import 'package:binancy/views/enroll/register_view.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool showPass = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: BinancyBackground(Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: CustomScrollView(
                      shrinkWrap: true,
                      slivers: [
                        SliverToBoxAdapter(
                            child: Center(
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
                                    "¿Has olvidado tu contraseña? ",
                                    style: inputStyle(),
                                  ),
                                  Text(
                                    "Recuperala",
                                    style: accentStyle(),
                                  )
                                ],
                              ),
                              const SpaceDivider(),
                              BinancyButton(
                                  context: context,
                                  text: "Iniciar sesión",
                                  action: () async {
                                    FocusScope.of(context).unfocus();
                                    await makeLogin();
                                  }),
                              const SpaceDivider(),
                              const SpaceDivider(),
                              Center(
                                child: Text(
                                  "¿Todavía no tienes cuenta?",
                                  style: inputStyle(),
                                ),
                              ),
                              const SpaceDivider(),
                              BinancyButton(
                                  context: context,
                                  text: "Registrate",
                                  action: () {
                                    FocusScope.of(context).unfocus();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterView()));
                                  })
                            ],
                          ),
                        ))
                      ],
                    )),
              )))),
    );
  }

  Future<void> makeLogin() async {
    String email = emailController.text;
    String password = Utils.encrypt(passwordController.text);

    if (email.isNotEmpty && password.isNotEmpty) {
      if (Utils.verifyEmail(email)) {
        ConnAPI connAPI = ConnAPI(APIEndpoints.LOGIN, "POST", false,
            {'email': email, 'pass': password});
        await connAPI.callAPI();
        dynamic response = connAPI.getResponse();
        if (response is BinancyException) {
          BinancyException exception = response;
          BinancyInfoDialog(context, exception.description,
              [BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))]);
        } else {
          int? statusResponse = connAPI.getStatus();
          switch (statusResponse) {
            case null:
              BinancyException exception = connAPI.getException()!;
              BinancyInfoDialog(context, exception.description, [
                BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))
              ]);
              break;
            case 200:
              userData = response[0];
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoadingView()),
                  (route) => false);
              break;
          }
        }
      } else {
        BinancyInfoDialog(
            context,
            "El correo electrónico que has introducido no es válido...",
            [BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))]);
      }
    } else {
      BinancyInfoDialog(context, "Faltan datos por introducirse",
          [BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))]);
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
        textInputAction: TextInputAction.next,
        onSubmitted: (value) => passwordFocusNode.requestFocus(),
        keyboardType: TextInputType.emailAddress,
        controller: emailController,
        style: inputStyle(),
        decoration:
            customInputDecoration("Correo electrónico", BinancyIcons.email),
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
                onSubmitted: (value) async => await makeLogin(),
                controller: passwordController,
                style: inputStyle(),
                autocorrect: false,
                enableSuggestions: false,
                obscureText: showPass,
                decoration:
                    customInputDecoration("Contraseña", BinancyIcons.key),
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
