<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.
-->

# BRCode (Pix)

[![pub package](https://img.shields.io/pub/v/brcode.svg)](https://pub.dev/packages/brcode)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Dart package to generate **Pix** (Brazilian Instant Payment) static codes (BR Code).

It follows the standards defined by the Central Bank of Brazil (BCB).

## Features

*   **Generate Static Pix Codes**: Create the copy-paste code for static QR Codes.
*   **Validation**: Built-in validation for Pix Key, Merchant Name, City, Amount, and TxId to ensure compliance with standards.
*   **Customizable**: Support for Description (Postal Code), Transaction ID (TxId), and Point of Initiation Method.
*   **Lightweight**: Minimal dependencies.

## Installation

Add the dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  brcode: ^0.0.3
```

Or run:

```bash
dart pub add brcode
# or
flutter pub add brcode
```

## Usage

Simple example to generate a Pix code:

```dart
import 'package:brcode/brcode.dart';

void main() {
  final brCode = BRCode(
    pixKey: '123e4567-e12b-12d1-a456-426655440000', // CPF, Email, Phone, or Random Key
    merchantName: 'Enrique',
    merchantCity: 'Sao Paulo',
    amount: 100.00,
  );

  final code = brCode.generate();
  print(code);
  // Outputs the string ready to be encoded into a QR Code image
}
```

### Advanced Usage

```dart
final brCode = BRCode(
  pixKey: 'client@email.com',
  merchantName: 'My Store',
  merchantCity: 'Rio de Janeiro',
  amount: 50.50,
  postalCode: '12345-678', // Optional
  txId: 'ORDER12345',      // Optional: Custom Transaction ID (max 25 chars)
  pointOfInitiationMethod: PointOfInitiationMethod.unique, // Optional: 12 (Dynamic) or 11 (Static/Default)
);
```

## References

This package is based on the following official documentation:

*   [Manual do BR Code](https://www.bcb.gov.br/content/estabilidadefinanceira/spb_docs/ManualBRCode.pdf)
*   [Manual de Padrões para Iniciação do Pix](https://www.bcb.gov.br/content/estabilidadefinanceira/pix/Regulamento_Pix/II_ManualdePadroesparaIniciacaodoPix.pdf)

## License

MIT
