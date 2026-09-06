class PromoBanner {
  final String imageUrl;
  final String? redirectUrl;

  PromoBanner({required this.imageUrl, this.redirectUrl});

  factory PromoBanner.fromJson(Map<String, dynamic> json) {
    return PromoBanner(
      imageUrl: json['imageUrl'] ?? '',
      redirectUrl: json['redirectUrl'],
    );
  }
}

class SocialReviewItem {
  final String thumbnailUrl;
  final String videoUrl;
  final bool isTikTok; // True = TikTok icon badge, False = Instagram icon badge

  SocialReviewItem({
    required String thumbnailUrl,
    required this.videoUrl,
    required this.isTikTok,
  }) : thumbnailUrl = _normalizeUrl(thumbnailUrl);

  static String _normalizeUrl(String url) {
    if (url.startsWith('assets/')) {
      return url;
    }
    if (url.startsWith('images/')) {
      return 'assets/$url';
    }
    // Fallback if only the file name was provided (e.g., 'review1.webp')
    return 'assets/images/$url'; 
  }

  factory SocialReviewItem.fromJson(Map<String, dynamic> json) {
    return SocialReviewItem(
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      isTikTok: json['isTikTok'] ?? false,
    );
  }

}