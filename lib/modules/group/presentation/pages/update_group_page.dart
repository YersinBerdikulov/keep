import 'dart:io';

import 'package:dongi/modules/group/domain/models/group_model.dart';
import 'package:dongi/shared/utilities/helpers/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/color_config.dart';
import '../../../../shared/widgets/appbar/appbar.dart';
import '../../domain/di/group_controller_di.dart';
import '../widgets/update_group_widget.dart';

class UpdateGroupPage extends HookConsumerWidget {
  final GroupModel groupModel;
  final _formKey = GlobalKey<FormState>();

  UpdateGroupPage({super.key, required this.groupModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupTitle = useTextEditingController(text: groupModel.title);
    final groupDescription =
        useTextEditingController(text: groupModel.description);
    final newGroupImage = useState<File?>(null);
    final oldGroupImage = useState<String?>(groupModel.image);

    /// by using listen we are not gonna rebuild our app
    ref.listen<AsyncValue<List<GroupModel>>>(
      groupNotifierProvider,
      (previous, next) {
        next.when(
          data: (_) {
            showSnackBar(context, content: "Successfully Updated!!");
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
      backgroundColor: ColorConfig.white,
      appBar: AppBarWidget(
        title: "Update Group",
        showBackButton: true,
      ),
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
