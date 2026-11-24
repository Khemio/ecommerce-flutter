// lib/features/profile/widgets/profile_social_buttons.dart
import 'package:flutter/material.dart';
import 'package:azkomoly_app/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileSocialButtons extends StatelessWidget {
  final String appLanguage;
  const ProfileSocialButtons({super.key, required this.appLanguage});

  Future<void> _launchSocialUrl({
    required String nativeUrl,
    required String webFallbackUrl,
  }) async {
    final Uri nativeUri = Uri.parse(nativeUrl);
    final Uri webUri = Uri.parse(webFallbackUrl);

    try {
      if (await canLaunchUrl(nativeUri)) {
        await launchUrl(nativeUri, mode: LaunchMode.externalApplication);
        return; // Exit if successful!
      }
    } catch (e) {
      debugPrint("Native app not installed, falling back to web browser: $e");
    }
    if (await canLaunchUrl(webUri)) {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF0D0D0D), width: 2.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // 'KÖVESS MINKET / FOLLOW US',
            AppLocalizations.translate('follow_us', appLanguage),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          // Wrap(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // spacing: 10.0,       // Horizontal gap spacing between pills
          // runSpacing: 10.0,    // Vertical gap spacing if an element wraps to line 2
          // alignment: WrapAlignment.start,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialPill(
                icon: FontAwesomeIcons.tiktok,
                // label: 'TikTok',
                color: Colors.black,
                onTap: () => _launchSocialUrl(
                  // nativeUrl: 'snssdk1128://user/profile/azkomoly.hu',
                  nativeUrl:
                      'tiktok://user?username=azkomoly.hu', // Fixed for iOS + Android
                  webFallbackUrl: 'https://www.tiktok.com/@azkomoly.hu',
                ),
              ),
              _buildSocialPill(
                icon: FontAwesomeIcons.instagram,
                // label: 'Instagram',
                color: const Color(0xFFE1306C),
                onTap: () => _launchSocialUrl(
                  // nativeUrl: 'instagram://media?id=azkomoly.hu',
                  nativeUrl: 'instagram://user?username=azkomoly.hu',
                  webFallbackUrl: 'https://www.instagram.com/azkomoly.hu',
                ),
              ),
              _buildSocialPill(
                icon: FontAwesomeIcons.facebook,
                // label: 'Facebook',
                color: const Color(0xFF1877F2),
                onTap: () => _launchSocialUrl(
                  nativeUrl: 'fb://page/61590505527795',
                  webFallbackUrl:
                      'https://www.facebook.com/people/AZKOMOLYhu/61590505527795/',
                ),
              ),
              _buildSocialPill(
                icon: FontAwesomeIcons.youtube,
                // label: 'Youtube',
                color: Colors.red,
                onTap: () => _launchSocialUrl(
                  nativeUrl:
                      'youtube://www.youtube.com/@AzKomolyHungary', // Safe cross-platform URI
                  webFallbackUrl: 'https://www.youtube.com/@AzKomolyHungary',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialPill({
    required FaIconData icon,
    String? label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFF0D0D0D), width: 1.5),
        ),
        child: Row(
          children: [
            FaIcon(icon, color: color, size: 20),
            ?label != null ? const SizedBox(width: 6) : null,
            ?label != null
                ? Text(
                    label,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  )
                : null,
          ],
        ),
      ),
    );
  }
}
