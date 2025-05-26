import 'package:dongi/modules/box/data/di/box_di.dart';
import 'package:dongi/modules/box/domain/di/box_controller_di.dart';
import 'package:dongi/modules/box/domain/models/box_model.dart';
import 'package:dongi/modules/box/domain/repository/box_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/utilities/helpers/snackbar_helper.dart';
import '../../../group/domain/models/group_model.dart';
import '../../../../core/router/router_names.dart';
import '../../../../shared/widgets/appbar/sliver_appbar.dart';
import '../../../../shared/widgets/error/error.dart';
import '../../../../shared/widgets/floating_action_button/floating_action_button.dart';
import '../../../../shared/widgets/loading/loading.dart';
import '../widgets/box_detail_widget.dart';

// Convert to StatefulWidget to prevent infinite refreshes
class BoxDetailPage extends ConsumerStatefulWidget {
  final String boxId;
  final GroupModel groupModel;
  const BoxDetailPage({
    super.key,
    required this.boxId,
    required this.groupModel,
  });

  @override
  ConsumerState<BoxDetailPage> createState() => _BoxDetailPageState();
}

class _BoxDetailPageState extends ConsumerState<BoxDetailPage> {
  BoxModel? _boxModel;
  bool _isLoading = true;
  String? _error;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Load data once when widget initializes
    _fetchBoxDetail();
  }

  Future<void> _fetchBoxDetail() async {
    // Prevent loading multiple times
    if (_isInitialized) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Get repository directly to bypass provider system
      final boxRepository = ref.read(boxRepositoryProvider);

      // Fetch box details directly from repository
      final boxResult = await boxRepository.getBoxDetail(widget.boxId);

      // Handle the repository response based on its structure
      if (boxResult != null) {
        setState(() {
          _boxModel = BoxModel.fromJson(boxResult.data);
          _isLoading = false;
          _isInitialized = true;
        });
      } else {
        setState(() {
          _error = "Failed to load box details";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use local state instead of watching providers
    if (_isLoading) {
      return const LoadingWidget();
    }

    if (_error != null) {
      return ErrorTextWidget(_error!);
    }

    // Make sure box model is available
    if (_boxModel == null) {
      return const ErrorTextWidget("Box not found");
    }

    return Scaffold(
      body: SliverAppBarWidget(
        image: _boxModel!.image,
        height: 200,
        appbarTitle: TotalExpenseBoxDetail(_boxModel!.total),
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const CategoryListBoxDetail(),
            ExpenseListBoxDetail(
              boxModel: _boxModel!,
              groupModel: widget.groupModel,
            ),
          ],
        ),
      ),
      floatingActionButton: FABWidget(
        title: 'Expense',
        onPressed: () => context.push(
          RouteName.createExpense,
          extra: {"boxModel": _boxModel, "groupModel": widget.groupModel},
        ),
      ),
    );
  }
}
