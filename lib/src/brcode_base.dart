import 'dart:convert';
import 'package:crclib/catalog.dart';
import 'package:diacritic/diacritic.dart';

enum PointOfInitiationMethod {
  none(""),
  unique("12"),
  nonUnique("11");

  const PointOfInitiationMethod(this.value);

  final String value;
}

/// Represents a value in the BR Code (Pix) structure.
///
/// It handles formatting the ID, length, and value according to the TLV standard.
class BRCodeValue {
  BRCodeValue(this.id, this._value);

  final int id;
  final String _value;

  String get value => removeDiacritics(_value);
  String get formattedId => id.toString().padLeft(2, "0");
  String get formattedLength => value.length.toString().padLeft(2, "0");

  @override
  String toString() {
    return '$formattedId$formattedLength$value';
  }
}

/// The main class for constructing and generating Brazilian Pix QR codes.
///
/// Generates a static Pix code (BR Code).
///
/// The [pixKey] is required and must not be empty.
/// The [merchantName] is required and must be between 1 and 25 characters.
/// The [merchantCity] is required and must be between 1 and 15 characters.
/// The [amount] must be non-negative.
/// The [txId] defaults to '***' (valid for static QR codes).
class BRCode {
  BRCode({
    required this.amount,
    required this.pixKey,
    required this.merchantName,
    this.merchantCity = '',
    this.postalCode = '',
    this.pointOfInitiationMethod = PointOfInitiationMethod.none,
    this.txId = '***',
  }) {
    if (pixKey.isEmpty) {
      throw ArgumentError.value(pixKey, 'pixKey', 'must not be empty');
    }
    if (merchantName.isEmpty || merchantName.length > 25) {
      throw ArgumentError.value(merchantName, 'merchantName', 'must be between 1 and 25 characters');
    }
    if (merchantCity.isEmpty || merchantCity.length > 15) {
      throw ArgumentError.value(merchantCity, 'merchantCity', 'must be between 1 and 15 characters');
    }
    if (amount < 0) {
      throw ArgumentError.value(amount, 'amount', 'must be non-negative');
    }
    // TxId validation could be stricter depending on requirements, but max length is important.
    // For static QR codes, it's often '***' or a user-defined identifier (max 25 chars).
    if (txId.length > 25) {
      throw ArgumentError.value(txId, 'txId', 'must be at most 25 characters');
    }
  }

  final String pixKey;
  final double amount;
  final String merchantName;
  final String merchantCity;
  final String postalCode;
  final PointOfInitiationMethod pointOfInitiationMethod;
  final String txId;

  final _crc = Crc16CcittFalse();
  final _crcLength = 4;
  final _crcId = 63;

  /// Generates the Pix code string.
  String generate() {
    final result = _buildValues({
      00: "01",
      if (pointOfInitiationMethod != PointOfInitiationMethod.none)
        01: pointOfInitiationMethod.value,
      26: _buildValues({
        00: "BR.GOV.BCB.PIX",
        01: pixKey,
      }),
      52: "0000",
      53: "986",
      54: amount.toStringAsFixed(2),
      58: "BR",
      59: merchantName,
      60: merchantCity,
      if (postalCode.isNotEmpty) 61: postalCode,
      62: _buildValues({05: txId}),
    }, withCrc: true);

    return result;
  }

  String _buildValues(Map<int, String> map, {bool withCrc = false}) {
    final values = List.from(
      map.entries.map(
        (e) => BRCodeValue(e.key, e.value).toString(),
      ),
    ).join("");

    final crc = withCrc ? _buildCrcValue(values) : '';

    return '$values$crc';
  }

  String _buildCrcValue(String data) {
    final length = _crcLength.toString().padLeft(2, "0");

    return BRCodeValue(_crcId, _toCrc('$data$_crcId$length')).toString();
  }

  String _toCrc(String data) {
    return _crc
        .convert(utf8.encode(data))
        .toRadixString(16)
        .padLeft(_crcLength, '0')
        .toUpperCase();
  }
}
