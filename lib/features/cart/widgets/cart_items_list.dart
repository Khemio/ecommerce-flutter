import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app_localizations.dart';
import 'package:flutter_app/core/providers/shop_provider.dart';
import 'package:flutter_app/core/widgets/quantity_selector.dart';
import 'package:flutter_app/features/cart/widgets/cart_item_tile.dart';
import 'package:provider/provider.dart';

class CartItemsList extends StatelessWidget {
  const CartItemsList({
    super.key, 
    required this.totalPrice, 
  });

  // final ShopProvider shopProvider;
  final double totalPrice;

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context); 
    
    return Expanded(
          child: ListView.builder(
            itemCount: shopProvider.cart.length,
            itemBuilder: (context, index) {
              final item = shopProvider.cart[index];
              // final product = item.product;

              // Cart Item
              return CartItemTile(
                item: item,
                onDelete: shopProvider.removeFromCart, 
                onQuantityChange: shopProvider.updateQuantity,
              );
              // return Card(
              //   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              //   child: ListTile(
              //     leading: SizedBox(
              //       width: 50,
              //       height: 50,
              //       child: CachedNetworkImage(
              //         imageUrl: product.imageUrl,
              //         fit: BoxFit.cover,
              //         errorWidget: (c, u, e) => const Icon(Icons.broken_image),
              //       ),
              //     ),
              //     title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
              //     subtitle: Text('${((double.tryParse(product.price) ?? 0.0) * item.quantity).toStringAsFixed(2)} HUF'),
              //     trailing: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         QuantitySelector(
              //           value: item.quantity,
              //           min: 1,
              //           max: 99,
              //           compact: true,
              //           onChanged: (newQty) {
              //             shopProvider.updateQuantity(product.variantId, newQty);
              //           },
              //         ),

              //         IconButton(
              //           icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              //           onPressed: () {
              //             shopProvider.removeFromCart(product.variantId);
              //           },
              //         ),
              //       ],
              //     )
              //   ),
              // );
            },
          ),
        // ),
        );
  }

}