import 'package:dongi/core/constants/color_config.dart';
import 'package:dongi/core/router/router_names.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/user/domain/di/user_controller_di.dart';
import 'package:dongi/modules/user/domain/models/user_model.dart';
import 'package:dongi/shared/utilities/helpers/snackbar_helper.dart';
import 'package:dongi/shared/widgets/button/button_widget.dart';
import 'package:dongi/shared/widgets/text_field/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EnterNamePage extends HookConsumerWidget {
  const EnterNamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final isLoading = useState(false);

    void onSubmit() async {
      if (nameController.text.trim().isEmpty) {
        showSnackBar(context, content: 'Please enter your name');
        return;
      }

      isLoading.value = true;

      try {
        final currentUser = ref.read(currentUserProvider);
        if (currentUser == null) {
          showSnackBar(context, content: 'User not found');
          return;
        }

        // Get the current user data
        final userData = await ref.read(userNotifierProvider.notifier).currentUser;
        if (userData == null) {
          showSnackBar(context, content: 'User data not found');
          return;
        }

        // Update user data with the new name
        final updatedUser = userData.copyWith(
          userName: nameController.text.trim(),
        );

        // Save the updated user data
        await ref.read(userNotifierProvider.notifier).saveUser(updatedUser);

        if (context.mounted) {
          context.go(RouteName.home);
        }
      } catch (e) {
        showSnackBar(context, content: e.toString());
      } finally {
        isLoading.value = false;
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "What's your name?",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Please enter your name to continue.",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),
              TextFieldWidget(
                controller: nameController,
                hintText: 'Enter your name',
                onChanged: (_) {},
                fillColor: ColorConfig.white,
              ),
              const SizedBox(height: 24),
              ButtonWidget(
                onPressed: onSubmit,
                title: 'Continue',
                isLoading: isLoading.value,
                backgroundColor: ColorConfig.primarySwatch,
                textColor: ColorConfig.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 