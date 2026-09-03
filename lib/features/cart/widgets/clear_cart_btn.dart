import 'package:flutter/material.dart';
import 'package:flutter_app/core/providers/shop_provider.dart';
import 'package:provider/provider.dart';

class ClearCartBtn extends StatelessWidget {
  const ClearCartBtn({super.key});

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);

    return IconButton(
            icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent, size: 26),
            onPressed: () {
              // 💡 Surface a safety confirmation dialog before wiping memory caches
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  //TODO: Add translations
                  return AlertDialog(
                    // title: const Text('Kosár ürítése?', style: TextStyle(fontWeight: FontWeight.bold)),
                    // content: const Text('Biztosan törölni szeretnéd az összes elemet a kosárból?'),
                    title: const Text('Clear the basket?', style: TextStyle(fontWeight: FontWeight.bold)),
                    content: const Text('Are you sure you want to delete all items from the cart?'),
                    actions: [
                      TextButton(
                        // child: const Text('Mégse / Cancel', style: TextStyle(color: Colors.grey)),
                        child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                        onPressed: () => Navigator.of(context).pop(), // Closes the alert box safely
                      ),
                      TextButton(
                        // child: const Text('Törlés / Clear', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                        child: const Text('Clear', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          shopProvider.clearCart(); // Triggers your built-in provider wipe code
                          Navigator.of(context).pop(); // Closes the alert dialog box frame
                          
                          // Notify the customer with a quick confirmation toast
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cart cleared!')),
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

