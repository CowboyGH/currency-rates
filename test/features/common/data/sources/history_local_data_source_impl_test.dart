import 'package:currency_rates/features/common/data/sources/history_local_data_source_impl.dart';
import 'package:currency_rates/features/common/domain/sources/i_history_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/annotations.dart';

import 'history_local_data_source_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Box<Map<String, dynamic>>>()])
void main() {
  late IHistoryLocalDataSource historyLocalDataSource;
  late MockBox mockBox;

  setUp(() {
    mockBox = MockBox();
    historyLocalDataSource = HistoryLocalDataSourceImpl(mockBox);
  });
}
