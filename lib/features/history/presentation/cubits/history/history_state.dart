part of 'history_cubit.dart';

/// Состояние истории конвертаций.
sealed class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

/// Начальное состояние.
final class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

/// Состояние загрузки данных.
final class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

/// Состояние успешной загрузки данных.
final class HistoryLoadSuccess extends HistoryState {
  final List<ConversionRecordEntity> records;

  const HistoryLoadSuccess(this.records);

  @override
  List<Object> get props => [records];
}

/// Состояние ошибки загрузки данных.
final class HistoryLoadError extends HistoryState {
  final AppFailure failure;

  const HistoryLoadError(this.failure);

  @override
  List<Object> get props => [failure];
}
