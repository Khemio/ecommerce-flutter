import 'package:flutter/material.dart';
import 'package:flutter_app/app_localizations.dart';
import 'package:flutter_app/features/profile/models/user_profile.dart';

class InfoEditForm extends StatefulWidget {
  final UserProfile? initialProfile;
  final String appLanguage;
  final Function(String name, String email, String address) onSaved;

  const InfoEditForm({super.key, 
    this.initialProfile, 
    required this.appLanguage,
    required this.onSaved
  });

  @override
  State<InfoEditForm> createState() => _InfoEditFormState();
}

class _InfoEditFormState extends State<InfoEditForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.initialProfile != null) {
      _nameController.text = widget.initialProfile!.name;
      _emailController.text = widget.initialProfile!.email;
      _addressController.text = widget.initialProfile!.shippingAddress;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: AppLocalizations.translate('field_name', widget.appLanguage),
            labelStyle: TextStyle(color: Colors.black54),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: AppLocalizations.translate('field_email', widget.appLanguage),
            labelStyle: TextStyle(color: Colors.black54),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _addressController,
          style: const TextStyle(color: Colors.black),
          maxLines: 2,
          decoration: InputDecoration(
            labelText: AppLocalizations.translate('field_address', widget.appLanguage),
            labelStyle: TextStyle(color: Colors.black54),
            border: OutlineInputBorder()),
        ),
        const SizedBox(height: 20),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5A24B3),
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            widget.onSaved(
              _nameController.text, 
              _emailController.text, 
              _addressController.text
            );
          },

          child: Text(AppLocalizations.translate('save_btn', widget.appLanguage),),
        )
      ]
    );
  }

}