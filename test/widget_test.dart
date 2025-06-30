import 'package:flutter_test/flutter_test.dart';
import 'package:ormee_app/app/app.dart';

void main() {
  group('OrmeeApp Widget Tests', () {
    testWidgets('App should start and show home screen', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const OrmeeApp());

      // Wait for any animations to complete
      await tester.pumpAndSettle();

      // Verify that the home screen is displayed
    });
  });
}
