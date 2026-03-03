import 'package:flutter_test/flutter_test.dart';

import 'package:english_duel/app/app.dart';

void main() {
  testWidgets('App renders', (WidgetTester tester) async {
    await tester.pumpWidget(const EnglishDuelApp());
    // Demo screen is temporarily the first tab.
    expect(find.text('Component Kit'), findsOneWidget);
  });
}
