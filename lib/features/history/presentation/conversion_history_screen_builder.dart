import 'package:currency_rates/features/app/di/di.dart';
import 'package:currency_rates/features/common/data/repositories/history_repository_impl.dart';
import 'package:currency_rates/features/common/data/sources/history_local_data_source_impl.dart';
import 'package:currency_rates/features/common/domain/repositories/i_history_repository.dart';
import 'package:currency_rates/features/common/domain/sources/i_history_local_data_source.dart';
import 'package:currency_rates/features/history/domain/usecases/export_history_to_xml_usecase.dart';
import 'package:currency_rates/features/history/domain/usecases/get_history_usecase.dart';
import 'package:currency_rates/features/history/domain/usecases/save_record_usecase.dart';
import 'package:currency_rates/features/history/presentation/conversion_history_screen.dart';
import 'package:currency_rates/features/history/presentation/cubits/export_history/export_history_cubit.dart';
import 'package:currency_rates/features/history/presentation/cubits/history/history_cubit.dart';
import 'package:currency_rates/features/history/presentation/cubits/save_record/save_record_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

/// Билдер для экрана истории конвертаций.
class ConversionHistoryScreenBuilder extends StatelessWidget {
  const ConversionHistoryScreenBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        Provider<IHistoryLocalDataSource>(
          create: (context) => HistoryLocalDataSourceImpl(di<Box<dynamic>>()),
        ),
        Provider<IHistoryRepository>(
          create: (context) =>
              HistoryRepositoryImpl(localDataSource: context.read<IHistoryLocalDataSource>()),
        ),
        Provider<GetHistoryUsecase>(
          create: (context) => GetHistoryUsecase(repository: context.read<IHistoryRepository>()),
        ),
        Provider<HistoryCubit>(
          create: (context) => HistoryCubit(context.read<GetHistoryUsecase>()),
        ),
        Provider<SaveRecordUsecase>(
          create: (context) => SaveRecordUsecase(repository: context.read<IHistoryRepository>()),
        ),
        Provider<SaveRecordCubit>(
          create: (context) => SaveRecordCubit(context.read<SaveRecordUsecase>()),
        ),
        Provider<ExportHistoryToXmlUsecase>(
          create: (context) =>
              ExportHistoryToXmlUsecase(repository: context.read<IHistoryRepository>()),
        ),
        Provider<ExportHistoryCubit>(
          create: (context) => ExportHistoryCubit(context.read<ExportHistoryToXmlUsecase>()),
        ),
      ],
      child: const ConversionHistoryScreen(),
    );
  }
}
