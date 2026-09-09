import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:azkomoly_app/app_localizations.dart';
import 'package:azkomoly_app/core/providers/shop_provider.dart';

class LanguageSelectorCard extends StatelessWidget{
  const LanguageSelectorCard({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentLang = context.select<ShopProvider, String>((p) => p.appLanguage);
    
    return Container(
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
          AppLocalizations.translate('lang_label', currentLang),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
        ),
        DropdownButton<String>(
          value: currentLang,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          underline: const SizedBox(), // Removes the default ugly line
          dropdownColor: Colors.white,
          onChanged: (String? newValue) {
            if (newValue != null) {
              context.read<ShopProvider>().updateLanguage(newValue);
            }
          },
          items: const [
            DropdownMenuItem(value: 'hu', child: Text('Magyar (HU)')),
            DropdownMenuItem(value: 'en', child: Text('English (EN)')),
          ],
        ),
      ],
    ),
  );
}

}