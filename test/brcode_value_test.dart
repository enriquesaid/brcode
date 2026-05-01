import 'package:brcode/brcode.dart';
import 'package:test/test.dart';

void main() {
  group('BRCodeValue', () {
    test('should format single digit ID with leading zero', () {
      final brValue = BRCodeValue(1, 'value');
      expect(brValue.formattedId, '01');
    });

    test('should format double digit ID correctly', () {
      final brValue = BRCodeValue(26, 'value');
      expect(brValue.formattedId, '26');
    });

    test('should format length with leading zero if less than 10', () {
      final brValue = BRCodeValue(1, 'abc');
      expect(brValue.formattedLength, '03');
    });

    test('should format length correctly if 10 or more', () {
      final brValue = BRCodeValue(1, '1234567890');
      expect(brValue.formattedLength, '10');
    });

    test('should remove diacritics from value', () {
      final brValue = BRCodeValue(1, 'São Paulo');
      expect(brValue.value, 'Sao Paulo');
    });

    test('toString should return correct TLV format', () {
      final brValue = BRCodeValue(59, 'Enrique');
      expect(brValue.toString(), '5907Enrique');
    });

    test('should handle empty value', () {
      final brValue = BRCodeValue(1, '');
      expect(brValue.formattedLength, '00');
      expect(brValue.toString(), '0100');
    });

    test('should handle maximum length value (99 characters)', () {
      final ninetyNineChars = 'A' * 99;
      final brValue = BRCodeValue(1, ninetyNineChars);
      expect(brValue.formattedLength, '99');
      expect(brValue.value.length, 99);
      expect(brValue.toString(), '0199$ninetyNineChars');
    });

    test('should throw assertion error if ID is negative', () {
      expect(() => BRCodeValue(-1, 'value'), throwsA(isA<AssertionError>()));
    });

    test('should throw assertion error if ID is greater than 99', () {
      expect(() => BRCodeValue(100, 'value'), throwsA(isA<AssertionError>()));
    });

    test('should throw assertion error if value length is greater than 99', () {
      final hundredChars = 'A' * 100;
      expect(
        () => BRCodeValue(1, hundredChars),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
