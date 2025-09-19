import 'package:currency_rates/features/common/data/models/conversion_record_dto.dart';
import 'package:currency_rates/features/common/domain/sources/i_history_local_data_source.dart';
import 'package:hive_flutter/hive_flutter.dart';

final class HistoryLocalDataSourceImpl implements IHistoryLocalDataSource {
  final Box<Map<String, dynamic>> _box;

  HistoryLocalDataSourceImpl(this._box);

  @override
  List<ConversionRecordDto> readAll() {
    // TODO: implement readAll
    throw UnimplementedError();
  }

  @override
  Future<void> save(ConversionRecordDto dto) async {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<void> exportXml() async {
    // TODO: implement exportXml
    throw UnimplementedError();
  }
}
