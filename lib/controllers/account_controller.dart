import 'package:binancy/globals.dart';
import 'package:binancy/utils/api/conn_api.dart';
import 'package:binancy/utils/api/endpoints.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/dialogs/progress_dialog.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/views/enroll/loading_view.dart';
import 'package:binancy/views/enroll/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountController {
  static Future<void> registerUser(
      BuildContext context, Map<String, dynamic> registerData) async {
    ConnAPI connAPI = ConnAPI(
        APIEndpoints.REGISTER, "POST", false, {"data": registerData},
        disableTimeout: true);
    BinancyProgressDialog binancyProgressDialog =
        BinancyProgressDialog(context: context)..showProgressDialog();
    await connAPI.callAPI();
    binancyProgressDialog.dismissDialog();
    if (connAPI.getStatus() == 200) {
      userData = registerData;
      Map<String, dynamic>? responseJSON = connAPI.getRawResponse();
      if (responseJSON != null) {
        userData['idUser'] = responseJSON['data'];
        Utils.saveOnSecureStorage("token", responseJSON['token']);
        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                child: LoadingView(),
                type: PageTransitionType.rightToLeftWithFade),
            (route) => false);
      } else {
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.register_error, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept,
              () => Navigator.pop(context))
        ]);
      }
    } else {
      BinancyInfoDialog(context, AppLocalizations.of(context)!.register_error, [
        BinancyInfoDialogItem(
            AppLocalizations.of(context)!.accept, () => Navigator.pop(context))
      ]);
    }
  }

  static Future<void> deleteAccount(BuildContext context) async {
    ConnAPI connAPI = ConnAPI(APIEndpoints.DELETE_ACCOUNT, "DELETE", false,
        {"id": userData['idUser']});
    BinancyProgressDialog binancyProgressDialog =
        BinancyProgressDialog(context: context);
    binancyProgressDialog.showProgressDialog();
    await connAPI.callAPI();
    binancyProgressDialog.dismissDialog();
    if (connAPI.getStatus() == 200) {
      await Utils.clearSecureStorage();
      gotoLogin(context);
    } else {
      BinancyException? exception = connAPI.getException();
      if (exception != null) {
        BinancyInfoDialog(context, exception.description, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept,
              () => Navigator.pop(context))
        ]);
      } else {
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.unexpected_error, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept,
              () => Navigator.pop(context))
        ]);
      }
    }
  }

  static Future<bool> deleteUserData(BuildContext context) async {
    ConnAPI connAPI = ConnAPI(APIEndpoints.DELETE_USER_DATA, "DELETE", false,
        {"id": userData['idUser']});
    BinancyProgressDialog binancyProgressDialog =
        BinancyProgressDialog(context: context);
    binancyProgressDialog.showProgressDialog();
    await connAPI.callAPI();
    binancyProgressDialog.dismissDialog();
    if (connAPI.getStatus() == 200) {
      BinancyInfoDialog(
          context, AppLocalizations.of(context)!.user_data_delete_success, [
        BinancyInfoDialogItem(
            AppLocalizations.of(context)!.accept, () => Navigator.pop(context))
      ]);
      return true;
    } else {
      BinancyException? exception = connAPI.getException();
      if (exception != null) {
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.user_data_delete_error, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept,
              () => Navigator.pop(context))
        ]);
      } else {
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.unexpected_error, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept,
              () => Navigator.pop(context))
        ]);
      }
      return false;
    }
  }

  static Future<void> changePassword(
      BuildContext context, String newPassword, Function() onSuccess) async {
    ConnAPI connAPI = ConnAPI(APIEndpoints.CHANGE_PASSWORD, "PUT", false,
        {"id": userData['idUser'], "password": Utils.encrypt(newPassword)});
    BinancyProgressDialog binancyProgressDialog =
        BinancyProgressDialog(context: context)..showProgressDialog();
    await connAPI.callAPI();
    binancyProgressDialog.dismissDialog();
    if (connAPI.getStatus() == 200) {
      userData['password'] = Utils.encrypt(newPassword);
      BinancyInfoDialog(
          context, AppLocalizations.of(context)!.password_update_success, [
        BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, onSuccess)
      ]);
    } else {
      BinancyException? exception = connAPI.getException();
      if (exception != null) {
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.password_update_error, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept,
              () => Navigator.pop(context))
        ]);
      } else {
        BinancyInfoDialog(
            context, AppLocalizations.of(context)!.unexpected_error, [
          BinancyInfoDialogItem(AppLocalizations.of(context)!.accept,
              () => Navigator.pop(context))
        ]);
      }
    }
  }

  static Future<bool> updateProfile(Map<String, dynamic> newUserData) async {
    ConnAPI connAPI = ConnAPI(APIEndpoints.UPDATE_PROFILE, "PUT", false,
        {"id": userData['idUser'], "data": newUserData});
    await connAPI.callAPI();
    return connAPI.getStatus() == 200;
  }

  static Future<bool> updatePayDay(int payday) async {
    ConnAPI connAPI = ConnAPI(APIEndpoints.UPDATE_PAYDAY, "PUT", false,
        {"id": userData['idUser'], "payDay": payday});
    await connAPI.callAPI();
    return connAPI.getStatus() == 200;
  }
}
