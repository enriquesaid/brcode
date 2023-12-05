<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

Generates a Pix code!

## Features

It can generate a static Pix with the given info

## Getting started

Install the package
`flutter pub add brcode`

## Usage

```dart
final brCode = BRCode(
    pixKey: '123',
    merchantName: 'Enrique',
    merchantCity: 'São Paulo',
    amount: 100,
  );

final code = brCode.generate();
```

## Additional information

Made fallowing this guides

https://www.bcb.gov.br/content/estabilidadefinanceira/spb_docs/ManualBRCode.pdf
https://www.bcb.gov.br/content/estabilidadefinanceira/pix/Regulamento_Pix/II_ManualdePadroesparaIniciacaodoPix.pdf
