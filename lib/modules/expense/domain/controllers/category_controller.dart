import 'package:dongi/modules/expense/data/di/category_di.dart';
import 'package:dongi/modules/expense/domain/repository/category_repository.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Simple category class, not using freezed
class Category {
  final String? id;
  final String name;
  final String icon;

  Category({
    this.id,
    required this.name,
    required this.icon,
  });

  @override
  String toString() => 'Category(id: $id, name: $name, icon: $icon)';
}

class CategoryNotifier extends AsyncNotifier<List<Category>> {
  late CategoryRepository _categoryRepository;

  @override
  Future<List<Category>> build() async {
    _categoryRepository = ref.watch(categoryRepositoryProvider);

    // Try to get categories from the repository
    try {
      final categories = await _categoryRepository.getCategories();
      if (categories.isNotEmpty) {
        return categories;
      } else {
        // No categories found, create default ones
        return await _createDefaultCategories();
      }
    } catch (e) {
      print('Error fetching categories: $e');
      // If there's an error, try to create default categories
      return await _createDefaultCategories();
    }
  }

  Future<List<Category>> _createDefaultCategories() async {
    print('Creating default categories in database');
    final defaults = _getDefaultCategories();
    final created = <Category>[];

    for (var category in defaults) {
      try {
        // Generate a unique ID for each category
        final customId = DateTime.now().millisecondsSinceEpoch.toString() +
            '_${category.name.toLowerCase().replaceAll(' ', '_')}';

        final createdCategory =
            await _categoryRepository.addCategory(category, customId);

        created.add(createdCategory);
        print(
            'Created category: ${createdCategory.name} with ID: ${createdCategory.id}');
      } catch (e) {
        print('Error creating category ${category.name}: $e');
      }
    }

    if (created.isNotEmpty) {
      return created;
    }

    // If we couldn't create categories in DB, return the defaults without IDs
    return defaults;
  }

  List<Category> _getDefaultCategories() {
    return [
      Category(name: 'Food', icon: 'food'),
      Category(name: 'Transportation', icon: 'transportation'),
      Category(name: 'Entertainment', icon: 'entertainment'),
      Category(name: 'Shopping', icon: 'shopping'),
      Category(name: 'Bills', icon: 'bills'),
      Category(name: 'Health', icon: 'health'),
      Category(name: 'Travel', icon: 'travel'),
      Category(name: 'Education', icon: 'education'),
      Category(name: 'Others', icon: 'others'),
    ];
  }
}
