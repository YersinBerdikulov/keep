import 'package:appwrite/appwrite.dart';
import 'package:dongi/core/constants/appwrite_config.dart';
import 'package:dongi/modules/expense/domain/models/category_model.dart';

class CategoryRemoteDataSource {
  final Databases _db;

  CategoryRemoteDataSource({required Databases db}) : _db = db;

  Future<CategoryModel> addCategory(CategoryModel category, {required String customId}) async {
    _db.createDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.categoryCollection,
      documentId: customId,
      data: category.toJson(),
    );
    return category;
  }

  Future<CategoryModel> updateCategory(CategoryModel category) async {
    _db.updateDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.categoryCollection,
      documentId: category.id,
      data: category.toJson(),
    );
    return category;
  }

  Future<bool> deleteCategory(String id) async {
    return false;
  }

  Future<List<CategoryModel>> getCategories() async {
    final categories = await _db.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.categoryCollection,
    );
    return categories.documents.map((e) => CategoryModel.fromJson(e)).toList();
  }

  Future<CategoryModel> getCategory(String id) async {
    try {
      final category = await _db.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.categoryCollection,
        documentId: id,
      );
      return CategoryModel.fromJson(category);
    } catch (e) {
      rethrow;
    }
  }
}
