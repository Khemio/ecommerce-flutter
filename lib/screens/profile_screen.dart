// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shop_provider.dart';
import 'order_history_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize text inputs with existing user cache on mount
    final currentProfile = Provider.of<ShopProvider>(context, listen: false).profile;
    if (currentProfile != null) {
      _nameController.text = currentProfile.name;
      _emailController.text = currentProfile.email;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PROFIL'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Personal Information Input Card (Neo-Brutalism Wrapper)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SZEMÉLYES ADATOK / PROFILE INFO',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        labelText: 'Név / Name',
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
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5A24B3),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        shopProvider.saveProfile(_nameController.text, _emailController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profil sikeresen mentve! / Profile saved!')),
                        );
                      },
                      child: const Text('MENTÉS / SAVE'),
                    ),
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
                title: const Text('RENDELÉSI ELŐZMÉNYEK', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${shopProvider.orderHistory.length} db korábbi rendelés'),
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
