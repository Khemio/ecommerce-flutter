import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:azkomoly_app/app_localizations.dart';
import 'package:azkomoly_app/core/providers/shop_provider.dart';

import 'order_history_screen.dart';
import 'widgets/info_display_view.dart';
import 'widgets/info_edit_form.dart';
import 'widgets/language_selector_card.dart';
import 'widgets/profile_social_btns.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _zipController = TextEditingController();
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final currentProfile = Provider.of<ShopProvider>(context, listen: false).profile;
    if (currentProfile != null) {
      _firstNameController.text = currentProfile.firstName;
      _lastNameController.text = currentProfile.lastName;
      _emailController.text = currentProfile.email;
      _zipController.text = currentProfile.zipCode;
      _cityController.text = currentProfile.city;
      _streetController.text = currentProfile.streetAddress;
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
    final shopProvider = Provider.of<ShopProvider>(context);

    String transactionSubtitlePattern = AppLocalizations.translate('orders_count_suffix', shopProvider.appLanguage);
    String displaySubtitle = transactionSubtitlePattern.replaceAll('{count}', '${shopProvider.orderHistory.length}');

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.translate('profile_header', shopProvider.appLanguage),),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit_note, color: Colors.black, size: 28),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
                // If canceling, restore previous cached text entries
                if (!_isEditing && shopProvider.profile != null) {
                  debugPrint(shopProvider.profile!.fullName);
                  _firstNameController.text = shopProvider.profile!.firstName;
                  _lastNameController.text = shopProvider.profile!.lastName;
                  _emailController.text = shopProvider.profile!.email;
                  _zipController.text = shopProvider.profile!.zipCode;
                  _cityController.text = shopProvider.profile!.city;
                  _streetController.text = shopProvider.profile!.streetAddress;
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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.translate('profile_info_section', shopProvider.appLanguage),
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
                        ),
                        if (!_isEditing)
                          const Icon(Icons.lock_outline, size: 16, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 20),

                    if (!_isEditing)
                      InfoDisplayView(
                        appLanguage: shopProvider.appLanguage,
                        profile: shopProvider.profile
                      )
                    else 
                      InfoEditForm(
                        appLanguage: shopProvider.appLanguage,
                        onSaved: ({
                          required firstName, 
                          required lastName, 
                          required email, 
                          required zipCode, 
                          required city, 
                          required streetAddress
                        }) {
                          shopProvider.saveProfile(
                            firstName: firstName,
                            lastName: lastName,
                            email: email,
                            zipCode: zipCode,
                            city: city,
                            streetAddress: streetAddress,
                          );
                          setState(() => _isEditing = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.translate('profile_saved_toast', shopProvider.appLanguage), 
                              )
                            ),
                          );
                        }
                      )
                    ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                leading: const Icon(Icons.history_toggle_off, color: Colors.black, size: 28),                // title: const Text('ORDER HISTORY', style: TextStyle(fontWeight: FontWeight.bold)),
                title: Text(
                  AppLocalizations.translate('order_history_title', shopProvider.appLanguage), 
                  style: TextStyle(fontWeight: FontWeight.bold)
                ),
                subtitle: Text(displaySubtitle),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            ProfileSocialButtons(appLanguage: shopProvider.appLanguage), 
          ],
        ),
      ),
    );
  }
}
