import 'dart:io';

import 'package:binancy/globals.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyAndTermsView extends StatefulWidget {
  const PrivacyAndTermsView({Key? key}) : super(key: key);

  @override
  State<PrivacyAndTermsView> createState() => _PrivacyAndTermsViewState();
}

class _PrivacyAndTermsViewState extends State<PrivacyAndTermsView> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  bool allowNavigation = true;
  String privacyWebsite = appWebsite + "/privacy";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColor,
        title: Text("Política de privacidad", style: appBarStyle()),
      ),
      extendBody: true,
      backgroundColor: primaryColor,
      body: WebView(
        initialUrl: privacyWebsite,
        javascriptMode: JavascriptMode.unrestricted,
        zoomEnabled: false,
      ),
    );
  }
}
