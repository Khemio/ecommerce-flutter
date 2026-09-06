import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';

import 'package:flutter_app/core/models/product.dart';
import 'package:flutter_app/core/providers/shop_provider.dart';
import 'package:flutter_app/core/utils/redirect_router.dart';
import 'package:flutter_app/core/widgets/custom_image.dart';
import 'package:provider/provider.dart';

class PromoCarousel extends StatelessWidget {
  final List<Product> products;
  
  const PromoCarousel({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ShopProvider>(context).layoutConfig;

    if (!config.isPromoCarouselEnabled || config.promoBanners.isEmpty) {
      return const SizedBox.shrink(); 
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: 180.0,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        autoPlayInterval: const Duration(seconds: 4),
      ),
      items: config.promoBanners.map((banner) {
        return GestureDetector(
          onTap: () => RedirectRouter.execute(context, banner.redirectUrl),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).cardColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CustomImage(source: banner.imageUrl),
            ),
          ),
        );
      }).toList(),
    );
  }

}