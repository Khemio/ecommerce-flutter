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

final List<SocialReviewItem> demoReviews = [
    SocialReviewItem(
      thumbnailUrl: 'images/review1.webp',
      videoUrl: 'https://www.instagram.com/reel/DbOVwukMheu/?utm_source=ig_web_button_share_sheet&igsh=MzRlODBiNWFlZA==',
      isTikTok: false,
    ),
    SocialReviewItem(
      thumbnailUrl: 'images/review2.webp',
      videoUrl: 'https://www.instagram.com/reel/DbAyYwQO_z9/?utm_source=ig_web_copy_link&igsh=MzRlODBiNWFlZA==',
      isTikTok: false,
    ),
    SocialReviewItem(
      thumbnailUrl: 'images/review3.webp',
      videoUrl: 'https://www.instagram.com/reel/DanS3tFsao4/?utm_source=ig_web_copy_link&igsh=MzRlODBiNWFlZA==',
      isTikTok: false,
    ),
    SocialReviewItem(
      thumbnailUrl: 'images/review4.webp',
      videoUrl: 'https://www.instagram.com/reel/DaLM-yzsLz_/?utm_source=ig_web_copy_link&igsh=MzRlODBiNWFlZA==',
      isTikTok: false,
    ),
    SocialReviewItem(
      thumbnailUrl: 'images/review5.webp',
      videoUrl: 'https://www.instagram.com/reel/DaFsFjgKlCR/?utm_source=ig_web_copy_link&igsh=MzRlODBiNWFlZA==',
      isTikTok: false,
    ),
    SocialReviewItem(
      thumbnailUrl: 'images/review6.webp',
      videoUrl: 'https://www.tiktok.com/@azkomoly.hu/video/7670098419981110550?is_from_webapp=1&sender_device=pc&web_id=7644208246575662593',
      isTikTok: true,
    ),
];