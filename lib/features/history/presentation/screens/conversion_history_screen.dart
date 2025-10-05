import 'package:currency_rates/assets/strings/app_strings.dart';
import 'package:currency_rates/features/common/presentation/widgets/load_error_widget.dart';
import 'package:currency_rates/features/common/presentation/widgets/show_app_snackbar.dart';
import 'package:currency_rates/features/history/presentation/cubits/export_history/export_history_cubit.dart';
import 'package:currency_rates/features/history/presentation/cubits/history/history_cubit.dart';
import 'package:currency_rates/features/history/presentation/widgets/conversion_history_record_card_widget.dart';
import 'package:currency_rates/uikit/themes/colors/app_color_theme.dart';
import 'package:currency_rates/uikit/themes/text/app_text_theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

/// Экран истории конвертаций.
class ConversionHistoryScreen extends StatefulWidget {
  const ConversionHistoryScreen({super.key});

  @override
  State<ConversionHistoryScreen> createState() => _ConversionHistoryScreenState();
}

class _ConversionHistoryScreenState extends State<ConversionHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryCubit>().loadHistory();
  }

  Future<void> _exportHistory(BuildContext context) async {
    final selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      final timestamp = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
      final filePath = '$selectedDirectory/history_$timestamp.xml';
      // ignore: use_build_context_synchronously
      context.read<ExportHistoryCubit>().exportHistory(filePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: colorTheme.surface,
        title: Text(
          AppStrings.history,
          style: textTheme.subtitle.copyWith(color: colorTheme.onBackground),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        actionsPadding: const EdgeInsets.only(right: 10),
        actions: [
          BlocBuilder<HistoryCubit, HistoryState>(
            buildWhen: (_, current) => current is HistoryLoadSuccess,
            builder: (_, state) {
              if (state is HistoryLoadSuccess) {
                return IconButton(
                  onPressed: () => _exportHistory(context),
                  icon: Icon(
                    Icons.save_alt,
                    color: colorTheme.onBackground,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: BlocListener<ExportHistoryCubit, ExportHistoryState>(
        listener: (context, state) {
          if (state is ExportHistorySuccess) {
            showAppSnackBar(context, AppStrings.exportSuccess);
          }
          if (state is ExportHistoryFailure) {
            showDialog(
              context: context,
              builder: (context) => LoadErrorWidget(message: state.failure.message),
            );
          }
        },
        child: BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, state) {
            switch (state) {
              case HistoryLoading():
                return const Center(child: CircularProgressIndicator.adaptive());
              case HistoryLoadSuccess():
                return ListView.separated(
                  itemCount: state.records.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemBuilder: (_, index) {
                    final record = state.records[index];
                    return ConversionHistoryRecordCardWidget(record: record);
                  },
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                );
              case HistoryLoadError():
                return LoadErrorWidget(message: state.failure.message);
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
