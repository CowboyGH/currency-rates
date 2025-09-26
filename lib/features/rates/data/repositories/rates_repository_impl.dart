import 'package:currency_rates/api/data/mappers/rates_snapshot_mapper.dart';
import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:currency_rates/core/domain/entities/failure/network/network_failure.dart';
import 'package:currency_rates/core/domain/entities/failure/unknown_failure.dart';
import 'package:currency_rates/core/domain/entities/result/async_result.dart';
import 'package:currency_rates/core/domain/entities/result/result.dart';
import 'package:currency_rates/features/rates/data/sources/rates_remote_data_source_impl.dart';
import 'package:currency_rates/features/rates/domain/entities/rates_snapshot_entity.dart';
import 'package:currency_rates/features/rates/domain/repositories/i_rates_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Реализация [IRatesRepository].
final class RatesRepositoryImpl implements IRatesRepository {
  final RatesRemoteDataSourceImpl _remoteDataSource;

  RatesRepositoryImpl({required RatesRemoteDataSourceImpl remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  AsyncResult<RatesSnapshotEntity> getRates() async {
    try {
      final snapshotDto = await _remoteDataSource.getRates();
      return Result.success(snapshotDto.toEntity());
    } on DioException catch (e) {
      final failure = switch (e.type) {
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.cancel ||
        DioExceptionType.connectionTimeout ||
        DioExceptionType.connectionError => const NoNetworkFailure(),
        _ => UnknownNetworkFailure(e),
      };
      _debugPrint(failure);
      return Result.failure(failure);
    } catch (e, s) {
      final failure = UnknownFailure(
        message: 'Неожиданная ошибка при загрузке курсов валют.',
        parentException: e,
        stackTrace: s,
      );
      _debugPrint(failure);
      return Result.failure(failure);
    }
  }
}

void _debugPrint(AppFailure failure) {
  debugPrint('Failure: ${failure.message}');
  debugPrint('Parent Exception: ${failure.parentException ?? 'null'}');
  debugPrint('StackTrace: ${failure.stackTrace ?? 'null'}');
}
