import 'package:brcode/brcode.dart';

void main() {
  final brCode = BRCode(
    pixKey: '123',
    merchantName: 'Enrique',
    merchantCity: 'São Paulo',
    amout: 100,
  );

  final code = brCode.generate();

  print('Generated: $code');
}
