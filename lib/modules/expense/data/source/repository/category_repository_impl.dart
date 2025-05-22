import 'package:dongi/modules/expense/data/source/network/category_remote_data_source.dart';
import 'package:dongi/modules/expense/domain/controllers/category_controller.dart';
import 'package:dongi/modules/expense/domain/repository/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource _remoteDataSource;

  CategoryRepositoryImpl({required CategoryRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<Category>> getCategories() async {
    return _remoteDataSource.getCategories();
  }

  @override
  Future<Category> getCategory(String id) async {
    return _remoteDataSource.getCategory(id);
  }

  @override
  Future<Category> addCategory(Category category, String customId) async {
    return _remoteDataSource.addCategory(category, customId: customId);
  }

  @override
  Future<Category> updateCategory(Category category) async {
    return _remoteDataSource.updateCategory(category);
  }

  @override
  Future<bool> deleteCategory(String id) async {
    return _remoteDataSource.deleteCategory(id);
  }
}
