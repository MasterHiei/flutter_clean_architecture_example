import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_example/main_common.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('login success test', (WidgetTester tester) async {
    app.mainCommon();
    await tester.pumpAndSettle();

    final Finder emailFinder = find.byKey(const Key('login_email'));
    final Finder passwordFinder = find.byKey(const Key('login_password'));
    final Finder buttonFinder = find.byKey(const Key('login_button'));

    expect(emailFinder, findsOneWidget);
    expect(passwordFinder, findsOneWidget);
    expect(buttonFinder, findsOneWidget);

    await tester.enterText(emailFinder, 'eve.holt@reqres.in');
    await tester.pumpAndSettle();

    await tester.enterText(passwordFinder, 'cityslicka');
    await tester.pumpAndSettle();

    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    // Verify successful login (Example: check if login button disappears or home screen appears)
    // For now, we just ensure no error snackbar is shown
    expect(find.text('Invalid email or password'), findsNothing);
    expect(find.text('Network error'), findsNothing);
  });
}
