import 'package:dongi/core/constants/color_config.dart';
import 'package:dongi/core/constants/content/onboarding_contents.dart';
import 'package:dongi/core/constants/font_config.dart';
import 'package:dongi/core/constants/constant.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/home/domain/di/home_controller_di.dart';
import 'package:dongi/shared/widgets/button/primary_button_widget.dart';
import 'package:dongi/shared/widgets/button/secondary_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/router/router_names.dart';

class AuthEntryPage extends ConsumerStatefulWidget {
  const AuthEntryPage({super.key});

  @override
  ConsumerState<AuthEntryPage> createState() => _AuthEntryPageState();
}

class _AuthEntryPageState extends ConsumerState<AuthEntryPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Feature Slides
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: onboardingContents.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Image.asset(
                            onboardingContents[index].image,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          onboardingContents[index].title,
                          style: FontConfig.h4(),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          onboardingContents[index].desc,
                          style: FontConfig.body1().copyWith(
                            color: ColorConfig.primarySwatch
                                .withAlpha((0.6 * 255).toInt()),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Page Indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingContents.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? ColorConfig.primarySwatch
                          : ColorConfig.baseGrey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
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
                        ref.refresh(homeNotifierProvider);
                        context.go(RouteName.home);
                      }
                    },
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButtonWidget(
                          title: "Sign Up",
                          onPressed: () => context.go(RouteName.signupEmail),
                          isLoading: false,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: PrimaryButtonWidget(
                          title: "Sign In",
                          onPressed: () => context.go(RouteName.signin),
                          isLoading: false,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
