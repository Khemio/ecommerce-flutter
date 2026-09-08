import 'package:flutter/material.dart';
import 'package:azkomoly_app/app_localizations.dart';
import 'package:azkomoly_app/core/models/user_profile.dart';

class InfoEditForm extends StatefulWidget {
  final UserProfile? initialProfile;
  final String appLanguage;
  final Function({
    required String firstName,
    required String lastName,
    required String email,
    required String zipCode,
    required String city,
    required String streetAddress,
  }) onSaved;


  const InfoEditForm({super.key, 
    this.initialProfile, 
    required this.appLanguage,
    required this.onSaved
  });

  @override
  State<InfoEditForm> createState() => _InfoEditFormState();
}

class _InfoEditFormState extends State<InfoEditForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _zipController = TextEditingController();
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.initialProfile != null) {
      _firstNameController.text = widget.initialProfile!.firstName;
      _lastNameController.text = widget.initialProfile!.lastName;
      _emailController.text = widget.initialProfile!.email;
      _zipController.text = widget.initialProfile!.zipCode;
      _cityController.text = widget.initialProfile!.city;
      _streetController.text = widget.initialProfile!.streetAddress;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _zipController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _lastNameController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: AppLocalizations.translate('field_name_last', widget.appLanguage),
                  labelStyle: TextStyle(color: Colors.black54),
                  border: OutlineInputBorder()
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _firstNameController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: AppLocalizations.translate('field_name_first', widget.appLanguage),
                  labelStyle: TextStyle(color: Colors.black54),
                  border: OutlineInputBorder()
                ),
              ),
            ),
          ],
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
        Row(
          children: [
            SizedBox(
              width: 100,
              child: TextField(
                controller: _zipController,
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(

                  labelText: AppLocalizations.translate('field_address_zip', widget.appLanguage),
                  labelStyle: TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _cityController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: AppLocalizations.translate('field_address_city', widget.appLanguage),
                  labelStyle: TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _streetController,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: AppLocalizations.translate('field_address_street', widget.appLanguage),
            labelStyle: TextStyle(color: Colors.black54),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5A24B3),
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            widget.onSaved(
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              email: _emailController.text,
              zipCode: _zipController.text,
              city: _cityController.text,
              streetAddress: _streetController.text,
            );
          },

          child: Text(AppLocalizations.translate('save_btn', widget.appLanguage),),
        )
      ]
    );
  }

}