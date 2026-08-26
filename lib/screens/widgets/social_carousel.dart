// lib/screens/social_carousel.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';

class SocialReviewItem {
  final String thumbnailUrl;
  final String videoUrl;
  final bool isTikTok; // True = TikTok icon badge, False = Instagram icon badge

  SocialReviewItem({required this.thumbnailUrl, required this.videoUrl, required this.isTikTok});
}

// TODO: change icons on items to actual platform logos
class SocialCarousel extends StatelessWidget {
  final List<SocialReviewItem> reviews = [
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

  SocialCarousel({super.key});

  Future<void> _launchSocialVideo(String urlString) async {
    final Uri url = Uri.parse(urlString);
    // mode: LaunchMode.externalApplication forces Android to open it directly in the 
    // official TikTok or Instagram app if installed, instead of a generic web browser!
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            '#AZKOMOLY · SHARE IT',
            // style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.5),
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        CarouselSlider.builder(
          itemCount: reviews.length,
          options: CarouselOptions(
            height: 220.0,
            autoPlay: true,
            viewportFraction: 0.35,
            padEnds: false,
            enableInfiniteScroll: true,
            autoPlayInterval: const Duration(seconds: 3),
          ),
          itemBuilder: (context, index, realIndex) {
            final item = reviews[index];
            return GestureDetector(
              onTap: () => _launchSocialVideo(item.videoUrl),
              child: Container(
                  margin: const EdgeInsets.only(right: 12, bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).cardColor,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        // child: CachedNetworkImage(
                        //   imageUrl: imageUrl,
                        //   fit: BoxFit.cover,
                        //   errorWidget: (c, u, e) => const Icon(Icons.broken_image, size: 50),
                        // ),
                        child: Image.asset(
                          item.thumbnailUrl,
                          height: double.infinity,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                          child: Icon(
                            item.isTikTok ? Icons.play_circle_fill : Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ]
                  ),
                ),
            );
            
          }),
      ],
    );
  }
}
