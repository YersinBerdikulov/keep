import 'package:dongi/core/constants/font_config.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/shared/widgets/appbar/appbar.dart';
import 'package:dongi/shared/widgets/button/button_widget.dart';
import 'package:dongi/shared/widgets/button/primary_button_widget.dart';
import 'package:dongi/shared/widgets/button/secondary_button_widget.dart';
import 'package:dongi/shared/widgets/text_field/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/router/router_names.dart';

class AuthEntryPage extends HookConsumerWidget {
  const AuthEntryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController emailController = TextEditingController();
    final isLoading = ref.watch(authControllerProvider).maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(
        title: "",
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.help_outline),
        //     onPressed: () {
        //       // TODO: Navigate to support/help page
        //     },
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter your email here',
                  style: FontConfig.headlineSmall(),
                ),
                const SizedBox(height: 24),
                // Email Input Field
                TextFieldWidget(
                  controller: emailController,
                  hintText: 'Email Address',
                ),
              ],
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: SecondaryButtonWidget(
                    title: "Google",
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
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: PrimaryButtonWidget(
                    title: "Next",
                    onPressed: () {
                      final email = emailController.text.trim();
                      if (email.isNotEmpty) {
                        context.go(RouteName.signupEmail);
                      }
                    },
                    isLoading: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
