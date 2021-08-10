import 'package:binancy/globals.dart';
import 'package:binancy/utils/api/conn_api.dart';
import 'package:binancy/utils/api/endpoints.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/styles.dart';
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: BinancyBackground(Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
              padding: EdgeInsets.all(20),
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
                              BinancyLogoVert(),
                              SpaceDivider(),
                              inputEmailWidget(),
                              SpaceDivider(),
                              inputPasswordWidget(),
                              SpaceDivider(),
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
                              SpaceDivider(),
                              BinancyButton(
                                  context: context,
                                  text: "Iniciar sesión",
                                  action: () async {
                                    await makeLogin();
                                  }),
                              SpaceDivider(),
                              SpaceDivider(),
                              Center(
                                child: Text(
                                  "¿Todavía no tienes cuenta?",
                                  style: inputStyle(),
                                ),
                              ),
                              SpaceDivider(),
                              BinancyButton(
                                  context: context,
                                  text: "Registrate",
                                  action: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterView())))
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
        List<dynamic>? response = connAPI.getResponse();
        if (response != null) {
          userData = response[0];
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoadingView()),
              (route) => false);
        } else {
          BinancyInfoDialog(
              context,
              "El correo electrónico o la contraseña son incorretos.",
              [BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))]);
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
      padding: EdgeInsets.only(left: customMargin, right: customMargin),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(customBorderRadius),
          color: themeColor.withOpacity(0.1)),
      alignment: Alignment.center,
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        controller: emailController,
        style: inputStyle(),
        decoration:
            customInputDecoration("Correo electrónico", Icons.email_outlined),
      ),
    );
  }

  Widget inputPasswordWidget() {
    return Container(
        height: buttonHeight,
        padding: EdgeInsets.only(left: customMargin, right: customMargin),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(customBorderRadius),
            color: themeColor.withOpacity(0.1)),
        alignment: Alignment.center,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                onSubmitted: (value) async => await makeLogin(),
                controller: passwordController,
                style: inputStyle(),
                autocorrect: false,
                enableSuggestions: false,
                obscureText: showPass,
                decoration: customInputDecoration(
                    "Contraseña", Icons.radio_button_checked_outlined),
              ),
            ),
            IconButton(
                icon: Icon(
                  Icons.visibility_rounded,
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
