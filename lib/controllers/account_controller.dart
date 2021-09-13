import 'package:binancy/globals.dart';
import 'package:binancy/utils/api/conn_api.dart';
import 'package:binancy/utils/api/endpoints.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/views/enroll/splash_view.dart';
import 'package:flutter/material.dart';

class AccountController {
  static Future<void> deleteAccount(BuildContext context) async {
    ConnAPI connAPI = ConnAPI(APIEndpoints.DELETE_ACCOUNT, "DELETE", false,
        {"id": userData['idUser']});
    await connAPI.callAPI();

    if (connAPI.getStatus() == 200) {
      await Utils.clearSecureStorage();
      gotoLogin(context);
    } else {
      BinancyException? exception = connAPI.getException();
      if (exception != null) {
        BinancyInfoDialog(context, exception.description,
            [BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))]);
      } else {
        BinancyInfoDialog(context, "Ha ocurrido un error inesperado",
            [BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))]);
      }
    }
  }

  static Future<void> deleteUserData(BuildContext context) async {
    ConnAPI connAPI = ConnAPI(APIEndpoints.DELETE_USER_DATA, "DELETE", false,
        {"id": userData['idUser']});
    await connAPI.callAPI();

    if (connAPI.getStatus() == 200) {
      await Utils.clearSecureStorage();
      gotoLogin(context);
    } else {
      BinancyException? exception = connAPI.getException();
      if (exception != null) {
        BinancyInfoDialog(context, exception.description,
            [BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))]);
      } else {
        BinancyInfoDialog(context, "Ha ocurrido un error inesperado",
            [BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))]);
      }
    }
  }

  static Future<void> changePassword(
      BuildContext context, String newPassword, Function() onSuccess) async {
    ConnAPI connAPI = ConnAPI(APIEndpoints.CHANGE_PASSWORD, "PUT", false,
        {"id": userData['idUser'], "password": Utils.encrypt(newPassword)});
    await connAPI.callAPI();

    if (connAPI.getStatus() == 200) {
      userData['password'] = Utils.encrypt(newPassword);
      BinancyInfoDialog(context, "Contaseña actualizada correctamente",
          [BinancyInfoDialogItem("Aceptar", onSuccess)]);
    } else {
      BinancyException? exception = connAPI.getException();
      if (exception != null) {
        BinancyInfoDialog(context, exception.description,
            [BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))]);
      } else {
        BinancyInfoDialog(context, "Ha ocurrido un error inesperado",
            [BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))]);
      }
    }
  }
}