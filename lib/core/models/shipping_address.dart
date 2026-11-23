class ShippingAddress {
  String zipCode;
  String city;
  String streetAddress;

  ShippingAddress({this.zipCode = '', this.city = '', this.streetAddress = ''});

  String get fullAddress => "$zipCode $city, $streetAddress".trim();
  ({String zipCode, String city, String streetAddress}) get addressParts =>
      (zipCode: zipCode, city: city, streetAddress: streetAddress);

  String? validate() {
    if (zipCode.trim().isEmpty) return 'input_error_address_zip_empty';
    if (city.trim().isEmpty) return 'input_error_address_city';
    if (streetAddress.trim().isEmpty) return 'input_error_address_street';

    final hufZipRegex = RegExp(r'^\d{4}$');
    if (!hufZipRegex.hasMatch(zipCode.trim())) {
      return 'input_error_address_zip_invalid';
    }

    return null; // Valid state
  }

  Map<String, dynamic> toJson() => {
    'zipCode': zipCode,
    'city': city,
    'streetAddress': streetAddress,
  };

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      zipCode: json['zipCode'] ?? '',
      city: json['city'] ?? '',
      streetAddress: json['streetAddress'] ?? '',
    );
  }
}
