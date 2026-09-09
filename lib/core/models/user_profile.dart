import 'shipping_address.dart';

class UserProfile {
  final String firstName;
  final String lastName;
  final String email;
  final ShippingAddress address;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.address
  });

  // Compiled full-name helper getter for clean read-only layouts
  String get fullName => "$lastName $firstName".trim();

  // Compiled full-address helper getter for clean read-only layouts
  // String get fullAddress => "$zipCode $city, $streetAddress".trim();
  String get fullAddress => address.fullAddress;
  String get zipCode => address.addressParts.zipCode;
  String get city => address.addressParts.city;
  String get streetAddress => address.addressParts.streetAddress;

  set zipCode(String value) => address.zipCode = value;
  set city(String value) => address.city = value;
  set streetAddress(String value) => address.streetAddress = value;


  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'address': address.toJson(),
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] != null 
          ? ShippingAddress.fromJson(json['address'])
          : ShippingAddress.fromJson(json), // Fallback support for older, flat caches
    );
  }
}
