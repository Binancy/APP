import 'package:binancy/globals.dart';
import 'package:binancy/utils/styles.dart';
import 'package:binancy/utils/widgets.dart';
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
      child: BalancyBackground(Scaffold(
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
                                  action: makeLogin),
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
                                  action: () {})
                            ],
                          ),
                        ))
                      ],
                    )),
              )))),
    );
  }

  void makeLogin() {}

  Widget inputEmailWidget() {
    return Container(
      height: buttonHeight,
      padding: EdgeInsets.only(left: customMargin, right: customMargin),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(customBorderRadius),
          color: themeColor.withOpacity(0.1)),
      alignment: Alignment.center,
      child: TextField(
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
