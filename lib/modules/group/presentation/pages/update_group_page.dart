import 'dart:io';

import 'package:dongi/modules/group/domain/models/group_model.dart';
import 'package:dongi/shared/utilities/helpers/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/color_config.dart';
import '../../../../core/constants/font_config.dart';
import '../../../../core/router/router_names.dart';
import '../../../../shared/widgets/appbar/appbar.dart';
import '../../../auth/domain/di/auth_controller_di.dart';
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

    // Check if current user is admin or creator
    final currentUser = ref.watch(currentUserProvider);
    final isCreator = currentUser?.id == groupModel.creatorId;
    final isAdmin = ref.watch(isCurrentUserAdminProvider(groupModel.id ?? ''));
    final canEdit = isCreator || isAdmin;

    /// by using listen we are not gonna rebuild our app
    ref.listen<AsyncValue<List<GroupModel>>>(
      groupNotifierProvider,
      (previous, next) {
        next.when(
          data: (_) {
            showSnackBar(
              context,
              content: "Successfully Updated!",
              type: SnackBarType.success,
            );
            context.pop();
          },
          loading: () {
            // Optionally handle loading state if needed
          },
          error: (error, stackTrace) {
            // Show user-friendly message instead of the raw exception
            showSnackBar(
              context,
              content: error.toString(),
              type: SnackBarType.error,
            );

            // Important: Don't pop here - let the user navigate back manually
            // This prevents the error page from showing
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
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Permission indicator - styled version
              if (!canEdit)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: ColorConfig.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: ColorConfig.error.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: ColorConfig.error,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Only group admins can update group information",
                          style: FontConfig.body2().copyWith(
                            color: ColorConfig.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Add some spacing after the warning
              if (!canEdit) const SizedBox(height: 16),

              // Main scrollable content
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
                        groupModel: groupModel,
                      ),
                      // Add padding at the bottom to prevent overlap with the update button
                      SizedBox(height: bottomPadding),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Fixed position button at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
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
              padding: EdgeInsets.fromLTRB(
                  16, 16, 16, 16 + MediaQuery.of(context).padding.bottom),
              child: UpgradeGroupCreateButton(
                formKey: _formKey,
                newGroupImage: newGroupImage,
                groupTitle: groupTitle,
                groupDescription: groupDescription,
                groupModel: groupModel,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
