import 'package:azkomoly_app/core/models/banner_items.dart';
import 'package:azkomoly_app/features/home/models/social_review_data.dart';

class AppLayoutConfig {
  final bool isPromoCarouselEnabled;
  final bool isSocialCarouselEnabled;
  final List<PromoBanner> promoBanners;
  final List<SocialReviewItem> socialReviews;

  AppLayoutConfig({
    required this.isPromoCarouselEnabled,
    required this.isSocialCarouselEnabled,
    required this.promoBanners,
    required this.socialReviews,
  });

  AppLayoutConfig.defaultConfig({required this.promoBanners})
    : isPromoCarouselEnabled = true,
      isSocialCarouselEnabled = true,
      socialReviews = demoReviews;

  factory AppLayoutConfig.fromJson(Map<String, dynamic> json) {
    return AppLayoutConfig(
      isPromoCarouselEnabled: json['isPromoCarouselEnabled'] ?? true,
      isSocialCarouselEnabled: json['isSocialCarouselEnabled'] ?? true,
      promoBanners: (json['promoBanners'] as List? ?? [])
          .map((b) => PromoBanner.fromJson(b))
          .toList(),
      socialReviews: (json['socialReviews'] as List? ?? [])
          .map((r) => SocialReviewItem.fromJson(r))
          .toList(),
    );
  }
}
