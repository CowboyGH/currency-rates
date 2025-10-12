import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:currency_rates/core/domain/entities/failure/history/history_failure.dart';
import 'package:currency_rates/core/domain/entities/result/async_result.dart';
import 'package:currency_rates/core/domain/entities/result/result.dart';
import 'package:currency_rates/core/utils/logger.dart';
import 'package:currency_rates/features/history/data/mappers/conversion_record_dto_mapper.dart';
import 'package:currency_rates/features/history/data/mappers/conversion_record_entity_mapper.dart';
import 'package:currency_rates/features/history/domain/entities/conversion_record_entity.dart';
import 'package:currency_rates/features/history/domain/repositories/i_history_repository.dart';
import 'package:currency_rates/features/history/domain/sources/i_history_local_data_source.dart';

/// Реализация [IHistoryRepository].
final class HistoryRepositoryImpl implements IHistoryRepository {
  final IHistoryLocalDataSource _localDataSource;

  HistoryRepositoryImpl({required IHistoryLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  @override
  AsyncResult<List<ConversionRecordEntity>> getAllRecords() async {
    try {
      final dtos = _localDataSource.readAllRecords();
      if (dtos.isEmpty) {
        return Result.failure(HistoryEmptyFailure());
      }

      final entities = dtos.map((e) => e.toEntity()).toList();
      return Result.success(entities);
    } on AppFailure catch (e) {
      logFailure(e);
      return Result.failure(e);
    }
  }

  @override
  AsyncResult<void> saveRecord(ConversionRecordEntity record) async {
    try {
      await _localDataSource.saveRecord(record.toDto());
      return Result.success(null);
    } on AppFailure catch (e) {
      logFailure(e);
      return Result.failure(e);
    }
  }

  @override
  AsyncResult<String> getHistoryAsXmlString() async {
    try {
      final xml = await _localDataSource.getHistoryAsXmlString();
      return Result.success(xml);
    } on AppFailure catch (e) {
      logFailure(e);
      return Result.failure(e);
    }
  }
}
