// lib/screens/order_history_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shop_provider.dart';
// import '../app_localizations.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final orders = shopProvider.orderHistory;

    return Scaffold(
      appBar: AppBar(
        // title: Text(AppLocalizations.translate('Rendelési Előzmények')), // Add dictionary keys as needed
        title: Text('Order History', style: Theme.of(context).textTheme.headlineLarge,), // Add dictionary keys as needed
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text(
                // 'Nincsenek korábbi rendelések.\nNo order history found.',
                'No order history found.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order Metadata Header Strip
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order.orderId,
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            Text(
                              order.totalAmount,
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          ],
                        ),
                        const Divider(height: 24, color: Colors.black26),
                        
                        // Purchased Item Rows
                        ...order.items.map((item) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item.product.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.black87),
                                  ),
                                ),
                                Text(
                                  'x${item.quantity}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
