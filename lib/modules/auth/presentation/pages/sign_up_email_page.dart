import 'package:dongi/core/constants/constant.dart';
import 'package:dongi/shared/utilities/validation/validation.dart';
import 'package:dongi/shared/widgets/appbar/appbar.dart';
import 'package:dongi/shared/widgets/button/button_widget.dart';
import 'package:dongi/shared/widgets/text_field/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/router/router_names.dart';
import '../../../../shared/utilities/helpers/snackbar_helper.dart';
import '../../domain/di/auth_controller_di.dart';

class SignUpEmailPage extends HookConsumerWidget {
  SignUpEmailPage({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();

    /// Listen for signup actions and handle navigation or errors
    ref.listen<AsyncValue<void>>(
      authControllerProvider,
      (previous, next) {
        next.when(
          data: (_) {},
          loading: () {
            // Optional: Show a loading state (snackbar, etc.)
            debugPrint('Email submission in progress...');
          },
          error: (error, stack) {
            // Show error message
            showSnackBar(context, content: error.toString());
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBarWidget(title: "Sign Up - Email"),
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
                "We’ll send you an OTP to continue your signing up.",
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
                    child: ButtonWidget(
                      title: "Send OTP",
                      isLoading: ref.watch(authControllerProvider).maybeWhen(
                            loading: () => true,
                            orElse: () => false,
                          ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final isRegistered = await ref
                              .read(authControllerProvider.notifier)
                              .isUserSignedUp(emailController.text);

                          if (isRegistered) {
                            if (context.mounted) {
                              showSnackBar(
                                context,
                                content:
                                    'User already registered. Please sign in.',
                                seconds: 10,
                                actionLabel: 'Sign In',
                                onAction: () => context.go(
                                  RouteName.signin,
                                  extra: {'email': emailController.text},
                                ),
                              );
                            }
                          } else {
                            final userId = await ref
                                .read(authControllerProvider.notifier)
                                .sendOTP(email: emailController.text);
                            if (userId != null && context.mounted) {
                              context.push(
                                RouteName.signupOTPInput,
                                extra: {
                                  'userId': userId,
                                  'email': emailController.text,
                                },
                              );
                            }
                          }
                        }
                      },
                    ),
                  ),
                  // const SizedBox(width: 12),
                  // Expanded(
                  //   child: ButtonWidget(
                  //     title: "Send Magic Link",
                  //     isLoading: ref.watch(authControllerProvider).maybeWhen(
                  //           loading: () => true,
                  //           orElse: () => false,
                  //         ),
                  //     onPressed: () async {
                  //       if (_formKey.currentState!.validate()) {
                  //         await ref
                  //             .read(authControllerProvider.notifier)
                  //             .sendMagicLink(emailController.text);
                  //       }
                  //     },
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 24),

              // Sign In Links
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
      ),
    );
  }
}
