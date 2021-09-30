import 'package:binancy/controllers/subscriptions_controller.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("Testing PayDay 2.0 methods", (WidgetTester tester) async {
    /// NOTE
    /// Tested on 30/09/2021, this test depends of the current date so results may be different
    /// if this test is realized before this date.
    ///
    /// PD: Changing the SO date manually can also variate the result of the test

    await tester.pumpWidget(MaterialApp(home: Material(child: Container())));
    final BuildContext context = tester.element(find.byType(Container));

    userData = {'payDay': 20};
    expect(Utils.toYMD(Utils.getCurrentMonthPayDay(), context), "9/20/2021");
    expect(Utils.toYMD(Utils.getNextMonthPayDay(), context), "10/20/2021");
    expect(Utils.getMonthNameOfPayDay(Utils.getCurrentMonthPayDay()),
        Month.OCTOBER);
  });
}
