import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priticious/app.dart';

void main() {
  testWidgets('Priticious app boots to splash', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: PriticiousApp()));

    expect(find.text('Priticious'), findsOneWidget);
    expect(find.text('Version 1.0.0'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Featured Products'), findsOneWidget);
  });
}
