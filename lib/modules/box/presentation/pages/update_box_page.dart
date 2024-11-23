import 'dart:io';

import 'package:dongi/modules/box/domain/models/box_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/constants/color_config.dart';
import '../../../../core/utilities/helpers/snackbar_helper.dart';
import '../../../../widgets/appbar/appbar.dart';
import '../../domain/controllers/box_controller.dart';
import '../widgets/update_box_widget.dart';

class UpdateBoxPage extends HookConsumerWidget {
  final BoxModel boxModel;
  UpdateBoxPage({super.key, required this.boxModel});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boxTitle = useTextEditingController(text: boxModel.title);
    final boxDescription = useTextEditingController(text: boxModel.description);
    final oldBoxImage = useState<String?>(boxModel.image);
    final newBoxImage = useState<File?>(null);

    /// by using listen we are not gonna rebuild our app
    ref.listen<AsyncValue<List<BoxModel>>>(
      boxNotifierProvider,
      (previous, next) {
        next.when(
          data: (boxes) {
            showSnackBar(context, "Successfully Updated!!");
            context.pop(); // Navigate back after success
          },
          loading: () {
            // Optionally handle loading state if necessary
            // For example, show a loading indicator
          },
          error: (error, stackTrace) {
            showSnackBar(context, error.toString());
          },
        );
      },
    );

    return Scaffold(
      backgroundColor: ColorConfig.white,
      appBar: AppBarWidget(title: "Update Box"),
      body: Column(
        children: [
          UpdateBoxInfoCard(
            oldGroupImage: oldBoxImage,
            newGroupImage: newBoxImage,
            boxTitle: boxTitle,
            boxDescription: boxDescription,
            formKey: _formKey,
          ),
          const UpdateBoxSelectFriends(),
          const Spacer(),
          UpdateBoxButton(
            formKey: _formKey,
            newBoxImage: newBoxImage,
            boxTitle: boxTitle,
            boxDescription: boxDescription,
            boxModel: boxModel,
          ),
        ],
      ),
    );
  }
}
