

import 'package:dongi/modules/expense/domain/models/category_model.dart';

abstract class CategoryRepository {
  Future<List<CategoryModel>> getCategories();
  Future<CategoryModel> getCategory(String id);
  Future<CategoryModel> addCategory(CategoryModel category, String customId);
  Future<CategoryModel> updateCategory(CategoryModel category);
  Future<bool> deleteCategory(String id);
}