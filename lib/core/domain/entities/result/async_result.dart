import 'package:currency_rates/core/domain/entities/result/result.dart';

/// Асинхронный [Result] для всех методов, которые могут упасть.
/// В большинстве случаев это методы репозитория.
typedef AsyncResult<T> = Future<Result<T, Failure>>;
