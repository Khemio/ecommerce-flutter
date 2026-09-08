
class ShippingAddress {
  String zipCode;
  String city;
  String streetAddress;

  ShippingAddress({
    this.zipCode = '',
    this.city = '',
    this.streetAddress = '',
  });

  String get fullAddress => "$zipCode $city, $streetAddress".trim();
  ({String zipCode, String city, String streetAddress})
    get addressParts => (zipCode: zipCode, city: city, streetAddress: streetAddress);

  String? validate() {
    if (zipCode.trim().isEmpty) return 'Zip code is required';
    if (city.trim().isEmpty) return 'City field is required';
    if (streetAddress.trim().isEmpty) return 'Street address is required';
    
    // Quick physical numeric constraints check for Hungarian zip lengths (4 digits)
    final hufZipRegex = RegExp(r'^\d{4}$');
    if (!hufZipRegex.hasMatch(zipCode.trim())) {
      return 'Please enter a valid 4-digit zip code';
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
