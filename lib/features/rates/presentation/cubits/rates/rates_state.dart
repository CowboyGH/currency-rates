part of 'rates_cubit.dart';

/// Состояния экрана курсов валют.
@immutable
sealed class RatesState extends Equatable {
  const RatesState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние.
final class RatesInitial extends RatesState {
  const RatesInitial();
}

/// Состояние загрузки данных.
final class RatesLoading extends RatesState {
  const RatesLoading();
}

/// Состояние успешной загрузки данных.
final class RatesLoaded extends RatesState {
  final RatesSnapshotEntity snapshot;

  const RatesLoaded(this.snapshot);

  @override
  List<Object?> get props => [snapshot];
}

/// Состояние, когда данные при обновлении не изменились.
/// Используется как сигнал для показа сообщения об актуальности данных.
final class RatesUnchanged extends RatesState {
  const RatesUnchanged();
}

/// Состояние ошибки.
final class RatesLoadError extends RatesState {
  final AppFailure failure;

  const RatesLoadError(this.failure);

  @override
  List<Object?> get props => [failure];
}
