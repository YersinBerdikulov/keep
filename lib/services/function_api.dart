// import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
// import 'package:dongi/constants/appwrite_config.dart';
import 'package:dongi/core/core.dart';
import 'package:dongi/models/box_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../core/di/appwrite_di.dart';

final functionAPIProvider = Provider((ref) {
  return FunctionAPI(
    function: ref.watch(appwriteFunctionProvider),
  );
});

class FunctionAPI {
  final Functions _functions;
  FunctionAPI({required Functions function}) : _functions = function;

  FutureEitherVoid addBox(BoxModel boxModel) async {
    try {
      // final url = Uri.parse('https://669e5df249dd81fb8065.appwrite.global/');

      // final body = jsonEncode(boxModel.toJson());

      Execution response = await _functions.createExecution(
        functionId: '66a3ca45001839e3641e',
      );

      // final response = await http.post(
      //   url,
      //   headers: {
      //     'X-Appwrite-Project': AppwriteConfig.projectId,
      //     'X-Appwrite-API-Key': AppwriteConfig.functionAPIKey,
      //   },
      //   body: body,
      // );

      if (response.status == "200") {
        return right(null);
      } else {
        return left(
          Failure(
            'Can not add box, try later',
            StackTrace.current,
          ),
        );
      }
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  // FutureEitherVoid deleteImage(String image) async {
  //   try {
  //     String imageId = image.substring(
  //       image.indexOf('/files/') + 7,
  //       image.indexOf('/view'),
  //     );
  //     await _storage.deleteFile(
  //       bucketId: AppwriteConfig.imagesBucket,
  //       fileId: imageId,
  //     );
  //     return right(null);
  //   } on AppwriteException catch (e, st) {
  //     return left(
  //       Failure(
  //         e.message ?? 'Some unexpected error occurred',
  //         st,
  //       ),
  //     );
  //   } catch (e, st) {
  //     return left(Failure(e.toString(), st));
  //   }
  // }
}
