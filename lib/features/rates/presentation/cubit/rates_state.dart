part of 'rates_cubit.dart';

/// Состояния экрана курсов валют.
@immutable
sealed class RatesState extends Equatable {
  const RatesState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние.
class RatesInitial extends RatesState {
  const RatesInitial();
}

/// Состояние загрузки данных.
class RatesLoading extends RatesState {
  const RatesLoading();
}

/// Состояние успешной загрузки данных.
class RatesLoaded extends RatesState {
  final RatesSnapshotEntity snapshot;

  const RatesLoaded(this.snapshot);

  @override
  List<Object?> get props => [snapshot];
}

/// Состояние ошибки.
class RatesFailure extends RatesState {
  final AppFailure failure;

  const RatesFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}
