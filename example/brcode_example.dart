import 'package:brcode/brcode.dart';

void main() {
  final brCode = BRCode(
    pixKey: '123',
    merchantName: 'Enrique',
    merchantCity: 'São Paulo',
    amount: 5,
    postalCode: '01153000',
    pointOfInitiationMethod: PointOfInitiationMethod.nonUnique,
  );

  final code = brCode.generate();

  print('Generated: $code');
}
