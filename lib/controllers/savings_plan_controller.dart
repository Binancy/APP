import 'package:binancy/globals.dart';
import 'package:binancy/models/savings_plan.dart';

class SavingsPlansController {
  static Future<List<SavingsPlan>> getSavingsPlans(int idUser) async {
    List<SavingsPlan> savingsPlanList = [];

    savingsPlanList.add(SavingsPlan()
      ..amount = 10000
      ..total = 30000
      ..description = "This is an example savigns plan"
      ..idUser = idUser
      ..limitDate = DateTime(2022, 01, 01)
      ..name = "Example Savings Plan");

    savingsPlanList.add(SavingsPlan()
      ..amount = 10000
      ..total = 30000
      ..description = "This is an example savigns plan"
      ..idUser = idUser
      ..limitDate = DateTime(2022, 01, 01)
      ..name = "Example Savings Plan");

    savingsPlanList.add(SavingsPlan()
      ..amount = 10000
      ..total = 30000
      ..description = "This is an example savigns plan"
      ..idUser = idUser
      ..limitDate = DateTime(2022, 01, 01)
      ..name = "Example Savings Plan");

    savingsPlanList.add(SavingsPlan()
      ..amount = 10000
      ..total = 30000
      ..description = "This is an example savigns plan"
      ..idUser = idUser
      ..limitDate = DateTime(2022, 01, 01)
      ..name = "Example Savings Plan");

    savingsPlanList.add(SavingsPlan()
      ..amount = 10000
      ..total = 30000
      ..description = "This is an example savigns plan"
      ..idUser = idUser
      ..limitDate = DateTime(2022, 01, 01)
      ..name = "Example Savings Plan");

    savingsPlanList.add(SavingsPlan()
      ..amount = 10000
      ..total = 30000
      ..description = "This is an example savigns plan"
      ..idUser = idUser
      ..limitDate = DateTime(2022, 01, 01)
      ..name = "Example Savings Plan");

    return savingsPlanList;
  }
}
