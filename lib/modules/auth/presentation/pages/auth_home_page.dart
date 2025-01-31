import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/shared/widgets/appbar/appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/router/router_names.dart';
import '../../../../shared/widgets/button/button.dart';

class AuthHomePage extends HookConsumerWidget {
  const AuthHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(title: "Welcome to Dongi"),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Heading
            const Text(
              "Welcome!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Sign up or log in to continue.",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 40),

            // "Sign Up with Email" Button
            ButtonWidget(
              title: "Sign Up with Email",
              onPressed: () => context.push(RouteName.signupEmail),
              isLoading: false,
            ),
            const SizedBox(height: 16),

            // "Continue with Google" Button
            ButtonWidget(
              title: "Continue with Google",
              onPressed: () async {
                // Google OAuth Logic
                await ref
                    .read(authControllerProvider.notifier)
                    .signInWithGoogle();
              },
              isLoading: ref.watch(authControllerProvider).maybeWhen(
                    loading: () => true,
                    orElse: () => false,
                  ),
            ),
            const SizedBox(height: 32),

            // "Sign In" Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account?",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => context.push(RouteName.signin),
                  child: const Text("Sign In"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
