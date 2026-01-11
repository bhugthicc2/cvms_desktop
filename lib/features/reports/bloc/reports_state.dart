import 'package:equatable/equatable.dart';

class ReportsState extends Equatable {
  final bool showPdfPreview;
  final bool loading;
  final String? error;

  const ReportsState({
    this.showPdfPreview = false,
    this.loading = false,
    this.error,
  });

  ReportsState copyWith({bool? showPdfPreview, bool? loading, String? error}) {
    return ReportsState(
      showPdfPreview: showPdfPreview ?? this.showPdfPreview,
      loading: loading ?? this.loading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [showPdfPreview, loading, error];
}
