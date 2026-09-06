// lib/features/profile/widgets/profile_social_buttons.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileSocialButtons extends StatelessWidget {
  const ProfileSocialButtons({super.key});

  Future<void> _launchSocialUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication); // Native app routing hook!
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
          const Text(
            'KÖVESS MINKET / FOLLOW US',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 🎵 TikTok Button Target
              _buildSocialPill(
                icon: Icons.tiktok,
                label: 'TikTok',
                color: Colors.black,
                onTap: () => _launchSocialUrl('https://www.tiktok.com/@azkomoly.hu'),
              ),
              // 📸 Instagram Button Target
              _buildSocialPill(
                // FaIcon(
                //             FontAwesomeIcons.instagram,
                //             color: Colors.white,
                //             size: 18,
                //           ),
                icon: Icons.camera_alt,
                label: 'Instagram',
                color: const Color(0xFFE1306C),
                onTap: () => _launchSocialUrl('https://www.instagram.com/azkomoly.hu'),
              ),
              // 🔵 Facebook Button Target
              _buildSocialPill(
                icon: Icons.facebook,
                label: 'Facebook',
                color: const Color(0xFF1877F2),
                onTap: () => _launchSocialUrl('https://www.facebook.com/people/AZKOMOLYhu/61590505527795/'),
              ),
              // _buildSocialPill(
              //   icon: Icons.facebook,
              //   label: 'Youtube',
              //   color: const Color(0xFF1877F2),
              //   onTap: () => _launchSocialUrl('https://www.youtube.com/@AzKomolyHungary'),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialPill({
    required IconData icon, 
    required String label, 
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
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
