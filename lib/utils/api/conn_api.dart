import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:binancy/globals.dart';
import 'package:http/http.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnAPI {
  String endpoint = "";
  String method = "";
  Map<String, dynamic>? requestJSON = {};
  bool isTest = false;
  var response;
  Map<String, String> headers = {"Content-Type": "application/json"};

  Duration timeout = Duration(milliseconds: 3500);

  ConnAPI(String endpoint, String method, bool isTest,
      Map<String, dynamic>? requestJSON) {
    this.endpoint = endpoint;
    this.method = method;
    this.isTest = isTest;
    this.requestJSON = requestJSON;
  }

  Future<void> callAPI() async {
    hasConnection().timeout(timeout).then((value) async {
      if (value) {
        try {
          switch (method) {
            case "GET":
              isTest
                  ? response =
                      await get(Uri.parse(testURL + endpoint), headers: headers)
                          .timeout(timeout)
                  : response =
                      await get(Uri.parse(apiURL + endpoint), headers: headers)
                          .timeout(timeout);
              break;
            case "POST":
              isTest
                  ? response = await post(Uri.parse(testURL + endpoint),
                          body: requestJSON != null
                              ? jsonEncode(requestJSON)
                              : null,
                          headers: headers)
                      .timeout(timeout)
                  : response = await post(Uri.parse(apiURL + endpoint),
                          body: requestJSON != null
                              ? jsonEncode(requestJSON)
                              : null,
                          headers: headers)
                      .timeout(timeout);
              break;
            case "PUT":
              isTest
                  ? response = await put(Uri.parse(testURL + endpoint),
                          body: requestJSON != null
                              ? jsonEncode(requestJSON)
                              : null,
                          headers: headers)
                      .timeout(timeout)
                  : response = await put(Uri.parse(apiURL + endpoint),
                          body: requestJSON != null
                              ? jsonEncode(requestJSON)
                              : null,
                          headers: headers)
                      .timeout(timeout);
              break;
            case "DELETE":
              isTest
                  ? response = await delete(Uri.parse(testURL + endpoint),
                          body: requestJSON != null
                              ? jsonEncode(requestJSON)
                              : null,
                          headers: headers)
                      .timeout(timeout)
                  : response = await delete(Uri.parse(apiURL + endpoint),
                          body: requestJSON != null
                              ? jsonEncode(requestJSON)
                              : null,
                          headers: headers)
                      .timeout(timeout);
              break;
            default:
              throw "Unimplemented method to call... Aborting";
          }
        } on TimeoutException catch (_) {
          response = BinancyException(
              code: BinancyErrorCodes.ERROR_CONNECTION_TIMEOUT,
              description: "Tiempo de espera agotado. Inténtalo más tarde");
        } on SocketException catch (_) {
          response = BinancyException(
              code: BinancyErrorCodes.ERROR_CONNECTION_UNAVAIABLE,
              description: "No dispones de conexión a internet");
        }
      } else {
        response = BinancyException(
            code: BinancyErrorCodes.ERROR_CONNECTION_UNAVAIABLE,
            description: "No dispones de conexión a internet");
      }
    });
  }

  Future<bool> hasConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  int getStatus() {
    return response.statusCode;
  }

  dynamic getResponse() {
    print(response.runtimeType);
    if (response.runtimeType == BinancyException) {
      return response;
    } else {
      if (response.statusCode == 200) {
        return List<dynamic>.from(jsonDecode(response.body)['data']);
      } else {
        return getStatus();
      }
    }
  }
}

class BinancyException implements Exception {
  final int code;
  final String description;

  BinancyException({required this.code, this.description = ""});
}
