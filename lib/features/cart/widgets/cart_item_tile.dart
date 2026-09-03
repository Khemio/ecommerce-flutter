import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/core/widgets/quantity_selector.dart';
import 'package:flutter_app/features/profile/models/order_history.dart';

class CartItemTile extends StatelessWidget{
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
          child: CachedNetworkImage(
            imageUrl: product.imageUrl,
            fit: BoxFit.cover,
            errorWidget: (c, u, e) => const Icon(Icons.broken_image),
          ),
        ),
        title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text('${((double.tryParse(product.price) ?? 0.0) * item.quantity).toStringAsFixed(2)} HUF'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            QuantitySelector(
              value: item.quantity,
              min: 1,
              max: 99,
              compact: true,
              onChanged: (newQty) => onQuantityChange(product.variantId, newQty),
            ),

            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => onDelete(product.variantId),
            ),
          ],
        )
      ),
    );
  }

}