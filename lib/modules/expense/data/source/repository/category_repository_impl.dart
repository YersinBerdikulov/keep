import 'package:dongi/modules/expense/data/source/network/category_remote_data_source.dart';
import 'package:dongi/modules/expense/domain/models/category_model.dart';
import 'package:dongi/modules/expense/domain/repository/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource _remoteDataSource;

  CategoryRepositoryImpl({required CategoryRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<CategoryModel>> getCategories() async {
    return _remoteDataSource.getCategories();
  }

  @override
  Future<CategoryModel> getCategory(String id) async {
    return _remoteDataSource.getCategory(id);
  }

  @override
  Future<CategoryModel> addCategory(CategoryModel category, String customId) async {
    return _remoteDataSource.addCategory(category, customId: customId);
  }

  @override
  Future<CategoryModel> updateCategory(CategoryModel category) async {
    return _remoteDataSource.updateCategory(category);
  }

  @override
  Future<bool> deleteCategory(String id) async {
    return _remoteDataSource.deleteCategory(id);
  }
}
