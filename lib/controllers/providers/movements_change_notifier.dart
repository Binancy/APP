import 'dart:math';

import 'package:binancy/globals.dart';
import 'package:binancy/models/expend.dart';
import 'package:binancy/models/income.dart';
import 'package:binancy/utils/api/conn_api.dart';
import 'package:binancy/utils/api/endpoints.dart';
import 'package:flutter/material.dart';

class MovementsChangeNotifier extends ChangeNotifier {
  bool updating = false;
  List<dynamic> incomeList = [];
  List<dynamic> expendList = [];
  double totalIncomes = 0, totalExpenses = 0, totalHeritage = 0;

  @override
  void dispose() {}

  void updateDashboard() async {
    isUpdating(true);
    await getAllIncomes();
    await getAllExpenses();
    await getBalance();
    isUpdating(false);
  }

  void isUpdating(bool isUpdating) {
    updating = isUpdating;
    notifyListeners();
  }

  Future<void> getBalance() async {
    totalIncomes = 0;
    totalExpenses = 0;

    for (Income income in incomeList) {
      totalIncomes += income.value;
    }

    for (Expend expend in expendList) {
      totalExpenses += expend.value;
    }

    totalHeritage = totalIncomes - totalExpenses;
  }

  double getThisMonthIncomes() {
    double thisMonthIncomes = 0;
    for (Income income in incomeList) {
      if (DateTime.now().difference(income.date) <= Duration(days: 30)) {
        thisMonthIncomes += income.value;
      }
    }

    return thisMonthIncomes;
  }

  double getThisMonthExpenses() {
    double thisMonthExpenses = 0;
    for (Expend expend in expendList) {
      if (DateTime.now().difference(expend.date) <= Duration(days: 30)) {
        thisMonthExpenses += expend.value;
      }
    }

    return thisMonthExpenses;
  }

  Future<void> getAllIncomes() async {
    incomeList.clear();
    ConnAPI connAPI = ConnAPI(
        APIEndpoints.READ_INCOMES, "POST", false, {'id': userData['idUser']});
    await connAPI.callAPI();
    List<dynamic>? responseJSON = connAPI.getResponse();
    if (responseJSON != null) {
      for (var movement in responseJSON) {
        incomeList.add(Income.fromJson(movement));
      }
    } else {
      print('Error, el JSON no tiene datos');
    }
  }

  Future<void> getAllExpenses() async {
    expendList.clear();
    ConnAPI connAPI = ConnAPI(
        APIEndpoints.READ_EXPENSES, "POST", false, {'id': userData['idUser']});
    await connAPI.callAPI();
    List<dynamic>? responseJSON = connAPI.getResponse();
    if (responseJSON != null) {
      for (var movement in responseJSON) {
        expendList.add(Expend.fromJson(movement));
      }
    } else {
      print('Error, el JSON no tiene datos');
    }
  }
}
