import 'dart:convert';

import 'package:binancy/globals.dart';
import 'package:http/http.dart';

class ConnAPI {
  String endpoint = "";
  String method = "";
  Map<String, dynamic>? requestJSON = {};
  bool isTest = false;
  var response;
  Map<String, String> headers = {"Content-Type": "application/json"};

  ConnAPI(String endpoint, String method, bool isTest,
      Map<String, dynamic>? requestJSON) {
    this.endpoint = endpoint;
    this.method = method;
    this.isTest = isTest;
    this.requestJSON = requestJSON;
  }

  Future<void> callAPI() async {
    switch (method) {
      case "GET":
        isTest
            ? response =
                await get(Uri.parse(testURL + endpoint), headers: headers)
            : response =
                await get(Uri.parse(apiURL + endpoint), headers: headers);
        break;
      case "POST":
        isTest
            ? response = await post(Uri.parse(testURL + endpoint),
                body: requestJSON != null ? jsonEncode(requestJSON) : null,
                headers: headers)
            : response = await post(Uri.parse(apiURL + endpoint),
                body: requestJSON != null ? jsonEncode(requestJSON) : null,
                headers: headers);
        break;
      case "PUT":
        isTest
            ? response = await put(Uri.parse(testURL + endpoint),
                body: requestJSON != null ? jsonEncode(requestJSON) : null,
                headers: headers)
            : response = await put(Uri.parse(apiURL + endpoint),
                body: requestJSON != null ? jsonEncode(requestJSON) : null,
                headers: headers);
        break;
      case "DELETE":
        isTest
            ? response = await delete(Uri.parse(testURL + endpoint),
                body: requestJSON != null ? jsonEncode(requestJSON) : null,
                headers: headers)
            : response = await delete(Uri.parse(apiURL + endpoint),
                body: requestJSON != null ? jsonEncode(requestJSON) : null,
                headers: headers);
        break;
      default:
        throw "Unimplemented method to call... Aborting";
    }
  }

  int getStatus() {
    return response.statusCode;
  }

  dynamic getResponse() {
    if (response.statusCode == 200) {
      return List<dynamic>.from(jsonDecode(response.body)['data']);
    } else {
      return null;
    }
  }
}
