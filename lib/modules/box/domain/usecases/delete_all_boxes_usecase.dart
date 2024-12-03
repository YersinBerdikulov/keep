import 'package:dongi/modules/box/data/di/box_di.dart';
import 'package:dongi/modules/box/domain/repository/box_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final deleteAllBoxesUseCaseProvider = Provider((ref) {
  final boxRepository =
      ref.watch(boxRepositoryProvider); // From data/repository layer
  return DeleteAllBoxesUseCase(boxRepository); // Domain logic
});

class DeleteAllBoxesUseCase {
  final BoxRepository boxRepository;

  DeleteAllBoxesUseCase(this.boxRepository);

  Future<void> execute(List<String> boxIds) async {
    await boxRepository.deleteAllBox(boxIds);
  }
}
