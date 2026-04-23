import 'package:brcode/brcode.dart';

void main() {
  try {
    // Create a BRCode instance with valid data
    final brCode = BRCode(
      pixKey: '123e4567-e12b-12d1-a456-426655440000', // Example Random Key
      merchantName: 'Enrique Utils',
      merchantCity: 'Sao Paulo',
      amount: 42.00,
      postalCode: '01153000',
      txId: 'TX123456', // Custom transaction ID
      pointOfInitiationMethod: PointOfInitiationMethod.nonUnique,
    );

    // Generate the code string
    final code = brCode.generate();

    print('Generated Pix Code:');
    print(code);

    // Example output (will vary due to CRC):
    // 00020126580014BR.GOV.BCB.PIX0136123e4567-e12b-12d1-a456-426655440000520400005303986540542.005802BR5913Enrique Utils6009Sao Paulo61080115300062120508TX1234566304...
  } catch (e) {
    print('Error generating code: $e');
  }

  // Example of validation error
  try {
    BRCode(
      pixKey: '', // Invalid: Empty key
      merchantName: 'Enrique',
      merchantCity: 'SP',
      amount: 10,
    );
  } catch (e) {
    print('\nExpected Validation Error:');
    print(e);
  }
}
