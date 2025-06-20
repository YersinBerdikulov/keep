import 'dart:io';

import 'package:dongi/modules/group/domain/models/group_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/color_config.dart';
import '../../../../shared/utilities/helpers/snackbar_helper.dart';
import '../../../../shared/widgets/appbar/appbar.dart';
import '../../domain/di/group_controller_di.dart';
import '../widgets/create_group_widget.dart';

class CreateGroupPage extends HookConsumerWidget {
  CreateGroupPage({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupTitle = useTextEditingController();
    final groupDescription = useTextEditingController();
    final image = useState<File?>(null);
    final selectedFriends = useState<Set<String>>({});

    /// by using listen we are not gonna rebuild our app
    ref.listen<AsyncValue<List<GroupModel>>>(
      groupNotifierProvider,
      (previous, next) {
        next.when(
          data: (_) {
            showSnackBar(context, content: "Successfully Created!!");
            context.pop();
          },
          loading: () {
            // Optionally handle loading state if needed
          },
          error: (error, stackTrace) {
            showSnackBar(context, content: error.toString());
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBarWidget(
        title: "Create Group",
        showDrawer: false,
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    CreateGroupInfoCard(
                      image: image,
                      groupTitle: groupTitle,
                      groupDescription: groupDescription,
                      formKey: _formKey,
                    ),
                    CreateGroupAddFriend(
                      selectedFriends: selectedFriends,
                    ),
                    // Add bottom padding to ensure content isn't hidden behind the button
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            // Fixed position button at the bottom
            Container(
              decoration: BoxDecoration(
                color: ColorConfig.white,
                boxShadow: [
                  BoxShadow(
                    color: ColorConfig.primarySwatch.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: CreateGroupButton(
                formKey: _formKey,
                image: image,
                groupTitle: groupTitle,
                groupDescription: groupDescription,
                selectedFriends: selectedFriends,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
