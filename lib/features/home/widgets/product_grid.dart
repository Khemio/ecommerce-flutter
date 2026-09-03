import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_app/app_theme.dart';
import 'package:flutter_app/app_localizations.dart';
import 'package:flutter_app/core/models/product.dart';
import 'package:flutter_app/core/providers/shop_provider.dart';
import 'package:flutter_app/features/details/details.dart' show DetailScreen;
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
      final List<Product> filteredProducts = context.select<ShopProvider, List<Product>>(
        (provider) => provider.filteredProducts,
      );
      final String appLanguage = context.select<ShopProvider, String>(
        (provider) => provider.appLanguage,
      );

    return GridView.builder(
      shrinkWrap: true,                  // 💡 CRITICAL: Allows Grid to live inside a ListView
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (ctx, i) {
        final product = filteredProducts[i];
        return GestureDetector(
          onTap: () => Navigator.push(
            context, 
            MaterialPageRoute(builder: (_) => DetailScreen(product: product))
          ),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Hero(
                      tag: 'box_${product.id}', 
                      child: CachedNetworkImage(
                        imageUrl: product.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: const Color(0xFFE8DDFF), // Soft neon purple background tint
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.inventory_2_outlined, size: 40, color: AppTheme.brandViolet),
                                const SizedBox(height: 8),
                                Text(
                                    AppLocalizations.translate('box_image', appLanguage),
                                  style: TextStyle(
                                    fontFamily: 'Anton',
                                    color: AppTheme.brandViolet.withValues(alpha: 0.6),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ),
                      ),
                    ),
                  ),
                ),
                // ----------------------------------------
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title, 
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      //TODO: Create and apply extention for price formatting
                      Text('${product.price} HUF', style: Theme.of(context).textTheme.bodyMedium,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}