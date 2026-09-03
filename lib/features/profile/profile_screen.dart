// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_app/features/profile/widgets/info_display_view.dart';
import 'package:flutter_app/features/profile/widgets/info_edit_form.dart';
import 'package:flutter_app/features/profile/widgets/language_selector_card.dart';
import 'package:provider/provider.dart';
import '../../app_localizations.dart';
import '../../core/providers/shop_provider.dart';
import 'order_history_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // Initialize text inputs with existing user cache on mount
    final currentProfile = Provider.of<ShopProvider>(context, listen: false).profile;
    if (currentProfile != null) {
      _nameController.text = currentProfile.name;
      _emailController.text = currentProfile.email;
      _addressController.text = currentProfile.shippingAddress;
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
    final shopProvider = Provider.of<ShopProvider>(context);
    final lang = shopProvider.appLanguage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PROFILE'),
        actions: [
          // 🟢 Toggle Edit Action Icon
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit_note, color: Colors.black, size: 28),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
                // If canceling, restore previous cached text entries
                if (!_isEditing && shopProvider.profile != null) {
                  _nameController.text = shopProvider.profile!.name;
                  _emailController.text = shopProvider.profile!.email;
                  _addressController.text = shopProvider.profile!.shippingAddress;
                }
              });
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LanguageSelectorCard(),
            // 1. Personal Information Input Card (Neo-Brutalism Wrapper)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          //   // 'SZEMÉLYES ADATOK / PROFILE INFO',
                          'PROFILE INFO',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
                        ),
                        if (!_isEditing)
                          const Icon(Icons.lock_outline, size: 16, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 20),

                    if (!_isEditing)
                      InfoDisplayView(profile: shopProvider.profile)
                    else 
                      InfoEditForm(
                        onSaved: (name, email, address) {
                          shopProvider.saveProfile(name, email, address);
                          setState(() => _isEditing = false); // Lock view back up instantly
                          ScaffoldMessenger.of(context).showSnackBar(
                            // const SnackBar(content: Text('Profil sikeresen mentve! / Profile saved!')),
                            const SnackBar(content: Text('Profile saved!')),
                          );
                        }
                      )
                    ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 2. Navigation Shortcut Card targeting past orders
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                leading: const Icon(Icons.history_toggle_off, color: Colors.black, size: 28),
                title: const Text('ORDER HISTORY', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${shopProvider.orderHistory.length} previous order${shopProvider.orderHistory.length == 1 ? '' : 's'}'),
                // title: const Text('RENDELÉSI ELŐZMÉNYEK', style: TextStyle(fontWeight: FontWeight.bold)),
                // subtitle: Text('${shopProvider.orderHistory.length} db korábbi rendelés'),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
