import 'package:flutter/material.dart';
import 'package:flutter_app/features/profile/models/user_profile.dart';

class InfoDisplayView extends StatelessWidget {
  final UserProfile? profile;
  
  const InfoDisplayView({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    final name = profile?.name.isEmpty ?? true ? '-' : profile!.name;
    final email = profile?.email.isEmpty ?? true ? '-' : profile!.email;
    final address = profile?.shippingAddress.isEmpty ?? true ? '-' : profile!.shippingAddress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Név / Name', name),
        const SizedBox(height: 16),
        _buildInfoRow('E-mail', email),
        const SizedBox(height: 16),
        _buildInfoRow('Szállítási Cím / Address', address),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600)),
        const Divider(color: Colors.black12, height: 16),
      ],
    );
  }
}