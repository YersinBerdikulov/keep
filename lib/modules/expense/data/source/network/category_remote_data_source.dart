import 'package:appwrite/appwrite.dart';
import 'package:dongi/core/constants/appwrite_config.dart';
import 'package:dongi/modules/expense/domain/controllers/category_controller.dart';

class CategoryRemoteDataSource {
  final Databases _db;

  CategoryRemoteDataSource({required Databases db}) : _db = db;

  Future<Category> addCategory(Category category,
      {required String customId}) async {
    final data = {
      'name': category.name,
      'icon': category.icon,
    };

    _db.createDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.categoryCollection,
      documentId: customId,
      data: data,
    );
    return category;
  }

  Future<Category> updateCategory(Category category) async {
    final data = {
      'name': category.name,
      'icon': category.icon,
    };

    if (category.id != null) {
      _db.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.categoryCollection,
        documentId: category.id!,
        data: data,
      );
    }
    return category;
  }

  Future<bool> deleteCategory(String id) async {
    return false;
  }

  Future<List<Category>> getCategories() async {
    final categories = await _db.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.categoryCollection,
    );

    return categories.documents
        .map((doc) => Category(
              id: doc.$id,
              name: doc.data['name'] as String,
              icon: doc.data['icon'] as String,
            ))
        .toList();
  }

  Future<Category> getCategory(String id) async {
    try {
      final document = await _db.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.categoryCollection,
        documentId: id,
      );

      return Category(
        id: document.$id,
        name: document.data['name'] as String,
        icon: document.data['icon'] as String,
      );
    } catch (e) {
      rethrow;
    }
  }
}
