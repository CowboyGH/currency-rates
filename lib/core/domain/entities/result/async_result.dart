import 'package:currency_rates/core/domain/entities/result/result.dart';

typedef AsyncResult<S extends Object, F extends Object> = Future<Result<S, F>>;
