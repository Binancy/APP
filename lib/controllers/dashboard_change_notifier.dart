import 'dart:math';

import 'package:binancy/globals.dart';
import 'package:binancy/models/expend.dart';
import 'package:binancy/models/income.dart';
import 'package:binancy/utils/conn_api.dart';
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
    await getLatestsIncomes();
    await getLatestExpenses();
    print(movementsList);
    movementsList.sort((a, b) {
      DateTime aDate = a.date as DateTime;
      DateTime bDate = b.date as DateTime;
      return aDate.compareTo(bDate);
    });
  }

  Future<void> getLatestsIncomes() async {
    ConnAPI connAPI = ConnAPI('/api/incomes/latestIncomes', "POST", false,
        {'id': userData['idUser']});
    await connAPI.callAPI();
    List<dynamic>? responseJSON = connAPI.getResponse();
    if (responseJSON != null) {
      print(responseJSON);
      for (var movement in responseJSON) {
        movementsList.add(Income.fromJson(movement));
      }
    } else {
      print('Error, el JSON no tiene datos');
    }
  }

  Future<void> getLatestExpenses() async {
    ConnAPI connAPI = ConnAPI('/api/expenses/latestExpenses', "POST", false,
        {'id': userData['idUser']});
    await connAPI.callAPI();
    List<dynamic>? responseJSON = connAPI.getResponse();
    if (responseJSON != null) {
      print(responseJSON);

      for (var movement in responseJSON) {
        movementsList.add(Expend.fromJson(movement));
      }
    } else {
      print('Error, el JSON no tiene datos');
    }
  }
}
