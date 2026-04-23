import 'package:brcode/brcode.dart';
import 'package:test/test.dart';

const mockPIX =
    '00020126580014BR.GOV.BCB.PIX0136123e4567-e12b-12d1-a456-4266554400005204000053039865406100.005802BR5907Enrique6009Sao Paulo62070503***6304968A';

void main() {
  group('BRCode', () {
    test('generate a valid pix code', () {
      final brCode = BRCode(
        pixKey: '123e4567-e12b-12d1-a456-426655440000',
        merchantName: 'Enrique',
        merchantCity: 'São Paulo',
        amount: 100,
      );

      final code = brCode.generate().toUpperCase();

      expect(code, equals(mockPIX.toUpperCase()));
    });

    test('generate a valid pix code with custom txId', () {
      final brCode = BRCode(
        pixKey: '123e4567-e12b-12d1-a456-426655440000',
        merchantName: 'Enrique',
        merchantCity: 'São Paulo',
        amount: 100,
        txId: 'MYID123',
      );

      final code = brCode.generate();
      // Check if code contains the txId
      expect(code.contains('62110507MYID123'), isTrue);
    });

    test('generate a valid pix code with postalCode', () {
      final brCode = BRCode(
        pixKey: '123e4567-e12b-12d1-a456-426655440000',
        merchantName: 'Enrique',
        merchantCity: 'São Paulo',
        amount: 100,
        postalCode: '12345678',
      );

      final code = brCode.generate();
      // Check if code contains the postalCode in tag 61
      expect(code.contains('610812345678'), isTrue);
    });

    test('throw error if pixKey is empty', () {
      expect(
        () => BRCode(
          pixKey: '',
          merchantName: 'Enrique',
          merchantCity: 'São Paulo',
          amount: 100,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throw error if merchantName is empty or too long', () {
      expect(
        () => BRCode(
          pixKey: '123',
          merchantName: '',
          merchantCity: 'São Paulo',
          amount: 100,
        ),
        throwsA(isA<ArgumentError>()),
      );

      expect(
        () => BRCode(
          pixKey: '123',
          merchantName:
              'A very long merchant name that exceeds twenty five characters',
          merchantCity: 'São Paulo',
          amount: 100,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throw error if merchantCity is empty or too long', () {
      expect(
        () => BRCode(
          pixKey: '123',
          merchantName: 'Enrique',
          merchantCity: '',
          amount: 100,
        ),
        throwsA(isA<ArgumentError>()),
      );

      expect(
        () => BRCode(
          pixKey: '123',
          merchantName: 'Enrique',
          merchantCity: 'A very long city name', // > 15 chars (21 chars)
          amount: 100,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throw error if amount is negative', () {
      expect(
        () => BRCode(
          pixKey: '123',
          merchantName: 'Enrique',
          merchantCity: 'São Paulo',
          amount: -100,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throw error if txId is too long', () {
      expect(
        () => BRCode(
          pixKey: '123',
          merchantName: 'Enrique',
          merchantCity: 'São Paulo',
          amount: 100,
          txId: '12345678901234567890123456', // 26 chars
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
