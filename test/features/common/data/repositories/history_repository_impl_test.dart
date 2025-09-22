import 'package:currency_rates/features/common/data/repositories/history_repository_impl.dart';
import 'package:currency_rates/features/common/domain/repositories/i_history_repository.dart';
import 'package:currency_rates/features/common/domain/sources/i_history_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'history_repository_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<IHistoryLocalDataSource>()])
void main() {
  late IHistoryLocalDataSource historyLocalDataSource;
  late IHistoryRepository historyRepository;

  setUp(() {
    historyLocalDataSource = MockIHistoryLocalDataSource();
    historyRepository = HistoryRepositoryImpl(localDataSource: historyLocalDataSource);
  });
}
