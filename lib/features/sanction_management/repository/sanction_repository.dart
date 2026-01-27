import 'package:cvms_desktop/features/sanction_management/models/saction_model.dart';

abstract class SanctionRepository {
  Stream<List<Sanction>> watchSanctions();
  Stream<List<Sanction>> watchActiveSanctions();
  Future<void> evaluateSanctionIfNeeded(Sanction sanction);
}
