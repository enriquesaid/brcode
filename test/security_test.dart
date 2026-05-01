import 'package:brcode/brcode.dart';
import 'package:test/test.dart';

void main() {
  group('BRCode Security Tests', () {
    test('throw error if pixKey is too long (> 99 characters)', () {
      final longPixKey = 'A' * 100;
      expect(
        () => BRCode(
          pixKey: longPixKey,
          merchantName: 'Enrique',
          merchantCity: 'São Paulo',
          amount: 100,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throw error if postalCode is too long (> 99 characters)', () {
      final longPostalCode = '1' * 100;
      expect(
        () => BRCode(
          pixKey: '123e4567-e12b-12d1-a456-426655440000',
          merchantName: 'Enrique',
          merchantCity: 'São Paulo',
          amount: 100,
          postalCode: longPostalCode,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throw error if amount is NaN', () {
      expect(
        () => BRCode(
          pixKey: '123e4567-e12b-12d1-a456-426655440000',
          merchantName: 'Enrique',
          merchantCity: 'São Paulo',
          amount: double.nan,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throw error if amount is Infinity', () {
      expect(
        () => BRCode(
          pixKey: '123e4567-e12b-12d1-a456-426655440000',
          merchantName: 'Enrique',
          merchantCity: 'São Paulo',
          amount: double.infinity,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
