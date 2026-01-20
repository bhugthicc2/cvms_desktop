import '../../models/report/date_range.dart';

abstract class ReportAssembler<T> {
  Future<T> assemble({required DateRange range});
}
