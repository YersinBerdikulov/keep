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

    // Calculate bottom padding to account for the update button height
    final bottomPadding = MediaQuery.of(context).padding.bottom +
        80.0; // 80.0 is approximate button height with padding

    return Scaffold(
      backgroundColor: ColorConfig.white,
      resizeToAvoidBottomInset:
          true, // Ensure the screen resizes when keyboard appears
      appBar: AppBarWidget(
        title: "Update Group",
        showDrawer: false,
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  UpdateGroupInfoCard(
                    newGroupImage: newGroupImage,
                    oldGroupImage: oldGroupImage,
                    groupTitle: groupTitle,
                    groupDescription: groupDescription,
                    formKey: _formKey,
                  ),
                  // Add padding at the bottom to prevent overlap with the update button
                  SizedBox(height: bottomPadding),
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
            child: UpgradeGroupCreateButton(
              formKey: _formKey,
              newGroupImage: newGroupImage,
              groupTitle: groupTitle,
              groupDescription: groupDescription,
              groupModel: groupModel,
            ),
          ),
        ],
      ),
    );
  }
}
