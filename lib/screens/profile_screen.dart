// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_localizations.dart';
import '../core/providers/shop_provider.dart';
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
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF0D0D0D), width: 2.5), // Thick Neo-Brutalism border
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.translate('lang_label', shopProvider.appLanguage),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
                  ),
                  DropdownButton<String>(
                    value: shopProvider.appLanguage,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    underline: const SizedBox(), // Removes the default ugly line
                    dropdownColor: Colors.white,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        shopProvider.updateLanguage(newValue);
                      }
                    },
                    items: const [
                      DropdownMenuItem(value: 'hu', child: Text('Magyar (HU)')),
                      DropdownMenuItem(value: 'en', child: Text('English (EN)')),
                    ],
                  ),
                ],
              ),
            ),
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

                    // --- 🟢 TOGGLABLE CONDITIONAL VIEW ENGINE ---
                    if (!_isEditing) ...[
                      // READ-ONLY STATIC VIEW DISPLAY
                      _buildInfoRow('Név / Name', _nameController.text.isEmpty ? '-' : _nameController.text),
                      const SizedBox(height: 16),
                      _buildInfoRow('E-mail', _emailController.text.isEmpty ? '-' : _emailController.text),
                      const SizedBox(height: 16),
                      _buildInfoRow('Szállítási Cím / Address', _addressController.text.isEmpty ? '-' : _addressController.text),
                    ] else ...[
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
                          shopProvider.saveProfile(
                            _nameController.text, 
                            _emailController.text, 
                            _addressController.text
                          );
                          setState(() => _isEditing = false); // Lock view back up instantly
                          ScaffoldMessenger.of(context).showSnackBar(
                            // const SnackBar(content: Text('Profil sikeresen mentve! / Profile saved!')),
                            const SnackBar(content: Text('Profile saved!')),
                          );
                        },
                        // child: const Text('MENTÉS / SAVE'),
                        child: const Text('SAVE'),
                      ),
                    ],
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

  // Mini structural layout helper for read-only typography aesthetics
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
