import 'package:xml/xml.dart';

/// DTO валюты.
class CurrencyDto {
  /// Идентификатор.
  final String id;

  /// Числовой код.
  final String numCode;

  /// Текстовый код.
  final String charCode;

  /// Номинал.
  final int nominal;

  /// Название.
  final String name;

  /// Значение.
  final double value;

  /// Стоимость за единицу валюты.
  final double unitRate;

  const CurrencyDto({
    required this.id,
    required this.numCode,
    required this.charCode,
    required this.nominal,
    required this.name,
    required this.value,
    required this.unitRate,
  });

  /// Создаёт объект [CurrencyDto] из XML-элемента.
  factory CurrencyDto.fromXml(XmlElement element) {
    String text(String tag) => element.findElements(tag).single.innerText;

    return CurrencyDto(
      id: element.getAttribute('ID')!,
      numCode: text('NumCode'),
      charCode: text('CharCode'),
      nominal: int.parse(text('Nominal')),
      name: text('Name'),
      value: double.parse(text('Value').replaceAll(',', '.')),
      unitRate: double.parse(text('VunitRate').replaceAll(',', '.')),
    );
  }
}
