import 'dart:io';

import 'package:currency_rates/core/domain/entities/failure/history/history_failure.dart';
import 'package:currency_rates/core/domain/entities/failure/unknown_failure.dart';
import 'package:currency_rates/features/history/data/mappers/conversion_history_xml_mapper.dart';
import 'package:currency_rates/features/history/data/models/conversion_record_dto.dart';
import 'package:currency_rates/features/history/domain/sources/i_history_local_data_source.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Реализация [IHistoryLocalDataSource].
final class HistoryLocalDataSourceImpl implements IHistoryLocalDataSource {
  final Box<dynamic> _box;

  HistoryLocalDataSourceImpl(this._box);

  @override
  List<ConversionRecordDto> readAllRecords() {
    try {
      final records = _box.values
          .map((e) => ConversionRecordDto.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      return records.reversed.toList();
    } on HiveError catch (e, s) {
      throw HistoryStorageFailure(parentException: e, stackTrace: s);
    } catch (e, s) {
      throw UnknownFailure(
        message: 'Неожиданная ошибка при получении истории',
        parentException: e,
        stackTrace: s,
      );
    }
  }

  @override
  Future<void> saveRecord(ConversionRecordDto dto) async {
    try {
      await _box.add(dto.toJson());
    } on HiveError catch (e, s) {
      throw HistorySaveFailure(parentException: e, stackTrace: s);
    } catch (e, s) {
      throw UnknownFailure(
        message: 'Неожиданная ошибка при сохранении записи',
        parentException: e,
        stackTrace: s,
      );
    }
  }

  @override
  Future<void> exportRecordsToXml(String path) async {
    final records = readAllRecords();
    try {
      final xml = records.toXml();
      final file = File(path);
      await file.writeAsString(xml);
    } on FileSystemException catch (e, s) {
      throw HistoryExportFailure(parentException: e, stackTrace: s);
    } catch (e, s) {
      throw UnknownFailure(
        message: 'Неожиданная ошибка при экспорте данных',
        parentException: e,
        stackTrace: s,
      );
    }
  }
}
