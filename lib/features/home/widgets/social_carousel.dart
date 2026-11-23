import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';

import 'package:azkomoly_app/app_localizations.dart';
import 'package:azkomoly_app/core/widgets/custom_image.dart';
import 'package:azkomoly_app/core/providers/shop_provider.dart';



class SocialCarousel extends StatelessWidget {
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
    final shopProvider = Provider.of<ShopProvider>(context); 
    final config = shopProvider.layoutConfig;
    final reviews = config.socialReviews;

    if (!config.isSocialCarouselEnabled || config.socialReviews.isEmpty) {
      return const SizedBox.shrink();
    }


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            AppLocalizations.translate('socials_title', shopProvider.appLanguage),
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
                        child: CustomImage(
                          source: item.thumbnailUrl,
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
                          child: item.isTikTok
                          ? FaIcon(
                            FontAwesomeIcons.tiktok,
                            color: Colors.white,
                            size: 18,
                          ) 
                          : FaIcon(
                            FontAwesomeIcons.instagram,
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
