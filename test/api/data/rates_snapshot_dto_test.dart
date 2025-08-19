import 'dart:io';

import 'package:currency_rates/api/data/rates_snapshot_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late String xml;
  late RatesSnapshotDto snapshot;

  setUp(() {
    xml = File('test/fixtures/snapshot.xml').readAsStringSync();
    snapshot = RatesSnapshotDto.fromXml(xml);
  });

  group('RatesSnapshotDto.fromXml', () {
    test('парсит корректную дату и имя', () {
      expect(snapshot.date, equals('16.08.2025'));
      expect(snapshot.name, equals('Foreign Currency Market'));
    });
  });

  test('парсит список валют', () {
    expect(snapshot.currencies.length, equals(2));
    expect(snapshot.currencies.first.charCode, equals('AUD'));
    expect(snapshot.currencies.last.charCode, equals('AZN'));
  });

  test('парсит пустой список валют', () {
    final emptyXml = File('test/fixtures/snapshot_empty.xml').readAsStringSync();
    final emptySnapshot = RatesSnapshotDto.fromXml(emptyXml);

    expect(emptySnapshot.currencies, isEmpty);
  });
}
