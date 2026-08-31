class UserProfile {
  final String name;
  final String email;

  UserProfile({required this.name, required this.email});

  Map<String, dynamic> toJson() => {'name': name, 'email': email};

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(name: json['name'] ?? '', email: json['email'] ?? '');
  }
}
