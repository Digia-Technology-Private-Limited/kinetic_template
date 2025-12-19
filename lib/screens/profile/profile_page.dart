import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/cache_manager.dart';
import '../../core/utils/toast_utils.dart';
import 'help_center_page.dart';
import 'about_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  String _appVersion = '';
  String _cacheSize = 'Calculating...';

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
    _loadCacheSize();
  }

  Future<void> _loadAppInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = 'v${packageInfo.version} (${packageInfo.buildNumber})';
    });
  }

  Future<void> _loadCacheSize() async {
    final size = await CacheManager.getCacheSize();
    setState(() {
      _cacheSize = CacheManager.formatBytes(size);
    });
  }

  Future<void> _clearCache() async {
    ToastUtils.showInfo('Clearing cache...');
    await CacheManager.clearCache();
    await _loadCacheSize();
    ToastUtils.showSuccess('Cache cleared successfully!');
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'support@example.com',
      query: 'subject=Support Request',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchPhone() async {
    final uri = Uri(scheme: 'tel', path: '+15551234567');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white100,
      appBar: AppBar(
        title: Text(
          "Profile",
          style: AppTextStyles.h2Medium.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile Picture
            GestureDetector(
              onTap: _showImageSourceDialog,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.bgLight2,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : null,
                    child: _profileImage == null
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: AppColors.black50,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.primary100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "John Doe",
              style: AppTextStyles.h2Medium.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "john.doe@example.com",
              style: AppTextStyles.bodyLargeMedium.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Menu Items
            _buildMenuItem(
              icon: Icons.shopping_bag,
              title: "My Orders",
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.location_on,
              title: "Shipping Addresses",
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.credit_card,
              title: "Payment Methods",
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.favorite,
              title: "Wishlist",
              onTap: () {},
            ),
            const Divider(height: 32),
            _buildMenuItem(
              icon: Icons.help_outline,
              title: "Help Center",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HelpCenterPage()),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.info_outline,
              title: "About Us",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutPage()),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.email,
              title: "Contact Support",
              subtitle: "support@example.com",
              onTap: _launchEmail,
            ),
            _buildMenuItem(
              icon: Icons.phone,
              title: "Call Us",
              subtitle: "+1 (555) 123-4567",
              onTap: _launchPhone,
            ),
            _buildMenuItem(
              icon: Icons.language,
              title: "Visit Website",
              subtitle: "www.example.com",
              onTap: () => _launchURL('https://www.example.com'),
            ),
            const Divider(height: 32),
            _buildMenuItem(
              icon: Icons.privacy_tip_outlined,
              title: "Privacy Policy",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AboutPage(isPrivacyPolicy: true),
                  ),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.description_outlined,
              title: "Terms & Conditions",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AboutPage(isTermsAndConditions: true),
                  ),
                );
              },
            ),
            const Divider(height: 32),
            _buildMenuItem(
              icon: Icons.cleaning_services,
              title: "Clear Cache",
              subtitle: _cacheSize,
              onTap: _clearCache,
            ),
            const SizedBox(height: 16),
            Text(
              _appVersion,
              style: AppTextStyles.bodySmallMedium.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // Logout logic
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Logout",
                  style: AppTextStyles.bodyLargeBold.copyWith(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.bgLight2,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.black100, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyLargeMedium),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmallMedium.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.black50),
          ],
        ),
      ),
    );
  }
}
