import 'package:dongi/core/constants/color_config.dart';
import 'package:dongi/shared/utilities/validation/validation.dart';
import 'package:dongi/shared/widgets/appbar/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/router/router_names.dart';
import '../../../../shared/utilities/helpers/snackbar_helper.dart';
import '../../../../shared/widgets/button/button_widget.dart';
import '../../../../shared/widgets/button/secondary_button_widget.dart';
import '../../../../shared/widgets/text_field/text_field.dart';
import '../../domain/di/auth_controller_di.dart';
import '../../../home/domain/di/home_controller_di.dart';

class SignInPage extends HookConsumerWidget {
  final String? email;
  SignInPage({super.key, this.email});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController(text: email);

    /// Listen for sign-in actions and handle errors
    ref.listen<AsyncValue<void>>(
      authControllerProvider,
      (previous, next) {
        next.when(
          data: (_) {},
          loading: () {
            debugPrint('Sign-in in progress...');
          },
          error: (error, stack) {
            showSnackBar(context, content: error.toString());
          },
        );
      },
    );

    final isLoading = ref.watch(authControllerProvider).maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

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
                    "Log in to continue using Keep.",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 32),

                  // Google Sign In Button
                  SecondaryButtonWidget(
                    title: "Continue with Google",
                    icon: SvgPicture.asset(
                      'assets/svg/google_icon.svg',
                      width: 18,
                      height: 18,
                      colorFilter: const ColorFilter.mode(
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () async {
                      await ref
                          .read(authControllerProvider.notifier)
                          .authWithGoogle();
                      if (context.mounted) {
                        context.go(RouteName.home);
                      }
                    },
                    isLoading: isLoading,
                  ),

                  const SizedBox(height: 24),

                  // Divider with "or" text
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[300])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "or",
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[300])),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFieldWidget(
                          hintText: "Email",
                          controller: emailController,
                          validator: ref
                              .read(formValidatorProvider.notifier)
                              .validateEmail,
                        ),

                        const SizedBox(height: 24),

                        // Action Button
                        ButtonWidget(
                          title: "Send OTP",
                          isLoading: isLoading,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final isUserAvailable = await ref
                                  .read(authControllerProvider.notifier)
                                  .isUserSignedUp(emailController.text);

                              if (!isUserAvailable) {
                                return;
                              }

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
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Links for Sign Up
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
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
