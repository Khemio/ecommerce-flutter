import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomImage extends StatelessWidget {
  final String source;
  final double? width;
  final double? height;
  final BoxFit fit;

  const CustomImage({
    super.key,
    required this.source,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    // 🟢 Inspect the string structure to determine the load path engine
    final bool isNetworkImage = source.startsWith('http://') || source.startsWith('https://');

    if (isNetworkImage) {
      return CachedNetworkImage(
        imageUrl: source,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (context, url, error) => _buildErrorPlaceholder(),
      );
    } else {
      // Handles local physical project files (e.g., 'assets/images/logo.png')
      return Image.asset(
        source,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
      );
    }
  }

  // Unified fallback layout handler matching your brand's style
  Widget _buildErrorPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFE8DDFF), // Soft purple brand tint
      child: const Center(
        child: Icon(Icons.broken_image_outlined, color: Color(0xFF5A24B3), size: 28),
      ),
    );
  }
}