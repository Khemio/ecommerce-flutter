import 'package:flutter/material.dart';
import 'package:flutter_app/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:flutter_app/core/providers/shop_provider.dart';

class ClearCartBtn extends StatelessWidget {
  const ClearCartBtn({super.key});

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);

    return IconButton(
      icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent, size: 26),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                AppLocalizations.translate('clear_cart_title', shopProvider.appLanguage),
                style: TextStyle(fontWeight: FontWeight.bold)
              ),
              content: Text(
                AppLocalizations.translate('clear_cart_body', shopProvider.appLanguage),
              ),
              actions: [
                TextButton(
                  child: Text(
                    AppLocalizations.translate('clear_cart_cancel', shopProvider.appLanguage),
                    style: TextStyle(color: Colors.grey)
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text(
                    AppLocalizations.translate('clear_cart_confirm', shopProvider.appLanguage),
                    style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)
                  ),
                  onPressed: () {
                    shopProvider.clearCart();
                    Navigator.of(context).pop();
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.translate('cart_cleared_toast', shopProvider.appLanguage),)
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

