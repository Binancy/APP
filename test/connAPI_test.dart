import 'dart:convert';

import 'package:binancy/utils/conn_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Testing "/api/login" call', () async {
    ConnAPI connAPI = ConnAPI('/api/login', "POST", true, {
      'email': 'admin@binancy.com',
      'pass': '973a0f3f1ba4cdeb26c7f87a21928cca16b25db356edb36999a80980de2009e8'
    });
    await connAPI.callAPI();
    List<dynamic>? responseJSON = connAPI.getResponse();
    if (responseJSON != null) {
      print(responseJSON);
    } else {
      print('Error, el JSON no tiene datos');
    }
  });
}
