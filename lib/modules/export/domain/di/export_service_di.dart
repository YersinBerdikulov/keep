import 'package:dongi/modules/export/services/export_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final exportServiceProvider = Provider<ExportService>((ref) {
  return ExportService();
});
