import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../app_localizations.dart';
import '../models/product.dart';
import '../providers/shop_provider.dart';
import 'widgets/quantity_selector.dart';

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
        title: Text(widget.product.productType.toUpperCase()),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 350,
              width: double.infinity,
              child: Hero(
                tag: 'box_${widget.product.id}', 
                child: CachedNetworkImage(
                  imageUrl: widget.product.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 80),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.product.price} HUF',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),

                  Text(
                    // 'HOW MUCH DO YOU WANT?',
                    AppLocalizations.translate('how_much', shopProvider.appLanguage),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),

                  QuantitySelector(
                    value: _selectedQuantity,
                    onChanged: (q) => setState(() => _selectedQuantity = q),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    // 'DESCRIPTION',
                    AppLocalizations.translate('description', shopProvider.appLanguage),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),

                  Text(
                    widget.product.description.isEmpty 
                        // ? "This exclusive mystery box features highly curated street clothing and rare items matching premium drops." 
                        ? AppLocalizations.translate('default_description', shopProvider.appLanguage)
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
              // shopProvider.addToCart(widget.product, _selectedSize);
              shopProvider.addToCart(widget.product, _selectedQuantity);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  // content: Text('${widget.product.title} ($_selectedSize) added to bag!'),
                  // TODO: Add this to translation map
                  content: Text('$_selectedQuantity ${widget.product.title + (_selectedQuantity > 1 ? 's' : '')} added to bag!'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Text(
              // 'ADD MYSTERY BOX TO BAG', 
              AppLocalizations.translate('add_to_bag', shopProvider.appLanguage),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
            ),
          ),
        ),
      ),
    );
  }
}
