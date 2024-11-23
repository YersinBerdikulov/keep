import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:dongi/core/constants/appwrite_config.dart';
import 'package:dongi/core/core.dart';
import 'package:fpdart/fpdart.dart';

class StorageService {
  final Storage _storage;
  StorageService({required Storage storage}) : _storage = storage;

  FutureEither<List<String>> uploadImage(List<File> files) async {
    List<String> imageLinks = [];
    try {
      for (final file in files) {
        final uploadedImage = await _storage.createFile(
          bucketId: AppwriteConfig.imagesBucket,
          fileId: ID.unique(),
          file: InputFile.fromPath(path: file.path),
        );
        imageLinks.add(
          AppwriteConfig.imageUrl(uploadedImage.$id),
        );
      }
      return right(imageLinks);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  FutureEitherVoid deleteImage(String image) async {
    try {
      String imageId = image.substring(
        image.indexOf('/files/') + 7,
        image.indexOf('/view'),
      );
      await _storage.deleteFile(
        bucketId: AppwriteConfig.imagesBucket,
        fileId: imageId,
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }
}
