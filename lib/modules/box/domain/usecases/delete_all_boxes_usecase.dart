import 'package:dongi/modules/box/domain/repository/box_repository.dart';

class DeleteAllBoxesUseCase {
  final BoxRepository boxRepository;

  DeleteAllBoxesUseCase(this.boxRepository);

  Future<void> execute(List<String> boxIds) async {
    await boxRepository.deleteAllBox(boxIds);
  }
}
