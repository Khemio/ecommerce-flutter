class UserProfile {
  final String name;
  final String email;
  final String shippingAddress;

  UserProfile({
    required this.name, 
    required this.email, 
    required this.shippingAddress,
  });

  Map<String, dynamic> toJson() => {
    'name': name, 
    'email': email,
    'shippingAddress': shippingAddress,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? '', 
      email: json['email'] ?? '',
      shippingAddress: json['shippingAddress'] ?? '',
    );
  }
}
