// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:binancy/globals.dart';
import 'package:http/http.dart';

import '../utils.dart';

class ConnAPI {
  String endpoint = "";
  String method = "";
  Map<String, dynamic>? requestJSON = {};
  bool isTest = false;
  var response;
  Map<String, String> headers = {"Content-Type": "application/json"};
  final bool disableTimeout;

  ConnAPI(this.endpoint, this.method, this.isTest, this.requestJSON,
      {this.disableTimeout = false});

  Future<void> callAPI() async {
    await Utils.hasConnection()
        .timeout(disableTimeout ? const Duration(seconds: 30) : timeout)
        .then((value) async {
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

  int? getStatus() {
    if (response.runtimeType == BinancyException) {
      return null;
    } else {
      return response.statusCode;
    }
  }

  List<dynamic>? getResponse() {
    if (response.runtimeType == BinancyException ||
        response.statusCode != 200) {
      return null;
    } else {
      return List<dynamic>.from(jsonDecode(response.body)['data']);
    }
  }

  Map<String, dynamic>? getRawResponse() {
    if (response.runtimeType == BinancyException ||
        response.statusCode != 200) {
      return null;
    } else {
      return jsonDecode(response.body);
    }
  }

  BinancyException? getException() {
    if (response.runtimeType != BinancyException) {
      return null;
    } else {
      return response;
    }
  }
}

class BinancyException implements Exception {
  final int code;
  final String description;

  BinancyException({required this.code, this.description = ""});
}
