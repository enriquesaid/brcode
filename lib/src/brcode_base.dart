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
  BRCodeValue(this.id, String value) : value = removeDiacritics(value);

  final int id;
  final String value;

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
    if (pixKey.isEmpty || pixKey.length > 99) {
      throw ArgumentError.value(
        pixKey,
        'pixKey',
        'must be between 1 and 99 characters',
      );
    }
    if (merchantName.isEmpty || merchantName.length > 25) {
      throw ArgumentError.value(
        merchantName,
        'merchantName',
        'must be between 1 and 25 characters',
      );
    }
    if (merchantCity.isEmpty || merchantCity.length > 15) {
      throw ArgumentError.value(
        merchantCity,
        'merchantCity',
        'must be between 1 and 15 characters',
      );
    }
    if (postalCode.length > 99) {
      throw ArgumentError.value(
        postalCode,
        'postalCode',
        'must be at most 99 characters',
      );
    }
    if (amount < 0 || !amount.isFinite) {
      throw ArgumentError.value(
        amount,
        'amount',
        'must be a non-negative finite number',
      );
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

  static final _crc = Crc16CcittFalse();
  static const _crcLength = 4;
  static const _crcId = 63;

  // EMV-QRCPS Tag IDs
  static const _tagPayloadFormatIndicator = 00;
  static const _tagPointOfInitiationMethod = 01;
  static const _tagMerchantAccountInformation = 26;
  static const _tagMerchantCategoryCode = 52;
  static const _tagTransactionCurrency = 53;
  static const _tagTransactionAmount = 54;
  static const _tagCountryCode = 58;
  static const _tagMerchantName = 59;
  static const _tagMerchantCity = 60;
  static const _tagPostalCode = 61;
  static const _tagAdditionalDataFieldTemplate = 62;

  // Merchant Account Information sub-tag IDs
  static const _subTagGui = 00;
  static const _subTagPixKey = 01;

  // Additional Data Field Template sub-tag IDs
  static const _subTagTxId = 05;

  // Default values
  static const _payloadFormatIndicatorValue = "01";
  static const _guiPix = "BR.GOV.BCB.PIX";
  static const _merchantCategoryCodeValue = "0000";
  static const _transactionCurrencyValue = "986"; // BRL
  static const _countryCodeValue = "BR";

  /// Generates the Pix code string.
  String generate() {
    final result = _buildValues({
      _tagPayloadFormatIndicator: _payloadFormatIndicatorValue,
      if (pointOfInitiationMethod != PointOfInitiationMethod.none)
        _tagPointOfInitiationMethod: pointOfInitiationMethod.value,
      _tagMerchantAccountInformation: _buildValues({
        _subTagGui: _guiPix,
        _subTagPixKey: pixKey,
      }),
      _tagMerchantCategoryCode: _merchantCategoryCodeValue,
      _tagTransactionCurrency: _transactionCurrencyValue,
      _tagTransactionAmount: amount.toStringAsFixed(2),
      _tagCountryCode: _countryCodeValue,
      _tagMerchantName: merchantName,
      _tagMerchantCity: merchantCity,
      if (postalCode.isNotEmpty) _tagPostalCode: postalCode,
      _tagAdditionalDataFieldTemplate: _buildValues({_subTagTxId: txId}),
    }, withCrc: true);

    return result;
  }

  String _buildValues(Map<int, String> map, {bool withCrc = false}) {
    final values = map.entries
        .map((e) => BRCodeValue(e.key, e.value).toString())
        .join("");

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
