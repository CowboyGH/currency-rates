import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:currency_rates/core/domain/entities/failure/history/history_failure.dart';
import 'package:currency_rates/core/domain/entities/failure/unknown_failure.dart';
import 'package:currency_rates/core/domain/entities/result/async_result.dart';
import 'package:currency_rates/core/domain/entities/result/result.dart';
import 'package:currency_rates/features/common/data/mappers/conversion_record_dto_mapper.dart';
import 'package:currency_rates/features/common/data/mappers/conversion_record_entity_mapper.dart';
import 'package:currency_rates/features/common/domain/entities/conversion_record_entity.dart';
import 'package:currency_rates/features/common/domain/repositories/i_history_repository.dart';
import 'package:currency_rates/features/common/domain/sources/i_history_local_data_source.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Реализация [IHistoryRepository].
final class HistoryRepositoryImpl implements IHistoryRepository {
  final IHistoryLocalDataSource _localDataSource;

  HistoryRepositoryImpl({required IHistoryLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  @override
  AsyncResult<List<ConversionRecordEntity>> getAll() async {
    try {
      final dtos = _localDataSource.readAll();
      if (dtos.isEmpty) {
        return Result.failure(HistoryEmptyFailure());
      }

      final entities = dtos.map((e) => e.toEntity()).toList();
      return Result.success(entities);
    } on HiveError {
      final failure = HistoryStorageFailure();
      _debugPrint(failure);
      return Result.failure(failure);
    } catch (e, s) {
      final failure = UnknownFailure(message: e.toString(), stackTrace: s);
      _debugPrint(failure);
      return Result.failure(failure);
    }
  }

  @override
  AsyncResult<void> save(ConversionRecordEntity record) async {
    try {
      await _localDataSource.save(record.toDto());
      return Result.success(null);
    } on HiveError {
      final failure = HistorySaveFailure();
      _debugPrint(failure);
      return Result.failure(failure);
    } catch (e, s) {
      final failure = UnknownFailure(message: e.toString(), stackTrace: s);
      _debugPrint(failure);
      return Result.failure(failure);
    }
  }

  @override
  AsyncResult<void> exportXml(String path) async {
    // TODO: implement exportXml
    throw UnimplementedError();
  }
}

void _debugPrint(AppFailure failure) {
  debugPrint('Failure: ${failure.message}');
  debugPrint('Parent Exception: ${failure.parentException ?? 'null'}');
  debugPrint('StackTrace: ${failure.stackTrace ?? 'null'}');
}
