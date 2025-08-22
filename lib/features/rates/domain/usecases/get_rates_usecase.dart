import 'package:currency_rates/core/domain/entities/result/async_result.dart';
import 'package:currency_rates/features/rates/domain/entities/rates_snapshot_entity.dart';
import 'package:currency_rates/features/rates/domain/repositories/i_rates_repository.dart';

/// Получает актуальные курсы валют из репозитория.
class GetRatesUsecase {
  final IRatesRepository _repository;

  GetRatesUsecase({required IRatesRepository repository}) : _repository = repository;

  AsyncResult<RatesSnapshotEntity> call() => _repository.getRates();
}
