import 'package:dongi/core/constants/color_config.dart';
import 'package:dongi/shared/utilities/validation/validation.dart';
import 'package:dongi/shared/widgets/appbar/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/router/router_notifier.dart';
import '../../../../shared/utilities/helpers/snackbar_helper.dart';
import '../../../../shared/widgets/button/button.dart';
import '../../../../shared/widgets/text_field/text_field.dart';
import '../../domain/di/auth_controller_di.dart';

class SignInPage extends HookConsumerWidget {
  final String? email;
  SignInPage({super.key, this.email});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController(text: email);
    final passwordController = useTextEditingController();
    final isPasswordMode = useState(true);

    /// Listen for sign-in actions and handle errors
    ref.listen<AsyncValue<void>>(
      authControllerProvider,
      (previous, next) {
        next.when(
          data: (_) {},
          loading: () {
            // Optional: Show a loading state (e.g., snackbar, etc.)
            debugPrint('Sign-in in progress...');
          },
          error: (error, stack) {
            // Show error message
            showSnackBar(context, content: error.toString());
          },
        );
      },
    );

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBarWidget(title: "Sign In"),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // Header
            const Text(
              "Welcome Back!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Log in to continue using Dongi.",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),

            // Toggle Between Password or OTP Mode
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => isPasswordMode.value = true,
                  child: Column(
                    children: [
                      Text(
                        "With Password",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isPasswordMode.value
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isPasswordMode.value
                              ? ColorConfig.midnight
                              : Colors.grey,
                        ),
                      ),
                      if (isPasswordMode.value)
                        Container(
                          height: 2,
                          width: 120,
                          color: ColorConfig.midnight,
                          margin: const EdgeInsets.only(top: 4),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => isPasswordMode.value = false,
                  child: Column(
                    children: [
                      Text(
                        "Without Password",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: !isPasswordMode.value
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: !isPasswordMode.value
                              ? ColorConfig.midnight
                              : Colors.grey,
                        ),
                      ),
                      if (!isPasswordMode.value)
                        Container(
                          height: 2,
                          width: 120,
                          color: ColorConfig.midnight,
                          margin: const EdgeInsets.only(top: 4),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFieldWidget(
                    hintText: "Email",
                    controller: emailController,
                    validator:
                        ref.read(formValidatorProvider.notifier).validateEmail,
                  ),

                  if (isPasswordMode.value) ...[
                    const SizedBox(height: 16),

                    // Password Input
                    TextFieldWidget(
                      hintText: "Password",
                      controller: passwordController,
                      obscureText: true,
                      validator: ref
                          .read(formValidatorProvider.notifier)
                          .validatePassword,
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Action Buttons
                  ButtonWidget(
                    title: isPasswordMode.value ? "Sign In" : "Send OTP",
                    isLoading: ref.watch(authControllerProvider).maybeWhen(
                          loading: () => true,
                          orElse: () => false,
                        ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (isPasswordMode.value) {
                          // Sign In with Email & Password
                          await ref
                              .read(authControllerProvider.notifier)
                              .signIn(
                                email: emailController.text,
                                password: passwordController.text,
                              );

                          if (context.mounted) {
                            // Redirect to the home page or dashboard
                            context.go(RouteName.home);
                          }
                        } else {
                          // Check if the user is available
                          final isUserAvailable = await ref
                              .read(authControllerProvider.notifier)
                              .isUserSignedUp(emailController.text);

                          if (!isUserAvailable) {
                            if (context.mounted) {
                              showSnackBar(
                                context,
                                type: SnackBarType.error,
                                content:
                                    "User with this email is not registered.",
                              );
                            }
                            return;
                          }

                          // Send OTP for PasswordLess Login
                          final result = await ref
                              .read(authControllerProvider.notifier)
                              .sendOTP(email: emailController.text);

                          if (result != null && context.mounted) {
                            context.push(RouteName.signupOTPInput, extra: {
                              'userId': result,
                              'email': emailController.text,
                            });
                          }
                        }
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Links for Forgot Password or Sign Up
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Dont Have an Account?",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => context.push(RouteName.signupEmail),
                  child: const Text("Sign Up"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
