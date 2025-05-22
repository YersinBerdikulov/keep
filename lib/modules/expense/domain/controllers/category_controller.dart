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
      }
    } catch (e) {
      // If there's an error or no categories, return the defaults
    }

    // Return default categories if repository fetch fails or returns empty
    return _getDefaultCategories();
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
