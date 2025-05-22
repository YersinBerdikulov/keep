import 'package:dongi/modules/expense/domain/controllers/category_controller.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories();
  Future<Category> getCategory(String id);
  Future<Category> addCategory(Category category, String customId);
  Future<Category> updateCategory(Category category);
  Future<bool> deleteCategory(String id);
}
