/// Базовый тип для представления результата операции:
/// успешного ([Success]) или неуспешного ([Failure]).
sealed class Result<T, E extends Object> {
  const Result();

  const factory Result.success(T data) = Success;
  const factory Result.failure(E failure, [StackTrace? stackTrace]) = Failure;

  /// Возвращает `true`, если результат [Success].
  bool get isSuccess => this is Success<T, E>;

  /// Возвращает `true`, если результат [Failure].
  bool get isFailure => this is Failure<T, E>;

  /// Возвращает данные, если результат [Success], иначе `null`.
  T? get success => this is Success<T, E> ? (this as Success<T, E>).data : null;

  /// Возвращает ошибку, если результат [Failure], иначе `null`.
  E? get failure => this is Failure<T, E> ? (this as Failure<T, E>).error : null;
}

/// Успешный результат операции с данными типа [T].
final class Success<T, E extends Object> extends Result<T, E> {
  final T data;

  const Success(this.data);
}

/// Ошибочный результат операции с ошибкой типа [E].
final class Failure<T, E extends Object> extends Result<T, E> {
  final E error;
  final StackTrace? stackTrace;

  const Failure(this.error, [this.stackTrace]);
}
