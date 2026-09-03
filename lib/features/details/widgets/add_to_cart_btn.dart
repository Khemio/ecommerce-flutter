import 'package:flutter/material.dart';

import 'package:flutter_app/app_localizations.dart';
import 'package:flutter_app/core/models/product.dart';

class AddToCartBtn extends StatelessWidget {
  final int _selectedQuantity;
  final String appLanguage;
  final Product product;
  final Function(Product, int) onPressed;

  const AddToCartBtn({
    super.key, 
    required this._selectedQuantity,
    required this.appLanguage, 
    required this.product, 
    required this.onPressed, 
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: Theme.of(context).elevatedButtonTheme.style,
            onPressed: () {
              onPressed(product, _selectedQuantity);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  // TODO: Add translation and  evaluate if we need to add 's' at the end 
                  content: Text('$_selectedQuantity ${product.title + (_selectedQuantity > 1 ? 's' : '')} added to bag!'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Text(
              AppLocalizations.translate('add_to_bag', appLanguage),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
            ),
          ),
        ),
      );
  }

}