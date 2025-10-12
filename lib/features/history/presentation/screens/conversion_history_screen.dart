import 'dart:convert';

import 'package:currency_rates/assets/strings/app_strings.dart';
import 'package:currency_rates/features/common/presentation/widgets/load_error_widget.dart';
import 'package:currency_rates/features/common/presentation/widgets/show_app_snackbar.dart';
import 'package:currency_rates/features/history/presentation/cubits/get_history_xml/get_history_xml_cubit.dart';
import 'package:currency_rates/features/history/presentation/cubits/history/history_cubit.dart';
import 'package:currency_rates/features/history/presentation/widgets/conversion_history_record_card_widget.dart';
import 'package:currency_rates/uikit/themes/colors/app_color_theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
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

  Future<String?> _pickSavePathAndSaveFile(GetHistoryXmlSuccess state) async {
    final timestamp = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
    final fileName = 'history_$timestamp.xml';
    final fileBytes = Uint8List.fromList(utf8.encode(state.xmlString));

    return await FilePicker.platform.saveFile(
      dialogTitle: AppStrings.saveHistory,
      fileName: fileName,
      type: FileType.custom,
      allowedExtensions: ['xml'],
      bytes: fileBytes,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.history, maxLines: 1),
        actions: [
          BlocBuilder<HistoryCubit, HistoryState>(
            buildWhen: (_, current) => current is HistoryLoadSuccess,
            builder: (_, state) {
              if (state is HistoryLoadSuccess) {
                return IconButton(
                  onPressed: () => context.read<GetHistoryXmlCubit>().fetchXmlString(),
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
      ),
      body: BlocListener<GetHistoryXmlCubit, GetHistoryXmlState>(
        listener: (context, state) async {
          if (state is GetHistoryXmlSuccess) {
            final savePath = await _pickSavePathAndSaveFile(state);
            if (savePath != null && context.mounted) {
              showAppSnackBar(context, AppStrings.exportSuccess);
            }
          }
          if (state is GetHistoryXmlFailure) {
            showDialog(
              // ignore: use_build_context_synchronously
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
