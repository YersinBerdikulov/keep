import 'package:dongi/modules/expense/domain/controllers/category_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final categoryNotifierProvider =
    AsyncNotifierProvider<CategoryNotifier, List<Category>>(
  CategoryNotifier.new,
);

final selectedCategoryProvider = StateProvider<Category?>((ref) => null);
