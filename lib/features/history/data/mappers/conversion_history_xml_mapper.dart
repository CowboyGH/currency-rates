import 'package:currency_rates/features/history/data/models/conversion_record_dto.dart';

/// Маппер для преобразования списка записей конвертации в XML-строку.
extension ConversionHistoryXmlMapper on List<ConversionRecordDto> {
  /// Преобразует список записей в XML-строку.
  String toXml() {
    final buffer = StringBuffer();
    buffer.writeln('<?xml version="1.0" encoding="UTF-8"?>');
    buffer.writeln('<History>');

    for (final record in this) {
      buffer.writeln('  <Record>');
      buffer.writeln('    <CharCode>${record.charCode}</CharCode>');
      buffer.writeln('    <Amount>${record.amount}</Amount>');
      buffer.writeln('    <Result>${record.result}</Result>');
      buffer.writeln('    <UnitRate>${record.unitRate}</UnitRate>');
      buffer.writeln('    <Timestamp>${record.timestamp}</Timestamp>');
      buffer.writeln('  </Record>');
    }

    buffer.writeln('</History>');
    return buffer.toString();
  }
}
