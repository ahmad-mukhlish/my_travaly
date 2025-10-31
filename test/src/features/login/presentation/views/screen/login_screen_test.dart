import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/lifecycle.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_travaly/src/features/login/controllers/login_controller.dart';
import 'package:my_travaly/src/features/login/presentation/views/screen/login_screen.dart';
import 'package:my_travaly/src/features/login/presentation/views/widget/google_sign_in_button.dart';

class MockLoginController extends Mock implements LoginController {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockLoginController loginController;
  late RxBool isSigningIn;

  setUp(() {
    Get.reset();
    Get.testMode = true;

    loginController = MockLoginController();
    isSigningIn = false.obs;

    when(() => loginController.isSigningIn).thenReturn(isSigningIn);
    when(() => loginController.signInWithGoogle())
        .thenAnswer((_) async {});
    when(() => loginController.onStart)
        .thenReturn(InternalFinalCallback<void>(callback: () {}));
    when(() => loginController.onDelete)
        .thenReturn(InternalFinalCallback<void>(callback: () {}));

    addTearDown(() {
      Get.reset();
    });
  });

  Future<void> pumpLoginScreen(WidgetTester tester) async {
    Get.put<LoginController>(loginController);

    await tester.pumpWidget(
      const GetMaterialApp(
        home: LoginScreen(),
      ),
    );
    await tester.pump();
  }

  testWidgets(
    'renders login content and Google sign-in button',
    (tester) async {
      await pumpLoginScreen(tester);

      expect(find.text('Welcome to My Travaly'), findsOneWidget);
      expect(
        find.text(
          'Sign in with your Google account to manage your trips and explore new destinations.',
        ),
        findsOneWidget,
      );
      expect(find.byType(GoogleSignInButton), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
    },
  );

  testWidgets(
    'tapping Google sign-in button triggers controller when not loading',
    (tester) async {
      await pumpLoginScreen(tester);

      await tester.tap(find.text('Continue with Google'));
      await tester.pump();

      verify(() => loginController.signInWithGoogle()).called(1);
    },
  );

  testWidgets(
    'shows loading indicator and disables button while signing in',
    (tester) async {
      isSigningIn.value = true;

      await pumpLoginScreen(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.tap(find.byType(GoogleSignInButton));
      await tester.pump();

      verifyNever(() => loginController.signInWithGoogle());
    },
  );
}
