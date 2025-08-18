import 'package:currency_rates/api/data/currency_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';

XmlElement parseValute(String xml) => XmlDocument.parse(xml).rootElement;

void main() {
  group('CurrencyDto.fromXml', () {
    test('парсит валюту из XML', () {
      const xml = '''
<Valute ID="R01010">
<NumCode>036</NumCode>
<CharCode>AUD</CharCode>
<Nominal>1</Nominal>
<Name>Австралийский доллар</Name>
<Value>52,0546</Value>
<VunitRate>52,0546</VunitRate>
</Valute>
''';
      final currency = CurrencyDto.fromXml(parseValute(xml));

      expect(currency.id, equals('R01010'));
      expect(currency.numCode, equals(36));
      expect(currency.charCode, equals('AUD'));
      expect(currency.nominal, equals(1));
      expect(currency.name, equals('Австралийский доллар'));
      expect(currency.value, closeTo(52.0546, 0.0001));
      expect(currency.unitRate, closeTo(52.0546, 0.0001));
    });

    test('парсит "." вместо "," в числе', () {
      const xml = '''
<Valute ID="R01010">
<NumCode>036</NumCode>
<CharCode>AUD</CharCode>
<Nominal>1</Nominal>
<Name>Австралийский доллар</Name>
<Value>52.0546</Value>
<VunitRate>52,0546</VunitRate>
</Valute>
''';
      final currency = CurrencyDto.fromXml(parseValute(xml));
      expect(currency.value, closeTo(52.0546, 0.0001));
    });
  });
}
