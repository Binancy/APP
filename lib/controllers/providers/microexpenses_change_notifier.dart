// ignore_for_file: must_call_super

import 'package:binancy/controllers/microexpenses_controller.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/microexpend.dart';
import 'package:binancy/utils/utils.dart';
import 'package:flutter/material.dart';

class MicroExpensesChangeNotifier extends ChangeNotifier {
  List<MicroExpend> microExpensesList = [];
  bool updating = false;

  @override
  void dispose() {}

  Future<void> updateMicroExpenses() async {
    if (await Utils.hasConnection().timeout(timeout)) {
      microExpensesList =
          await MicroExpensesController.getMicroExpenses(userData['idUser']);
      notifyListeners();
    }
  }
}
