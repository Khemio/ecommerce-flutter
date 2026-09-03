import 'package:flutter/material.dart';
import 'package:flutter_app/core/providers/shop_provider.dart';
import 'package:flutter_app/features/cart/widgets/cart_item_tile.dart';
import 'package:provider/provider.dart';

class CartItemsList extends StatelessWidget {
  const CartItemsList({
    super.key, 
    required this.totalPrice, 
  });
  
  final double totalPrice;

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context); 
    
    return Expanded(
          child: ListView.builder(
            itemCount: shopProvider.cart.length,
            itemBuilder: (context, index) {
              final item = shopProvider.cart[index];

              // Cart Item
              return CartItemTile(
                item: item,
                onDelete: shopProvider.removeFromCart, 
                onQuantityChange: shopProvider.updateQuantity,
              );
            },
          ),
        // ),
        );
  }

}