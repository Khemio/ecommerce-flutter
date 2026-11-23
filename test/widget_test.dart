import 'package:azkomoly_app/core/widgets/quantity_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('quantity buttons report the next value', (tester) async {
    final changes = <int>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QuantitySelector(value: 2, onChanged: changes.add),
        ),
      ),
    );

    await tester.tap(find.text('+'));
    expect(changes, [3]);

    await tester.tap(find.text('-'));
    expect(changes, [3, 1]);
  });
}
