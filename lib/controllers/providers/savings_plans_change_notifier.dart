import 'package:binancy/controllers/savings_plan_controller.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/savings_plan.dart';
import 'package:flutter/widgets.dart';

class SavingsPlanChangeNotifier extends ChangeNotifier {
  List<SavingsPlan> savingsPlanList = [];

  @override
  void dispose() {}

  Future<void> updateSavingsPlan() async {
    savingsPlanList =
        await SavingsPlansController.getSavingsPlans(userData['idUser']);
    notifyListeners();
  }
}
