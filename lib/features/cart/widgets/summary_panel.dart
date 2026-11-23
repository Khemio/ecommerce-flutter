import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:azkomoly_app/app_localizations.dart';
import 'package:azkomoly_app/core/utils/num_extentions.dart';
import 'package:azkomoly_app/core/providers/shop_provider.dart';

class SummaryPanel extends StatelessWidget {
  const SummaryPanel({
    super.key,
    required this.isCheckingOut, 
    required this.totalPrice, 
    required this.onCheckoutPressed, 
  });

  final bool isCheckingOut;
  final double totalPrice;
  final void Function(ShopProvider) onCheckoutPressed;

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context); 
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.translate('total', shopProvider.appLanguage), 
                  style: Theme.of(context).textTheme.titleMedium
                ),
                Text(
                  totalPrice.toPrice(currency: 'HUF'), 
                  style: Theme.of(context).textTheme.titleMedium
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: isCheckingOut 
                ? null 
                : () => onCheckoutPressed(shopProvider),
              child: isCheckingOut
                  ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    AppLocalizations.translate('checkout', shopProvider.appLanguage),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
            ),
          ],
        ),
      ),
    );
  }

}