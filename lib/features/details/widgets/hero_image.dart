import 'package:flutter/material.dart';

import 'package:azkomoly_app/core/models/product.dart';
import 'package:azkomoly_app/core/widgets/custom_image.dart';

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
        child: CustomImage(
          source: product.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}