import 'package:flutter/material.dart';
import 'package:flutter_app/features/profile/models/user_profile.dart';

class InfoEditForm extends StatefulWidget {
  final UserProfile? initialProfile;
  final Function(String name, String email, String address) onSaved; // 🟢 Save callback

  const InfoEditForm({super.key, this.initialProfile, required this.onSaved});

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
    // Initialize text inputs with existing user cache on mount
    // final currentProfile = Provider.of<ShopProvider>(context, listen: false).profile;
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
          decoration: const InputDecoration(
            // labelText: 'Név / Name',
            labelText: 'Name',
            labelStyle: TextStyle(color: Colors.black54),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
            labelText: 'E-mail',
            labelStyle: TextStyle(color: Colors.black54),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _addressController,
          style: const TextStyle(color: Colors.black),
          maxLines: 2,
          decoration: const InputDecoration(
            // labelText: 'Szállítási Cím / Address', 
            labelText: 'Address', 
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
            // setState(() => _isEditing = false); // Lock view back up instantly
            // ScaffoldMessenger.of(context).showSnackBar(
            //   // const SnackBar(content: Text('Profil sikeresen mentve! / Profile saved!')),
            //   const SnackBar(content: Text('Profile saved!')),
            // );
          },
          // child: const Text('MENTÉS / SAVE'),
          child: const Text('SAVE'),
        )
      ]
    );
  }

}