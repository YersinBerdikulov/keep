import 'package:dongi/modules/box/domain/di/box_controller_di.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/color_config.dart';
import '../../../../core/constants/font_config.dart';
import '../../../../core/router/router_names.dart';
import '../../../../shared/widgets/appbar/appbar.dart';
import '../../../../shared/widgets/button/button_widget.dart';
import '../../../../shared/widgets/card/card.dart';
import '../../../../shared/widgets/image/image_widget.dart';
import '../../domain/di/expense_controller_di.dart';
import '../pages/advanced_split_page.dart'; // Import for SplitMethod enum

class SplitPage extends ConsumerWidget {
  final TextEditingController expenseCost;
  const SplitPage({super.key, required this.expenseCost});

  Widget _buildSplitOption({
    required String title,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
    required String firstUserImage,
    required String secondUserImage,
  }) {
    return CardWidget(
      onTap: onTap,
      backColor: ColorConfig.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? ColorConfig.primarySwatch
                      : ColorConfig.primarySwatch.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected
                      ? ColorConfig.white
                      : ColorConfig.primarySwatch,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: FontConfig.body1().copyWith(
                        fontWeight: FontWeight.w500,
                        color: ColorConfig.midnight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: FontConfig.caption().copyWith(
                        color: ColorConfig.primarySwatch50,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const SizedBox(width: 40),
              _buildUserAvatar(firstUserImage, isSelected),
              _buildUserAvatar(secondUserImage, isSelected),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserAvatar(String imageUrl, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? ColorConfig.primarySwatch : Colors.transparent,
          width: 2,
        ),
      ),
      child: ImageWidget(
        imageUrl: imageUrl,
        width: 32,
        height: 32,
        borderRadius: 16,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userInBoxStoreProvider);
    final selectedOption = ref.watch(selectedSplitOptionProvider);
    final cost = num.tryParse(expenseCost.text.replaceAll(',', '')) ?? 0;
    final halfAmount = (cost / 2).toStringAsFixed(2);

    // Get user names safely
    String firstUserName = users.isNotEmpty
        ? (users[0].userName ?? users[0].email ?? "Unknown")
        : "Unknown";
    String secondUserName = users.length > 1
        ? (users[1].userName ?? users[1].email ?? "Unknown")
        : "Unknown";

    // Get user images safely
    String firstUserImage =
        users.isNotEmpty ? (users[0].profileImage ?? '') : '';
    String secondUserImage =
        users.length > 1 ? (users[1].profileImage ?? '') : '';

    return Scaffold(
      backgroundColor: ColorConfig.white,
      appBar: AppBarWidget(title: "Split Expense"),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSplitOption(
                  title: "$firstUserName paid, split equally",
                  description: "$secondUserName owes $halfAmount",
                  isSelected: selectedOption == 0,
                  onTap: () {
                    // Reset advanced split state
                    ref.read(advancedSplitMethodProvider.notifier).state = null;
                    ref.read(splitMethodProvider.notifier).state =
                        SplitMethod.equal;
                    // Set basic split option
                    ref.read(selectedSplitOptionProvider.notifier).state = 0;
                    print('Setting split users for equal split: ${users.map((e) => e.id!).toList()}');
                    ref.read(splitUserProvider.notifier).state =
                        users.map((e) => e.id!).toList();
                  },
                  firstUserImage: firstUserImage,
                  secondUserImage: secondUserImage,
                ),
                const SizedBox(height: 12),
                _buildSplitOption(
                  title: "$secondUserName owes full amount",
                  description:
                      "$secondUserName owes ${cost.toStringAsFixed(2)} to $firstUserName",
                  isSelected: selectedOption == 1,
                  onTap: () {
                    // Reset advanced split state
                    ref.read(advancedSplitMethodProvider.notifier).state = null;
                    ref.read(splitMethodProvider.notifier).state =
                        SplitMethod.equal;
                    // Set basic split option
                    ref.read(selectedSplitOptionProvider.notifier).state = 1;
                    ref.read(splitUserProvider.notifier).state =
                        users.length > 1 ? [users[1].id!] : [];
                  },
                  firstUserImage: firstUserImage,
                  secondUserImage: secondUserImage,
                ),
                const SizedBox(height: 12),
                _buildSplitOption(
                  title: "$secondUserName paid, split equally",
                  description: "$firstUserName owes $halfAmount",
                  isSelected: selectedOption == 2,
                  onTap: () {
                    // Reset advanced split state
                    ref.read(advancedSplitMethodProvider.notifier).state = null;
                    ref.read(splitMethodProvider.notifier).state =
                        SplitMethod.equal;
                    // Set basic split option
                    ref.read(selectedSplitOptionProvider.notifier).state = 2;
                    ref.read(splitUserProvider.notifier).state =
                        users.map((e) => e.id!).toList();
                  },
                  firstUserImage: firstUserImage,
                  secondUserImage: secondUserImage,
                ),
                const SizedBox(height: 12),
                _buildSplitOption(
                  title: "$secondUserName is owed full amount",
                  description:
                      "$firstUserName owes ${cost.toStringAsFixed(2)} to $secondUserName",
                  isSelected: selectedOption == 3,
                  onTap: () {
                    // Reset advanced split state
                    ref.read(advancedSplitMethodProvider.notifier).state = null;
                    ref.read(splitMethodProvider.notifier).state =
                        SplitMethod.equal;
                    // Set basic split option
                    ref.read(selectedSplitOptionProvider.notifier).state = 3;
                    ref.read(splitUserProvider.notifier).state =
                        users.isNotEmpty ? [users[0].id!] : [];
                  },
                  firstUserImage: firstUserImage,
                  secondUserImage: secondUserImage,
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: ColorConfig.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ButtonWidget(
                      onPressed: () => context.push(
                        RouteName.expenseAdvancedSplit,
                        extra: {"expenseCost": expenseCost},
                      ),
                      title: "Advanced Split Options",
                      textColor: ColorConfig.primarySwatch,
                      backgroundColor: ColorConfig.white,
                      borderColor: ColorConfig.primarySwatch,
                    ),
                    const SizedBox(height: 12),
                    ButtonWidget(
                      onPressed:
                          selectedOption >= 0 ? () => context.pop() : null,
                      title: "Confirm Split",
                      textColor: ColorConfig.secondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
