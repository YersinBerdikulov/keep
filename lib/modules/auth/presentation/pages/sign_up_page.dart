import 'package:dongi/modules/auth/domain/controllers/sign_up_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/constants/color_config.dart';
import '../../../../core/utilities/helpers/snackbar_helper.dart';
import '../../../../core/router/router_notifier.dart';
import '../widgets/sign_up_widget.dart';

class SignUpPage extends HookConsumerWidget {
  SignUpPage({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    /// by using listen we are not gonna rebuild our app
    ref.listen<AsyncValue<void>>(
      signUpControllerProvider,
      (previous, next) {
        next.when(
          data: (_) {
            // Navigate to the home page on successful signup
            context.go(RouteName.home);
          },
          loading: () {
            // Optionally handle loading state
            debugPrint('SignUp in progress...');
          },
          error: (error, stack) {
            // Display error message
            showSnackBar(context, error.toString());
          },
        );
      },
    );

    return Scaffold(
      backgroundColor: ColorConfig.background,
      body: Column(
        children: [
          const Expanded(
            child: SizedBox(),
          ),
          SignUpBody(
            children: [
              const SignUpTitle(),
              SignUpForm(
                formKey: _formKey,
                username: usernameController,
                email: emailController,
                password: passwordController,
              ),
              SignUpAction(
                username: usernameController,
                email: emailController,
                password: passwordController,
                formKey: _formKey,
              ),
              const SignUpChangeAction(),
            ],
          )
        ],
      ),
    );
  }
}
