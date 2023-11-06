import 'package:brcode/brcode.dart';
import 'package:test/test.dart';

const mockPIX =
    '00020126580014BR.GOV.BCB.PIX0136123E4567-E12B-12D1-A456-4266554400005204000053039865406100.005802BR5907Enrique6009Sao Paulo62070503***6304B247';

void main() {
  group('BRCode', () {
    test('generate a valid pix code', () {
      final brCode = BRCode(
        pixKey: '123e4567-e12b-12d1-a456-426655440000',
        merchantName: 'Enrique',
        merchantCity: 'São Paulo',
        amout: 100,
      );

      final code = brCode.generate();

      expect(code, equals(mockPIX));
    });
  });
}
