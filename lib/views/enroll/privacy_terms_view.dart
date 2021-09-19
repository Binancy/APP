import 'package:binancy/utils/ui/styles.dart';
import 'package:flutter/material.dart';

class PrivacyAndTermsView extends StatelessWidget {
  const PrivacyAndTermsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColor,
        title: Text("Política de privacidad", style: appBarStyle()),
      ),
    );
  }
}
