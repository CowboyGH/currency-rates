import 'package:currency_rates/api/data/currency_dto.dart';
import 'package:xml/xml.dart';

/// DTO для снимка курсов валют.
class RatesSnapshotDto {
  /// Дата, за которую получены курсы валют.
  final String date;

  /// Название источника.
  final String name;

  /// Cписок валют в формате DTO.
  final List<CurrencyDto> currencies;

  const RatesSnapshotDto({required this.date, required this.name, required this.currencies});

  /// Создаёт объект [RatesSnapshotDto] из строки XML.
  factory RatesSnapshotDto.fromXml(String xml) {
    final document = XmlDocument.parse(xml);
    final root = document.rootElement;
    final date = root.getAttribute('Date')!;
    final name = root.getAttribute('name')!;
    final currencies = root.findElements('Valute').map((e) => CurrencyDto.fromXml(e)).toList();
    return RatesSnapshotDto(date: date, name: name, currencies: currencies);
  }
}
