import 'package:dongi/modules/auth/domain/controllers/sign_up_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/color_config.dart';
import '../../../../core/router/router_notifier.dart';
import '../../../../core/utilities/helpers/snackbar_helper.dart';
import '../widgets/sign_in_widget.dart';

class SignInPage extends HookConsumerWidget {
  SignInPage({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController emailController = useTextEditingController();
    TextEditingController passwordController = useTextEditingController();

    /// by using listen we are not gonna rebuild our app
    ref.listen<AsyncValue<void>>(
      signUpControllerProvider,
      (previous, next) {
        next.when(
          data: (_) {
            // Navigate to the home page on success
            context.go(RouteName.home);
          },
          loading: () {
            // Optionally show a loading indicator or spinner
            debugPrint('SignUp in progress...');
          },
          error: (error, stack) {
            // Show an error message
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
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(50, 30, 50, 50),
              decoration: BoxDecoration(
                color: ColorConfig.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SignInTitle(),
                  SignInForm(
                    formKey: _formKey,
                    email: emailController,
                    password: passwordController,
                  ),
                  SignInActionButton(
                    formKey: _formKey,
                    email: emailController,
                    password: passwordController,
                  ),
                  const SignInChangeActionButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
