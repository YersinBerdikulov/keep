import 'package:dongi/modules/box/domain/di/box_controller_di.dart';
import 'package:dongi/modules/box/domain/models/box_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/color_config.dart';
import '../../../../core/constants/font_config.dart';
import '../../../../shared/utilities/helpers/snackbar_helper.dart';
import '../../domain/models/group_model.dart';
import '../../../user/domain/models/user_model.dart';
import '../../../../shared/widgets/card/box_card.dart';
import '../../../../shared/widgets/card/card.dart';
import '../../../../shared/widgets/error/error.dart';
import '../../../../shared/widgets/friends/friend.dart';
import '../../../../shared/widgets/loading/loading.dart';
import '../../domain/di/group_controller_di.dart';

class GroupDetailTitle extends StatelessWidget {
  final String groupName;
  const GroupDetailTitle({super.key, required this.groupName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.6),
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Group',
                  style: FontConfig.body2().copyWith(
                    color: ColorConfig.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  groupName,
                  style: FontConfig.h4().copyWith(
                    color: ColorConfig.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColorConfig.secondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: ColorConfig.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.people_alt_outlined,
              color: ColorConfig.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

class GroupDetailReviewBody extends StatelessWidget {
  final List<Widget> children;
  const GroupDetailReviewBody({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        decoration: BoxDecoration(
          color: ColorConfig.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: ListView(
          children: [
            Column(
              children: children,
            ),
          ],
        ),
      ),
    );
  }
}

class GroupDetailInfo extends StatelessWidget {
  final GroupModel groupModel;
  const GroupDetailInfo({super.key, required this.groupModel});

  Widget groupInfoCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: ColorConfig.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ColorConfig.primarySwatch25,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorConfig.primarySwatch.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const Spacer(),
              Text(
                title,
                style: FontConfig.caption().copyWith(
                  color: ColorConfig.primarySwatch50,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: FontConfig.body1().copyWith(
                  fontWeight: FontWeight.w600,
                  color: ColorConfig.midnight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(11, 0, 11, 16),
      child: Row(
        children: [
          groupInfoCard(
            "Total Balance",
            "\$${groupModel.totalBalance.toStringAsFixed(2)}",
            Icons.account_balance_wallet,
            ColorConfig.secondary,
          ),
          groupInfoCard(
            "Boxes",
            "${groupModel.boxIds.length} boxes",
            Icons.inbox_rounded,
            const Color(0xFF845EC2),
          ),
          groupInfoCard(
            "Members",
            "${groupModel.groupUsers.length} people",
            Icons.group_outlined,
            const Color(0xFF00B8A9),
          ),
        ],
      ),
    );
  }
}

class GroupDetailFriendList extends ConsumerWidget {
  final List<String> userIds;
  const GroupDetailFriendList({super.key, required this.userIds});

  Widget friendCard(UserModel user) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: ColorConfig.primarySwatch25,
                width: 2,
              ),
            ),
            child: FriendWidget(
              image: user.profileImage,
              width: 50,
              height: 50,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            user.userName ?? user.email,
            style: FontConfig.caption().copyWith(
              color: ColorConfig.midnight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget addFriendCard() {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: ColorConfig.secondary.withOpacity(0.3),
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: FriendWidget.add(),
          ),
          const SizedBox(height: 8),
          Text(
            "Invite",
            style: FontConfig.caption().copyWith(
              color: ColorConfig.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupDetail = ref.watch(usersInGroupProvider(userIds));

    return groupDetail.when(
      loading: () => const LoadingWidget(),
      error: (error, stackTrace) => ErrorTextWidget(error),
      data: (data) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Members',
                  style: FontConfig.body1(),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: ColorConfig.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "View All",
                    style: FontConfig.caption().copyWith(
                      color: ColorConfig.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (data.isEmpty)
            _buildEmptyMembers()
          else
            SizedBox(
              height: 90,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: [
                  ...data.map((user) => friendCard(user)).toList(),
                  addFriendCard(),
                ],
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildEmptyMembers() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ColorConfig.grey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorConfig.primarySwatch25,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorConfig.primarySwatch.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.group_off_outlined,
              size: 32,
              color: ColorConfig.primarySwatch,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "No Members Yet",
            style: FontConfig.h6().copyWith(
              color: ColorConfig.midnight,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Invite your friends to join this group",
            textAlign: TextAlign.center,
            style: FontConfig.body2().copyWith(
              color: ColorConfig.primarySwatch50,
            ),
          ),
        ],
      ),
    );
  }
}

class GroupDetailBoxGrid extends ConsumerWidget {
  final GroupModel groupModel;
  const GroupDetailBoxGrid({super.key, required this.groupModel});

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ColorConfig.grey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorConfig.primarySwatch25,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorConfig.primarySwatch.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inbox_outlined,
              size: 32,
              color: ColorConfig.primarySwatch,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Boxes Yet',
            style: FontConfig.h6().copyWith(
              color: ColorConfig.midnight,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first box to start tracking expenses',
            textAlign: TextAlign.center,
            style: FontConfig.body2().copyWith(
              color: ColorConfig.primarySwatch50,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boxesInGroup = ref.watch(boxNotifierProvider(groupModel.id!));

    return boxesInGroup.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(20),
        child: LoadingWidget(),
      ),
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.all(20),
        child: ErrorTextWidget(error),
      ),
      data: (data) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Boxes',
                  style: FontConfig.body1(),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: ColorConfig.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "View All",
                    style: FontConfig.caption().copyWith(
                      color: ColorConfig.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (data.isEmpty)
            _buildEmptyState()
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.8,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, i) => BoxCardWidget(
                  boxModel: data[i],
                  groupModel: groupModel,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
