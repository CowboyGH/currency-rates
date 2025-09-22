import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:currency_rates/core/domain/entities/result/async_result.dart';
import 'package:currency_rates/features/common/domain/entities/conversion_record_entity.dart';
import 'package:currency_rates/features/common/domain/repositories/i_history_repository.dart';
import 'package:currency_rates/features/common/domain/sources/i_history_local_data_source.dart';
import 'package:flutter/foundation.dart';

/// Реализация [IHistoryRepository].
final class HistoryRepositoryImpl implements IHistoryRepository {
  final IHistoryLocalDataSource _localDataSource;

  HistoryRepositoryImpl({required IHistoryLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  @override
  AsyncResult<List<ConversionRecordEntity>> getAll() async {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  AsyncResult<void> save(ConversionRecordEntity record) async {
    // TODO: implement save
    throw UnimplementedError();
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
