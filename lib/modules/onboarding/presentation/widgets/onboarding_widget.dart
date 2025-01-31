import 'package:dongi/core/constants/color_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/content/onboarding_contents.dart';
import '../../../../core/constants/font_config.dart';
import '../../../../core/router/router_names.dart';
import '../../../../shared/widgets/button/button.dart';

class OnboardingTitle extends StatelessWidget {
  final int index;

  const OnboardingTitle(this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          onboardingContents[index].title,
          style: FontConfig.h6().copyWith(height: 1.4),
        ),
        const SizedBox(height: 10),
        Text(
          onboardingContents[index].desc,
          style: FontConfig.body1().copyWith(
            color: ColorConfig.primarySwatch.withAlpha((0.6 * 255).toInt()),
          ),
        ),
      ],
    );
  }
}

class OnboardingAnimatedDots extends StatelessWidget {
  final int currentPage;

  const OnboardingAnimatedDots(this.currentPage, {super.key});

  @override
  Widget build(BuildContext context) {
    AnimatedContainer dot(int index) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(50),
          ),
          color: currentPage == index
              ? ColorConfig.primarySwatch
              : ColorConfig.primarySwatch25,
        ),
        margin: const EdgeInsets.only(right: 5),
        height: 10,
        curve: Curves.easeIn,
        width: 10,
      );
    }

    return Row(
      children: List.generate(
        onboardingContents.length,
        (int index) => dot(index),
      ),
    );
  }
}

class OnboardingActionButtons extends StatelessWidget {
  final int index;
  final PageController controller;

  const OnboardingActionButtons({
    super.key,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: index + 1 == onboardingContents.length
          ? [
              Expanded(
                child: ButtonWidget(
                  title: "Start",
                  textColor: ColorConfig.secondary,
                  onPressed: () => context.go(
                    RouteName.authHome,
                  ),
                ),
              ),
            ]
          : [
              SizedBox(
                width: 50,
                child: ButtonWidget.outline(
                  title: "Skip",
                  textColor:
                      ColorConfig.midnight.withAlpha((0.6 * 255).toInt()),
                  onPressed: () {
                    controller.animateToPage(
                      2,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeIn,
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: ButtonWidget(
                  title: "Next",
                  textColor: ColorConfig.secondary,
                  onPressed: () {
                    controller.nextPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeIn,
                    );
                  },
                  backgroundColor: null,
                ),
              ),
            ],
    );
  }
}
