import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_travaly/src/features/login/controllers/login_controller.dart';
import 'package:my_travaly/src/features/login/views/widget/google_sign_in_button.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(
                        Icons.travel_explore,
                        size: 42,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome to My Travaly',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Sign in with your Google account to manage your trips and explore new destinations.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Obx(
                () => GoogleSignInButton(
                  isLoading: controller.isSigningIn.value,
                  onPressed: controller.isSigningIn.value
                      ? null
                      : controller.signInWithGoogle,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'By continuing you agree to our terms & privacy policy.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
