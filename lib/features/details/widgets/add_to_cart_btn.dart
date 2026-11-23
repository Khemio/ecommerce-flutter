import 'package:flutter/material.dart';

import 'package:azkomoly_app/app_localizations.dart';
import 'package:azkomoly_app/core/models/product.dart';

class AddToCartBtn extends StatelessWidget {
  final int selectedQuantity;
  final String appLanguage;
  final Product product;
  final Function(Product, int) onPressed;

  const AddToCartBtn({
    super.key,
    required this.selectedQuantity,
    required this.appLanguage,
    required this.product,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool canPurchase = product.isAvailable;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: Theme.of(context).elevatedButtonTheme.style,
          onPressed: product.isAvailable && product.variantId.isNotEmpty
              ? () {
                  onPressed(product, selectedQuantity);

                  final String basePattern = AppLocalizations.translate(
                    'added_to_bag_msg',
                    appLanguage,
                  );
                  final String snackBarMessage = basePattern
                      .replaceAll('{quantity}', '$selectedQuantity')
                      .replaceAll('{title}', product.title);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(snackBarMessage),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              : null,
          child: Text(
            canPurchase
                ? AppLocalizations.translate('add_to_bag', appLanguage)
                : AppLocalizations.translate('sold_out', appLanguage),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
