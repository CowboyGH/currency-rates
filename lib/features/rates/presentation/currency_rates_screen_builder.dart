import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:currency_rates/api/services/api_client.dart';
import 'package:currency_rates/core/services/network_service.dart';
import 'package:currency_rates/features/app/di/di.dart';
import 'package:currency_rates/features/rates/data/repositories/rates_repository_impl.dart';
import 'package:currency_rates/features/rates/data/sources/rates_remote_data_source.dart';
import 'package:currency_rates/features/rates/domain/repositories/i_rates_repository.dart';
import 'package:currency_rates/features/rates/domain/usecases/convert_currency_usecase.dart';
import 'package:currency_rates/features/rates/domain/usecases/get_rates_usecase.dart';
import 'package:currency_rates/features/rates/presentation/cubits/conversion/conversion_cubit.dart';
import 'package:currency_rates/features/rates/presentation/cubits/rates/rates_cubit.dart';
import 'package:currency_rates/features/rates/presentation/currency_rates_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

/// Билдер для экрана курсов валют.
class CurrencyRatesScreenBuilder extends StatelessWidget {
  const CurrencyRatesScreenBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<RatesRemoteDataSource>(
          create: (context) => RatesRemoteDataSource(apiClient: di<ApiClient>()),
        ),
        Provider<IRatesRepository>(
          create: (context) =>
              RatesRepositoryImpl(remoteDataSource: context.read<RatesRemoteDataSource>()),
        ),
        Provider<GetRatesUsecase>(
          create: (context) => GetRatesUsecase(repository: context.read<IRatesRepository>()),
        ),
        Provider<ConvertCurrencyUsecase>(
          create: (_) => ConvertCurrencyUsecase(),
        ),
        Provider<Connectivity>(
          create: (context) => Connectivity(),
        ),
        Provider<NetworkService>(
          create: (context) => NetworkService(connectivity: context.read<Connectivity>()),
          dispose: (context, value) => value.dispose(),
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
      ],
      child: const CurrencyRatesScreen(),
    );
  }
}
