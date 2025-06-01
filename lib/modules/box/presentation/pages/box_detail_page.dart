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
import 'package:dongi/modules/expense/domain/di/expense_controller_di.dart';

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
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _fetchBoxDetail();
  }

  Future<void> _fetchBoxDetail() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final boxRepository = ref.read(boxRepositoryProvider);

      // Fetch box details directly from repository
      final boxResult = await boxRepository.getBoxDetail(widget.boxId);

      if (!mounted) return;

      try {
        setState(() {
          _boxModel = BoxModel.fromJson(boxResult.data);
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          showSnackBar(context, content: 'Error loading box: ${e.toString()}');
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, content: e.toString());
    }
  }

  Future<void> _handleRefresh() async {
    await _fetchBoxDetail();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_boxModel == null) {
      return const Scaffold(
        body: Center(
          child: Text('Box not found'),
        ),
      );
    }

    final selectedCategory = ref.watch(selectedCategoryFilterProvider);

    return Scaffold(
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _handleRefresh,
        child: SliverAppBarWidget(
          image: _boxModel!.image,
          height: 200,
          appbarTitle: BoxTitleHeader(_boxModel!),
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const CategoryListBoxDetail(),
              FriendListBoxDetail(
                _boxModel!,
                onBoxUpdate: (updatedBox) {
                  setState(() {
                    _boxModel = updatedBox;
                  });
                },
              ),
              ExpenseListBoxDetail(
                boxModel: _boxModel!,
                groupModel: widget.groupModel,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(
            RouteName.createExpense,
            extra: {
              "boxModel": _boxModel,
              "groupModel": widget.groupModel,
              "selectedCategory": selectedCategory,
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
