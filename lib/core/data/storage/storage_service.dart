import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:dongi/core/constants/appwrite_config.dart';
import 'package:dongi/core/core.dart';
import 'package:fpdart/fpdart.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final Storage _storage;
  StorageService({required Storage storage}) : _storage = storage;

  FutureEither<List<String>> uploadImage(List<File> files) async {
    List<String> imageLinks = [];
    try {
      for (final file in files) {
        if (file == null || !(await file.exists())) {
          throw Exception('File is null or does not exist');
        }

        // Normalize the file path for Windows
        final normalizedPath = path.normalize(file.path);

        // Create a unique ID for the file
        final fileId = ID.unique();

        final uploadedImage = await _storage.createFile(
          bucketId: AppwriteConfig.imagesBucket,
          fileId: fileId,
          file: InputFile.fromPath(
            path: normalizedPath,
            filename: path.basename(normalizedPath),
          ),
        );

        final imageUrl = AppwriteConfig.imageUrl(uploadedImage.$id);
        imageLinks.add(imageUrl);
      }
      return right(imageLinks);
    } on AppwriteException catch (e, st) {
      print('Appwrite error during upload: ${e.message}');
      print('Error code: ${e.code}');
      print('Error type: ${e.type}');
      return left(
        Failure(
          e.message ?? 'Failed to upload image to storage',
          st,
        ),
      );
    } catch (e, st) {
      print('Unexpected error during upload: $e');
      return left(Failure(e.toString(), st));
    }
  }

  FutureEitherVoid deleteImage(String image) async {
    try {
      if (image.isEmpty) {
        return right(null);
      }

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
      print('Appwrite error during delete: ${e.message}');
      return left(
        Failure(
          e.message ?? 'Failed to delete image from storage',
          st,
        ),
      );
    } catch (e, st) {
      print('Unexpected error during delete: $e');
      return left(Failure(e.toString(), st));
    }
  }
}
