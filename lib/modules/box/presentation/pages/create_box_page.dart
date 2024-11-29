import 'dart:io';

import 'package:dongi/modules/box/domain/controllers/box_controller.dart';
import 'package:dongi/modules/box/domain/models/box_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/constants/color_config.dart';
import '../../../../core/utilities/helpers/snackbar_helper.dart';
import '../../../group/domain/models/group_model.dart';
import '../../../../widgets/appbar/appbar.dart';
import '../widgets/create_box_widget.dart';

class CreateBoxPage extends HookConsumerWidget {
  final GroupModel groupModel;
  CreateBoxPage({super.key, required this.groupModel});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boxTitle = useTextEditingController();
    final boxDescription = useTextEditingController();
    final image = useState<File?>(null);

    /// by using listen we are not gonna rebuild our app
    ref.listen<AsyncValue<List<BoxModel>>>(
      boxNotifierProvider(groupModel.id!),
      (previous, next) {
        next.when(
          data: (boxes) {
            // Show success message
            showSnackBar(context, "Successfully Created!!");
            context.pop(); // Navigate back
          },
          loading: () {
            // Optionally handle loading state if needed
          },
          error: (error, stackTrace) {
            // Show error in a snackbar
            showSnackBar(context, error.toString());
          },
        );
      },
    );

    return Scaffold(
      backgroundColor: ColorConfig.white,
      appBar: AppBarWidget(title: "Create Box"),
      body: Column(
        children: [
          CreateBoxInfoCard(
            image: image,
            boxTitle: boxTitle,
            boxDescription: boxDescription,
            formKey: _formKey,
          ),
          const CreateBoxSelectFriends(),
          const Spacer(),
          CreateBoxButton(
            formKey: _formKey,
            image: image,
            boxTitle: boxTitle,
            boxDescription: boxDescription,
            groupModel: groupModel,
          ),
        ],
      ),
    );
  }
}
