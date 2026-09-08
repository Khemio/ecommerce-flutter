
class UserProfile {
  final String firstName;
  final String lastName;
  final String email;
  final String zipCode;
  final String city;
  final String streetAddress;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.zipCode,
    required this.city,
    required this.streetAddress,
  });

  // Compiled full-name helper getter for clean read-only layouts
  String get fullName => "$lastName $firstName".trim();

  // Compiled full-address helper getter for clean read-only layouts
  String get fullAddress => "$zipCode $city, $streetAddress".trim();

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'zipCode': zipCode,
    'city': city,
    'streetAddress': streetAddress,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      zipCode: json['zipCode'] ?? '',
      city: json['city'] ?? '',
      streetAddress: json['streetAddress'] ?? '',
    );
  }
}
