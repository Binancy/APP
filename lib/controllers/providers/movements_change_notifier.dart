// ignore_for_file: must_call_super

import 'package:binancy/globals.dart';
import 'package:binancy/models/expend.dart';
import 'package:binancy/models/income.dart';
import 'package:binancy/utils/api/conn_api.dart';
import 'package:binancy/utils/api/endpoints.dart';
import 'package:binancy/utils/utils.dart';
import 'package:flutter/material.dart';

class MovementsChangeNotifier extends ChangeNotifier {
  bool updating = false;
  List<Income> incomeList = [];
  List<Expend> expendList = [];
  double totalIncomes = 0, totalExpenses = 0, totalHeritage = 0;

  @override
  void dispose() {}

  Future<void> updateMovements() async {
    if (await Utils.hasConnection().timeout(timeout)) {
      await getAllIncomes();
      await getAllExpenses();
      await getBalance();
      notifyListeners();
    }
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

    for (var element in incomeList) {
      if (userData['payDay'] != null) {
        if (Utils.isAfterPayDay(
                Utils.getStartMonthByPayDay(Utils.getTodayDate()),
                element.date) &&
            Utils.isBeforePayDay(
                Utils.getFinalMonthByPayDay(Utils.getTodayDate()),
                element.date)) {
          thisMonthIncomes += element.value;
        }
      }
    }

    return thisMonthIncomes;
  }

  double getThisMonthExpenses() {
    double thisMonthExpenses = 0;
    for (var element in expendList) {
      if (userData['payDay'] != null) {
        if (Utils.isAfterPayDay(
                Utils.getStartMonthByPayDay(Utils.getTodayDate()),
                element.date) &&
            Utils.isBeforePayDay(
                Utils.getFinalMonthByPayDay(Utils.getTodayDate()),
                element.date)) {
          thisMonthExpenses += element.value;
        }
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

      incomeList.sort((a, b) => b.date.compareTo(a.date));
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
        expendList.sort((a, b) => b.date.compareTo(a.date));
      }
    } else {
      print('Error, el JSON no tiene datos');
    }
  }

  double getMonthIncomes(DateTime startMonth) {
    double monthIncomes = 0;
    for (var income in incomeList) {
      if (Utils.isAfterPayDay(startMonth, income.date) &&
          Utils.isBeforePayDay(
              Utils.getFinalMonthByPayDay(startMonth), income.date)) {
        monthIncomes += income.value;
      }
    }
    return Utils.roundDown(monthIncomes, 2);
  }

  double getMonthExpends(DateTime startMonth) {
    double monthExpends = 0;
    for (var expend in expendList) {
      if (Utils.isAfterPayDay(startMonth, expend.date) &&
          Utils.isBeforePayDay(
              Utils.getFinalMonthByPayDay(startMonth), expend.date)) {
        monthExpends += expend.value;
      }
    }
    return Utils.roundDown(monthExpends, 2);
  }
}
