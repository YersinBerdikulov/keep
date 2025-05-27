import 'package:dongi/core/constants/constant.dart';
import 'package:dongi/core/router/router_names.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/home/domain/di/home_controller_di.dart';
import 'package:dongi/shared/utilities/helpers/snackbar_helper.dart';
import 'package:dongi/shared/utilities/validation/validation.dart';
import 'package:dongi/shared/widgets/appbar/appbar.dart';
import 'package:dongi/shared/widgets/button/button_widget.dart';
import 'package:dongi/shared/widgets/text_field/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpOTPInputPage extends HookConsumerWidget {
  final String userId;
  final String email;

  SignUpOTPInputPage({
    super.key,
    required this.userId,
    required this.email,
  });

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otpController = TextEditingController();

    return Scaffold(
      appBar: AppBarWidget(title: 'Verify OTP'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter the OTP sent to your email inbox',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: TextFieldWidget(
                controller: otpController,
                hintText: 'OTP Code',
                validator: (value) => ref
                    .watch(formValidatorProvider.notifier)
                    .validateLength(value),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            const SizedBox(height: 16),
            ButtonWidget(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  final otp = otpController.text;

                  try {
                    await ref
                        .read(authControllerProvider.notifier)
                        .verifyOTP(userId: userId, otp: otp);
                    // Navigate to the next page on success

                    if (context.mounted) {
                      context.go(RouteName.home);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      showSnackBar(context, content: e.toString());
                    }
                  }
                } else {
                  showSnackBar(
                    context,
                    type: SnackBarType.error,
                    content: 'Please enter a valid OTP',
                  );
                }
              },
              title: 'Continue',
              isLoading: ref.watch(authControllerProvider).maybeWhen(
                    loading: () => true,
                    orElse: () => false,
                  ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                try {
                  await ref
                      .read(authControllerProvider.notifier)
                      .sendOTP(email: email);
                  if (context.mounted) {
                    showSnackBar(context, content: "OTP has been resent");
                  }
                } catch (e) {
                  if (context.mounted) {
                    showSnackBar(context, content: e.toString());
                  }
                }
              },
              child: const Text("Didn't receive the OTP? Send again"),
            ),
          ],
        ),
      ),
    );
  }
}
