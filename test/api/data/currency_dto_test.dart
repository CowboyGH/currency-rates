import 'dart:io';

import 'package:currency_rates/api/data/currency_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';

XmlElement parseValute(String xml) => XmlDocument.parse(xml).rootElement;

void main() {
  group('CurrencyDto.fromXml', () {
    test('парсит валюту из XML', () {
      final xml = File('test/fixtures/currency/currency.xml').readAsStringSync();
      final currency = CurrencyDto.fromXml(parseValute(xml));

      expect(currency.id, equals('R01010'));
      expect(currency.numCode, equals('036'));
      expect(currency.charCode, equals('AUD'));
      expect(currency.nominal, equals(1));
      expect(currency.name, equals('Австралийский доллар'));
      expect(currency.value, closeTo(52.0546, 0.0001));
      expect(currency.unitRate, closeTo(52.0546, 0.0001));
    });

    test('парсит "." вместо "," в значении валюты', () {
      final xmlWithDot = File('test/fixtures/currency/currency_with_dot.xml').readAsStringSync();

      final currency = CurrencyDto.fromXml(parseValute(xmlWithDot));
      expect(currency.value, closeTo(52.0546, 0.0001));
      expect(currency.unitRate, closeTo(52.0546, 0.0001));
    });
  });
}
