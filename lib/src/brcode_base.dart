import 'dart:convert';
import 'package:crclib/catalog.dart';
import 'package:diacritic/diacritic.dart';

/// TODO: class Description
class BRCodeValue {
  BRCodeValue(this.id, this._value);

  final int id;
  final String _value;

  String get value => removeDiacritics(_value);
  String get formattedId => id.toString().padLeft(2, "0");
  String get formattedLength => value.length.toString().padLeft(2, "0");

  @override
  toString() {
    return '$formattedId$formattedLength$value';
  }
}

/// TODO: class Description
class BRCode {
  BRCode({
    required this.amout,
    required this.pixKey,
    required this.merchantName,
    this.merchantCity = '',
  });

  final String pixKey;
  final double amout;
  final String merchantName;
  final String merchantCity;

  final _crc = Crc16CcittFalse();
  final _crcLength = 4;
  final _crcId = 63;

  /// TODO: method Description
  String generate() {
    final result = _buildValues({
      00: "01",
      26: _buildValues({
        00: "br.gov.bcb.pix".toUpperCase(),
        01: pixKey.toUpperCase(),
      }),
      52: "0000",
      53: "986",
      54: amout.toStringAsFixed(2),
      58: "BR",
      59: merchantName,
      60: merchantCity,
      62: _buildValues({05: "***"}),
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
