part of 'export_history_cubit.dart';

/// Состояние экспорта истории.
sealed class ExportHistoryState extends Equatable {
  const ExportHistoryState();

  @override
  List<Object> get props => [];
}

/// Начальное состояние.
final class ExportHistoryInitial extends ExportHistoryState {
  const ExportHistoryInitial();
}

/// Состояние экспорта истории.
final class ExportInProgress extends ExportHistoryState {
  const ExportInProgress();
}

/// Состояние успешного экспорта истории.
final class ExportHistorySuccess extends ExportHistoryState {
  const ExportHistorySuccess();
}

/// Состояние ошибки экспорта истории.
final class ExportHistoryFailure extends ExportHistoryState {
  final AppFailure failure;

  const ExportHistoryFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
