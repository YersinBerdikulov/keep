import 'package:dongi/modules/box/data/di/box_di.dart';
import 'package:dongi/modules/box/domain/usecases/delete_all_boxes_usecase.dart';
import 'package:dongi/modules/box/domain/usecases/update_box_usecase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final updateBoxUseCaseProvider = Provider((ref) {
  final boxRepository = ref.watch(boxRepositoryProvider); // From data layer
  return UpdateBoxUseCase(boxRepository); // Domain logic
});

final deleteAllBoxesUseCaseProvider = Provider((ref) {
  final boxRepository = ref.watch(boxRepositoryProvider); // From data layer
  return DeleteAllBoxesUseCase(boxRepository); // Domain logic
});
