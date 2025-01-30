import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/color_config.dart';
import '../../../../shared/utilities/helpers/snackbar_helper.dart';
import '../../domain/models/group_model.dart';
import '../../../../shared/widgets/appbar/appbar.dart';
import '../../domain/di/group_controller_di.dart';
import '../widgets/update_group_widget.dart';

class UpdateGroupPage extends HookConsumerWidget {
  final GroupModel groupModel;
  UpdateGroupPage({super.key, required this.groupModel});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupTitle = useTextEditingController(text: groupModel.title);
    final groupDescription =
        useTextEditingController(text: groupModel.description);
    final oldGroupImage = useState<String?>(groupModel.image);
    final newGroupImage = useState<File?>(null);

    /// Listen to changes in the groupNotifierProvider state
    ref.listen<AsyncValue<List<GroupModel>>>(
      groupNotifierProvider,
      (_, state) {
        state.when(
          data: (_) {
            showSnackBar(context, content: "Successfully updated!!");
            context.pop();
          },
          loading: () {
            // Handle loading if needed (optional)
          },
          error: (error, stackTrace) {
            showSnackBar(context, content: error.toString());
          },
        );
      },
    );

    return Scaffold(
      backgroundColor: ColorConfig.white,
      appBar: AppBarWidget(title: "Update Group"),
      body: Column(
        children: [
          UpdateGroupInfoCard(
            newGroupImage: newGroupImage,
            oldGroupImage: oldGroupImage,
            groupTitle: groupTitle,
            groupDescription: groupDescription,
            formKey: _formKey,
          ),
          const UpdateGroupAddFriendCard(),
          const Spacer(),
          UpgradeGroupCreateButton(
            formKey: _formKey,
            newGroupImage: newGroupImage,
            groupTitle: groupTitle,
            groupDescription: groupDescription,
            groupModel: groupModel,
          ),
        ],
      ),
    );
  }
}
