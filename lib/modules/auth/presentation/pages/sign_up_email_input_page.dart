import 'package:dongi/core/constants/constant.dart';
import 'package:dongi/shared/utilities/validation/validation.dart';
import 'package:dongi/shared/widgets/text_field/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/color_config.dart';
import '../../../../core/router/router_notifier.dart';
import '../../../../shared/utilities/helpers/snackbar_helper.dart';
import '../../domain/di/auth_controller_di.dart';

class SignUpEmailInputPage extends HookConsumerWidget {
  SignUpEmailInputPage({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();

    /// Listen for signup actions and handle navigation or errors
    ref.listen<AsyncValue<void>>(
      authControllerProvider,
      (previous, next) {
        next.when(
          data: (_) {
            // Proceed to OTP page on successful email submission
            context.go(
                RouteName.signupOTPInput); // Update with your OTP route name
          },
          loading: () {
            // Optional: Show a loading state (snackbar, etc.)
            debugPrint('Email submission in progress...');
          },
          error: (error, stack) {
            // Show error message
            showSnackBar(context, error.toString());
          },
        );
      },
    );

    return Scaffold(
      backgroundColor: ColorConfig.background,
      appBar: AppBar(
        title: const Text("Sign Up - Email"),
        backgroundColor: ColorConfig.primarySwatch,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                "Enter your email address",
                style: FontConfig.h6(),
              ),
              const SizedBox(height: 12),
              Text(
                "We’ll send you an OTP or Magic Link to continue signing up.",
                style: FontConfig.body1(),
              ),
              const SizedBox(height: 32),

              // Email Input Form
              Form(
                key: _formKey,
                child: TextFieldWidget(
                  hintText: 'email',
                  controller: emailController,
                  validator:
                      ref.read(formValidatorProvider.notifier).validateEmail,
                ),
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await ref
                              .read(authControllerProvider.notifier)
                              .sendOTP(emailController.text);
                        }
                      },
                      child: const Text("Send OTP"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await ref
                              .read(authControllerProvider.notifier)
                              .sendMagicLink(emailController.text);
                        }
                      },
                      child: const Text("Send Magic Link"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Sign In and Forgot Password Links
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => context
                        .go(RouteName.signin), // Update with your sign-in route
                    child: const Text("Sign In"),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {}, // Update with your forgot password route
                    child: const Text("Forgot Password?"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
