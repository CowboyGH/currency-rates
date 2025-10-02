import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:currency_rates/api/services/api_client.dart';
import 'package:currency_rates/core/services/network_service.dart';
import 'package:currency_rates/features/app/di/di.dart';
import 'package:currency_rates/features/history/data/repositories/history_repository_impl.dart';
import 'package:currency_rates/features/history/data/sources/history_local_data_source_impl.dart';
import 'package:currency_rates/features/history/domain/repositories/i_history_repository.dart';
import 'package:currency_rates/features/history/domain/sources/i_history_local_data_source.dart';
import 'package:currency_rates/features/history/domain/usecases/save_record_usecase.dart';
import 'package:currency_rates/features/history/presentation/cubits/save_record/save_record_cubit.dart';
import 'package:currency_rates/features/rates/data/repositories/rates_repository_impl.dart';
import 'package:currency_rates/features/rates/data/sources/rates_remote_data_source_impl.dart';
import 'package:currency_rates/features/rates/domain/repositories/i_rates_repository.dart';
import 'package:currency_rates/features/rates/domain/sources/i_rates_remote_data_source.dart';
import 'package:currency_rates/features/rates/domain/usecases/convert_currency_usecase.dart';
import 'package:currency_rates/features/rates/domain/usecases/get_rates_usecase.dart';
import 'package:currency_rates/features/rates/presentation/cubits/conversion/conversion_cubit.dart';
import 'package:currency_rates/features/rates/presentation/cubits/rates/rates_cubit.dart';
import 'package:currency_rates/features/rates/presentation/currency_rates_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

/// Билдер для экрана курсов валют.
class CurrencyRatesScreenBuilder extends StatelessWidget {
  const CurrencyRatesScreenBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<IRatesRemoteDataSource>(
          create: (_) => RatesRemoteDataSourceImpl(apiClient: di<ApiClient>()),
        ),
        Provider<IHistoryLocalDataSource>(
          create: (context) => HistoryLocalDataSourceImpl(di<Box<dynamic>>()),
        ),
        Provider<IRatesRepository>(
          create: (context) =>
              RatesRepositoryImpl(remoteDataSource: context.read<IRatesRemoteDataSource>()),
        ),
        Provider<IHistoryRepository>(
          create: (context) =>
              HistoryRepositoryImpl(localDataSource: context.read<IHistoryLocalDataSource>()),
        ),
        Provider<GetRatesUsecase>(
          create: (context) => GetRatesUsecase(repository: context.read<IRatesRepository>()),
        ),
        Provider<SaveRecordUsecase>(
          create: (context) => SaveRecordUsecase(repository: context.read<IHistoryRepository>()),
        ),
        Provider<ConvertCurrencyUsecase>(
          create: (_) => ConvertCurrencyUsecase(),
        ),
        Provider<Connectivity>(
          create: (_) => Connectivity(),
        ),
        Provider<NetworkService>(
          create: (context) => NetworkService(connectivity: context.read<Connectivity>()),
          dispose: (_, value) => value.dispose(),
        ),
        BlocProvider<RatesCubit>(
          create: (context) => RatesCubit(
            context.read<NetworkService>(),
            context.read<GetRatesUsecase>(),
          ),
        ),
        BlocProvider<ConversionCubit>(
          create: (context) => ConversionCubit(context.read<ConvertCurrencyUsecase>()),
        ),
        Provider<SaveRecordCubit>(
          create: (context) => SaveRecordCubit(context.read<SaveRecordUsecase>()),
        ),
      ],
      child: const CurrencyRatesScreen(),
    );
  }
}
