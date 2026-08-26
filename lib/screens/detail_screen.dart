// lib/screens/detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_app/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product.dart';
import '../providers/shop_provider.dart';

// TODO: Add quantity selection
class DetailScreen extends StatefulWidget {
  final Product product;

  const DetailScreen({super.key, required this.product});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

// TODO: remove sizing
class _DetailScreenState extends State<DetailScreen> {
  String _selectedSize = 'M'; 
  final List<String> _sizes = ['M', 'L', 'XL'];

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.productType.toUpperCase()),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 350,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: widget.product.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 80),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title,
                    // style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.product.price} HUF',
                    // style: const TextStyle(fontSize: 20, color: AppTheme.successColor, fontWeight: FontWeight.w600),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  // const SizedBox(height: 16),

                  // Text(
                  //   'SELECT BOX SIZE',
                  //   // style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                  //   style: Theme.of(context).textTheme.titleMedium,
                  // ),
                  // const SizedBox(height: 10),
                  // Row(
                  //   children: _sizes.map((size) {
                  //     final isSelected = _selectedSize == size;
                  //     return GestureDetector(
                  //       onTap: () {
                  //         setState(() {
                  //           _selectedSize = size;
                  //         });
                  //       },
                  //       child: Container(
                  //         margin: const EdgeInsets.only(right: 12),
                  //         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  //         decoration: BoxDecoration(
                  //           color: isSelected 
                  //               ? Theme.of(context).elevatedButtonTheme.style?.backgroundColor?.resolve({}) 
                  //               : Theme.of(context).cardColor,
                  //           borderRadius: BorderRadius.circular(8),
                  //         ),
                  //         child: Text(
                  //           size,
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             color: isSelected ? Colors.white : Colors.grey[400],
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   }).toList(),
                  // ),
                  const SizedBox(height: 24),

                  Text(
                    'DESCRIPTION',
                    // style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description.isEmpty 
                        ? "This exclusive mystery box features highly curated street clothing and rare items matching premium drops." 
                        : widget.product.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: Theme.of(context).elevatedButtonTheme.style,
            onPressed: () {
              // Trigger Provider logic instantly
              shopProvider.addToCart(widget.product, _selectedSize);
              
              //? Might want to change cnack bar color
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${widget.product.title} ($_selectedSize) added to bag!'),
                  duration: const Duration(seconds: 2),
                  // backgroundColor: AppTheme.brandViolet
                  // backgroundColor: AppTheme.backgroundWhite
                ),
              );
            },
            child: const Text('ADD MYSTERY BOX TO BAG', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
