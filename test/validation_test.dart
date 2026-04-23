import 'package:brcode/src/brcode_base.dart';
import 'package:brcode/brcode.dart';
import 'package:test/test.dart';

void main() {
  group('Security Validation Tests', () {
    test('BRCodeValue throws ArgumentError if ID < 0', () {
      expect(() => BRCodeValue(-1, 'value'), throwsArgumentError);
    });

    test('BRCodeValue throws ArgumentError if ID > 99', () {
      expect(() => BRCodeValue(100, 'value'), throwsArgumentError);
    });

    test('BRCodeValue throws ArgumentError if value length > 99', () {
      final longValue = 'A' * 100;
      expect(() => BRCodeValue(1, longValue), throwsArgumentError);
    });

    test('BRCode throws ArgumentError if pixKey length > 77', () {
      final longPixKey = 'A' * 78;
      expect(
        () => BRCode(
          pixKey: longPixKey,
          merchantName: 'Name',
          merchantCity: 'City',
          amount: 1.0,
        ),
        throwsArgumentError,
      );
    });

    test('BRCode works with pixKey length of 77', () {
      final pixKey = 'A' * 77;
      final brCode = BRCode(
        pixKey: pixKey,
        merchantName: 'Name',
        merchantCity: 'City',
        amount: 1.0,
      );
      expect(brCode.generate(), isNotEmpty);
    });
  });
}
