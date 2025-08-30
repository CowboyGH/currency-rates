part of 'conversion_cubit.dart';

/// Состояние конвертации валют.
@immutable
sealed class ConversionState extends Equatable {
  const ConversionState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние.
final class ConversionInitial extends ConversionState {
  const ConversionInitial();
}

/// Состояние успешной конвертации валюты.
final class ConversionSuccess extends ConversionState {
  final Decimal result;

  const ConversionSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

/// Состояние ошибки конвертации валюты.
final class ConversionError extends ConversionState {
  final AppFailure failure;

  const ConversionError(this.failure);

  @override
  List<Object?> get props => [failure];
}
