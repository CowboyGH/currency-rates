part of 'save_record_cubit.dart';

/// Состояние сохранения записи.
sealed class SaveRecordState extends Equatable {
  const SaveRecordState();

  @override
  List<Object> get props => [];
}

/// Начальное состояние.
final class SaveRecordInitial extends SaveRecordState {
  const SaveRecordInitial();
}

/// Состояние сохранения записи.
final class SaveInProgress extends SaveRecordState {
  const SaveInProgress();
}

/// Состояние успешного сохранения записи.
final class SaveRecordSuccess extends SaveRecordState {
  const SaveRecordSuccess();
}

/// Состояние ошибки сохранения записи.
final class SaveRecordFailure extends SaveRecordState {
  final AppFailure failure;

  const SaveRecordFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
