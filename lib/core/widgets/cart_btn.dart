import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_app/core/providers/shop_provider.dart';
import 'package:flutter_app/features/cart/cart.dart' show CartScreen;

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Consumer<ShopProvider>(
      child: IconButton(
        icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black, size: 28),
        onPressed: () => Navigator.push(
          context, 
          MaterialPageRoute(builder: (_) => const CartScreen())
        ),
      ),
      builder: (context, shopProvider, staticCartIcon) {
        return Stack(
          alignment: Alignment.center,
          children: [
            staticCartIcon!,
            if (shopProvider.cart.isNotEmpty)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                  constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                  child: Text(
                    '${shopProvider.cart.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}