import 'package:dongi/modules/box/domain/models/box_model.dart';
import 'package:dongi/modules/box/domain/repository/box_repository.dart';

class UpdateBoxUseCase {
  final BoxRepository boxRepository;

  UpdateBoxUseCase(this.boxRepository);

  Future<void> execute(BoxModel updateBoxModel) async {
    await boxRepository.updateBox(updateBoxModel);
  }
}
