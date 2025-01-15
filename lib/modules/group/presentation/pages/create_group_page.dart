import 'dart:io';

import 'package:dongi/modules/group/domain/models/group_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
            showSnackBar(context, "Successfully Created!!");
            context.pop();
          },
          loading: () {
            // Optionally handle loading state if needed
          },
          error: (error, stackTrace) {
            showSnackBar(context, error.toString());
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBarWidget(title: "Create Group"),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
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
              ],
            ),
          ),
          CreateGroupButton(
            formKey: _formKey,
            image: image,
            groupTitle: groupTitle,
            groupDescription: groupDescription,
            selectedFriends: selectedFriends,
          ),
        ],
      ),
    );
  }
}
