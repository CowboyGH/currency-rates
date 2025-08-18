import 'package:currency_rates/api/data/rates_snapshot_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RatesSnapshotDto snapshot;

  group('RatesSnapshotDto.fromXml', () {
    const xml = '''
<ValCurs Date="16.08.2025" name="Foreign Currency Market">
<Valute ID="R01010">
<NumCode>036</NumCode>
<CharCode>AUD</CharCode>
<Nominal>1</Nominal>
<Name>Австралийский доллар</Name>
<Value>52,0546</Value>
<VunitRate>52,0546</VunitRate>
</Valute>
<Valute ID="R01020A">
<NumCode>944</NumCode>
<CharCode>AZN</CharCode>
<Nominal>1</Nominal>
<Name>Азербайджанский манат</Name>
<Value>47,0720</Value>
<VunitRate>47,072</VunitRate>
</Valute>
</ValCurs>
''';

    setUp(() {
      snapshot = RatesSnapshotDto.fromXml(xml);
    });

    test('парсит корректную дату и имя', () {
      expect(snapshot.date, equals('16.08.2025'));
      expect(snapshot.name, equals('Foreign Currency Market'));
    });

    expect(snapshot.date, equals('16.08.2025'));
    expect(snapshot.name, equals('Foreign Currency Market'));
  });

  test('парсит список валют', () {
    expect(snapshot.currencies.length, equals(2));
    expect(snapshot.currencies.first.charCode, equals('AUD'));
    expect(snapshot.currencies.last.charCode, equals('AZN'));
  });

  test('парсит пустой список валют', () {
    const emptyXml = '''
<ValCurs Date="16.08.2025" name="Foreign Currency Market">
</ValCurs>
''';
    final emptySnapshot = RatesSnapshotDto.fromXml(emptyXml);

    expect(emptySnapshot.currencies, isEmpty);
  });
}
