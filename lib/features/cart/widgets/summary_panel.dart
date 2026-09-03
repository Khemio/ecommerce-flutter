import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_app/app_localizations.dart';
import 'package:flutter_app/core/providers/shop_provider.dart';

class SummaryPanel extends StatelessWidget {
  const SummaryPanel({
    super.key,
    required this._isCheckingOut, 
    required this._totalPrice, 
    required this._onCheckoutPressed, 
  });

  final bool _isCheckingOut;
  final double _totalPrice;
  final Function(ShopProvider) _onCheckoutPressed;

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
                  //TODO: Create and apply extention for price formatting
                  '${_totalPrice.toStringAsFixed(2)} HUF', 
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
              onPressed: _isCheckingOut 
                ? null 
                : () => _onCheckoutPressed(shopProvider),
              child: _isCheckingOut
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