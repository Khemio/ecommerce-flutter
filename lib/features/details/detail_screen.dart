import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_app/core/models/product.dart';
import 'package:flutter_app/core/providers/shop_provider.dart';

import 'details.dart' hide DetailScreen;

class DetailScreen extends StatefulWidget {
  final Product product;

  const DetailScreen({super.key, required this.product});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}
class _DetailScreenState extends State<DetailScreen> {
  int _selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        //? Is is product type what we should be displaying?
        title: Text(widget.product.productType.toUpperCase()),
        actions: [DetailCartButton(), const SizedBox(width: 8),],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailHeroImage(product: widget.product),
            DetailBody(
              appLanguage: shopProvider.appLanguage,
              product: widget.product,
              onQuantityChanged: (newQuant) {
                setState(() => _selectedQuantity = newQuant);
              }
            ),
          ],
        ),
      ),
      
      
      bottomNavigationBar: AddToCartBtn(
        selectedQuantity: _selectedQuantity,
        appLanguage: shopProvider.appLanguage,
        product: widget.product, 
        onPressed: shopProvider.addToCart, 
      )
    );
  }
}
