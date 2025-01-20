import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpOTPInputPage extends HookConsumerWidget {
  final String email;

  const SignUpOTPInputPage({super.key, required this.email});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otpController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter the OTP sent to your email: $email',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: otpController,
              decoration: const InputDecoration(labelText: 'OTP Code'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final otp = otpController.text.trim();
                if (otp.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter the OTP code')),
                  );
                  return;
                }

                try {
                  await ref
                      .read(authControllerProvider.notifier)
                      .verifyOTP(email: email, otp: otp);
                  // Navigate to the next page on success
                  Navigator.pushNamed(context, '/home');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
