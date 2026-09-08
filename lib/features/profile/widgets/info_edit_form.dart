import 'package:flutter/material.dart';
import 'package:flutter_app/app_localizations.dart';
import 'package:flutter_app/features/profile/models/user_profile.dart';

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
        // TextField(
        //   controller: _nameController,
        //   style: const TextStyle(color: Colors.black),
        //   decoration: InputDecoration(
        //     labelText: AppLocalizations.translate('field_name', widget.appLanguage),
        //     labelStyle: TextStyle(color: Colors.black54),
        //     border: OutlineInputBorder(),
        //   ),
        // ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _lastNameController,
                style: const TextStyle(color: Colors.black),
                // decoration: const InputDecoration(labelText: 'Vezetéknév / Last Name', border: OutlineInputBorder()),
                decoration: InputDecoration(
                  // labelText: 'Last Name', 
                  labelText: AppLocalizations.translate('filed_name_last', widget.appLanguage),
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
                // decoration: const InputDecoration(labelText: 'Keresztnév / First Name', border: OutlineInputBorder()),
                decoration: InputDecoration(
                  // labelText: 'First Name', 
                  labelText: AppLocalizations.translate('filed_name_first', widget.appLanguage),
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
        // TextField(
        //   controller: _addressController,
        //   style: const TextStyle(color: Colors.black),
        //   maxLines: 2,
        //   decoration: InputDecoration(
        //     labelText: AppLocalizations.translate('field_address', widget.appLanguage),
        //     labelStyle: TextStyle(color: Colors.black54),
        //     border: OutlineInputBorder()),
        // ),
        Row(
          children: [
            SizedBox(
              width: 100,
              child: TextField(
                controller: _zipController,
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.number,
                // decoration: const InputDecoration(labelText: 'Irányítószám / Zip', border: OutlineInputBorder()),
                decoration: const InputDecoration(
                  labelText: 'Zip', 
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
                // decoration: const InputDecoration(labelText: 'Város / City', border: OutlineInputBorder()),
                decoration: const InputDecoration(
                  labelText: 'City', 
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
          // decoration: const InputDecoration(labelText: 'Utca, házszám / Street Address', border: OutlineInputBorder()),
          decoration: const InputDecoration(
            labelText: 'Street Address', 
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