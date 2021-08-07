import 'package:binancy/globals.dart';
import 'package:binancy/utils/api/conn_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Testing "/api/incomes/latestIncomes" call', () async {
    ConnAPI connAPI = ConnAPI('/api/expenses/latestExpenses', "POST", true,
        {'id': userData['idUser']});
    await connAPI.callAPI();
    List<dynamic>? responseJSON = connAPI.getResponse();
    if (responseJSON != null) {
      print(responseJSON);
    } else {
      print('Error, el JSON no tiene datos');
    }
  });
}
