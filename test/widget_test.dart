// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:movie_app/app/modules/welcome/views/welcome_view.dart';

void main() {
  testWidgets('WelcomeView has a title and two buttons', (WidgetTester tester) async {
    // Build the WelcomeView widget directly.
    await tester.pumpWidget(
      const GetMaterialApp(
        home: WelcomeView(),
      ),
    );

    // Verify that the WelcomeView displays the correct widgets.
    expect(find.text('Welcome to Movie App'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('Continue as Guest'), findsOneWidget);
  });
}
