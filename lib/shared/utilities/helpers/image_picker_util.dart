import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

Future<List<File>> pickImages() async {
  List<File> images = [];
  try {
    final ImagePicker picker = ImagePicker();
    final imageFiles = await picker.pickMultiImage();
    if (imageFiles.isNotEmpty) {
      for (final image in imageFiles) {
        images.add(File(image.path));
      }
    }
    return images;
  } on PlatformException catch (e) {
    print('Failed to pick images: $e');
    return [];
  }
}

Future<File?> pickImage() async {
  try {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
      imageQuality: 85,
    );
    if (imageFile != null) {
      final file = File(imageFile.path);
      // Verify the file exists and is readable
      if (await file.exists()) {
        return file;
      }
    }
    return null;
  } on PlatformException catch (e) {
    print('Failed to pick image: $e');
    return null;
  } catch (e) {
    print('Unexpected error while picking image: $e');
    return null;
  }
}
