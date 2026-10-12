import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:service_booking_famto/main.dart';

void main() {
  testWidgets('Famto Mini Service Booking Flow Smoke Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify Home Screen elements exist
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Indiranagar, Bengaluru'), findsOneWidget);
    expect(find.text('AC Foam Jet Deep Service'), findsOneWidget);

    // Search functionality test
    await tester.enterText(find.byType(TextField).first, 'Full Home');
    await tester.pumpAndSettle();

    expect(find.text('Full Home Deep Cleaning (2 BHK)'), findsOneWidget);
    expect(find.text('AC Foam Jet Deep Service'), findsNothing);

    // Clear search
    await tester.tap(find.byIcon(Icons.clear_rounded));
    await tester.pumpAndSettle();

    expect(find.text('AC Foam Jet Deep Service'), findsOneWidget);
  });
}
