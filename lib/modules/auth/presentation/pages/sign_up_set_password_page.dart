import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SetPasswordPage extends HookConsumerWidget {
  final String userId; // Pass this from the previous screen

  const SetPasswordPage({required this.userId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordController = TextEditingController();
    final usernameController = TextEditingController();

    final isLoading = useState(false);

    void save() async {
      final password = passwordController.text.trim();
      final username = usernameController.text.trim();

      if (password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password is required')),
        );
        return;
      }

      isLoading.value = true;

      await ref.read(authControllerProvider.notifier).setPasswordAndUsername(
            userId: userId,
            password: password,
            username: username.isEmpty ? null : username,
          );

      isLoading.value = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Set Password & Username'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username (Optional)'),
            ),
            SizedBox(height: 32),
            isLoading.value
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: save,
                    child: Text('Save'),
                  ),
          ],
        ),
      ),
    );
  }
}
