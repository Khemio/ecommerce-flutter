import 'package:flutter/material.dart';
import 'package:azkomoly_app/app_localizations.dart';

import 'package:azkomoly_app/core/models/product.dart';
import 'package:azkomoly_app/core/providers/shop_provider.dart';
import 'package:azkomoly_app/core/utils/num_extentions.dart';
import 'package:azkomoly_app/core/widgets/custom_image.dart';
import 'package:azkomoly_app/features/details/details.dart' show DetailScreen;
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
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: Hero(
                          tag: 'box_${product.id}', 
                          child: CustomImage(
                            source: product.imageUrl,
                            fit: BoxFit.cover,
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
                          Text(
                            product.price.toPrice(currency: 'HUF'), 
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                if (!product.isAvailable) ...[
                  // Gray transparent overlay pane
                  Positioned.fill(
                    child: Container(color: Colors.white.withValues(alpha: 0.5)),
                  ),
                  // Sharp Neo-Brutalism Sold Out Indicator Tag Badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        border: Border.all(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        AppLocalizations.translate('sold_out', appLanguage),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ],
              
            ),
          ),
        );
      },
    );
  }

}