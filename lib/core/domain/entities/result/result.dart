typedef AsyncResult<S extends Object, F extends Object> = Future<Result<S, F>>;

sealed class Result<T, E extends Object> {
  const Result();

  const factory Result.success(T data) = Success;
  const factory Result.failure(E failure, [StackTrace? stackTrace]) = Failure;

  R fold<R>(
    R Function(T data) onSuccess,
    R Function(E failure, [StackTrace? stackTrace]) onFailure,
  ) {
    if (this is Success<T, E>) {
      final s = this as Success<T, E>;
      return onSuccess(s.data);
    } else {
      final f = this as Failure<T, E>;
      return onFailure(f.error, f.stackTrace);
    }
  }
}

final class Success<T, E extends Object> extends Result<T, E> {
  final T data;

  const Success(this.data);
}

final class Failure<T, E extends Object> extends Result<T, E> {
  final E error;
  final StackTrace? stackTrace;

  const Failure(this.error, [this.stackTrace]);
}
