import 'package:flutter/material.dart';
import 'package:flutter_app/app_localizations.dart';
import 'package:flutter_app/features/profile/models/user_profile.dart';

class InfoDisplayView extends StatelessWidget {
  final UserProfile? profile;
  final String appLanguage;
  
  const InfoDisplayView({super.key, this.profile, required this.appLanguage});

  @override
  Widget build(BuildContext context) {
    final name = profile?.fullName.isEmpty ?? true ? '-' : profile!.fullName;
    final email = profile?.email.isEmpty ?? true ? '-' : profile!.email;
    final address = profile?.fullAddress.isEmpty ?? true ? '-' : profile!.fullAddress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          AppLocalizations.translate('field_name', appLanguage),
          name
        ),
        const SizedBox(height: 16),
        _buildInfoRow(
          AppLocalizations.translate('field_email', appLanguage),
          email
        ),
        const SizedBox(height: 16),
        _buildInfoRow(
          AppLocalizations.translate('field_address', appLanguage),
          address
        ),
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