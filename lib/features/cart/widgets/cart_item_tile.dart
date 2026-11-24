import 'package:flutter/material.dart';
import 'package:azkomoly_app/core/utils/num_extentions.dart';
import 'package:azkomoly_app/core/widgets/custom_image.dart';

import 'package:azkomoly_app/core/widgets/quantity_selector.dart';
import 'package:azkomoly_app/features/profile/models/order_history.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;
  final Function(String) onDelete;
  final Function(String, int) onQuantityChange;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onQuantityChange,
  });

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: SizedBox(
          width: 50,
          height: 50,
          child: CustomImage(source: product.imageUrl, fit: BoxFit.cover),
        ),
        title: Text(
          product.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          (product.price * item.quantity).toPrice(currency: 'HUF'),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            QuantitySelector(
              value: item.quantity,
              min: 1,
              max: 99,
              compact: true,
              onChanged: (newQty) =>
                  onQuantityChange(product.variantId, newQty),
            ),

            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => onDelete(product.variantId),
            ),
          ],
        ),
      ),
    );
  }
}
