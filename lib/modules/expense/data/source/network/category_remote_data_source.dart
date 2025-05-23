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

    print('Adding category to database: $data with id: $customId');

    try {
      final doc = await _db.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.categoryCollection,
        documentId: customId,
        data: data,
      );
      print('Category created successfully with ID: ${doc.$id}');

      // Return category with the ID from Appwrite
      return Category(
        id: doc.$id,
        name: category.name,
        icon: category.icon,
      );
    } catch (e) {
      print('Error creating category: $e');
      rethrow;
    }
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
    print('Fetching all categories from database');
    try {
      final categories = await _db.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.categoryCollection,
      );

      final result = categories.documents
          .map((doc) => Category(
                id: doc.$id,
                name: doc.data['name'] as String,
                icon: doc.data['icon'] as String,
              ))
          .toList();

      print('Fetched ${result.length} categories from database');
      for (var category in result) {
        print('Category: ${category.name}, ID: ${category.id}');
      }

      return result;
    } catch (e) {
      print('Error fetching categories: $e');
      rethrow;
    }
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
