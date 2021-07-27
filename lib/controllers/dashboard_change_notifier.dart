import 'dart:math';

import 'package:binancy/models/expend.dart';
import 'package:binancy/models/income.dart';
import 'package:flutter/material.dart';

class DashboardChangeNotifier extends ChangeNotifier {
  bool updating = false;
  List<dynamic> movementsList = [];
  double totalIncomes = 0, totalExpenses = 0;

  void updateDashboard() async {
    isUpdating(true);
    await getBalance();
    await getLatestsMovements();
    isUpdating(false);
  }

  void isUpdating(bool isUpdating) {
    updating = isUpdating;
    notifyListeners();
  }

  Future<void> getBalance() async {
    totalIncomes = 2500.00;
    totalExpenses = 2575.00;
  }

  Future<void> getLatestsMovements() async {
    movementsList.clear();
    for (var i = 0; i < Random().nextInt(10) + 1; i++) {
      Random().nextBool()
          ? movementsList.add(Expend()
            ..idExpend = Random().nextInt(1000)
            ..idUser = 0
            ..value = Random().nextInt(1000).toDouble()
            ..description = "Ingreso de ejemplo")
          : movementsList.add(Income()
            ..idIncome = Random().nextInt(1000)
            ..idUser = 0
            ..value = Random().nextInt(1000).toDouble()
            ..description = "Gasto de ejemplo");
    }
  }
}
