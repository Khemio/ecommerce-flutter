import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/core/models/product.dart';

class DetailHeroImage extends StatelessWidget {
  final Product product;

  const DetailHeroImage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 350,
      width: double.infinity,
      child: Hero(
        tag: 'box_${product.id}', 
        child: CachedNetworkImage(
          imageUrl: product.imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 80),
        ),
      ),
    );
  }
}