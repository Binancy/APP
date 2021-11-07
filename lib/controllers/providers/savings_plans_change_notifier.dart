// ignore_for_file: must_call_super

import 'package:binancy/controllers/savings_plan_controller.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/savings_plan.dart';
import 'package:binancy/utils/utils.dart';
import 'package:flutter/widgets.dart';

class SavingsPlanChangeNotifier extends ChangeNotifier {
  List<SavingsPlan> savingsPlanList = [];

  @override
  void dispose() {}

  Future<void> updateSavingsPlan() async {
    if (await Utils.hasConnection().timeout(timeout)) {
      savingsPlanList =
          await SavingsPlansController.getSavingsPlans(userData['idUser']);
      savingsPlanList.sort((a, b) => a.limitDate == null
          ? 1
          : b.limitDate == null
              ? -1
              : a.limitDate!.compareTo(b.limitDate!));
      notifyListeners();
    }
  }
}
