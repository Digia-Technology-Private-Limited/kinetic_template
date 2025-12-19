import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/icon_buttons.dart';

class AboutPage extends StatelessWidget {
  final bool isPrivacyPolicy;
  final bool isTermsAndConditions;

  const AboutPage({
    super.key,
    this.isPrivacyPolicy = false,
    this.isTermsAndConditions = false,
  });

  String get title {
    if (isPrivacyPolicy) return "Privacy Policy";
    if (isTermsAndConditions) return "Terms & Conditions";
    return "About Us";
  }

  String get markdownContent {
    if (isPrivacyPolicy) {
      return _privacyPolicyMarkdown;
    } else if (isTermsAndConditions) {
      return _termsAndConditionsMarkdown;
    }
    return _aboutUsMarkdown;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white100,
      appBar: AppBar(
        leading: BackArrowButton(onPressed: () => Navigator.pop(context)),
        title: Text(
          title,
          style: AppTextStyles.h2Medium.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: MarkdownWidget(
          data: markdownContent,
          config: MarkdownConfig(
            configs: [
              H1Config(
                style: AppTextStyles.h2Medium.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              H2Config(
                style: AppTextStyles.h2Medium.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              PConfig(
                textStyle: AppTextStyles.bodyLargeMedium.copyWith(
                  color: Colors.grey[800],
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const String _aboutUsMarkdown = '''
# About Us

Welcome to our E-Commerce store! We are dedicated to providing you with the best shopping experience possible.

## Our Mission

Our mission is to deliver high-quality products at affordable prices while maintaining exceptional customer service.

## What We Offer

- **Wide Selection**: Thousands of products across multiple categories
- **Quality Assurance**: All products are carefully vetted for quality
- **Fast Shipping**: Quick and reliable delivery to your doorstep
- **Customer Support**: 24/7 assistance for all your needs

## Our Values

We believe in:

1. **Integrity** - Honest and transparent business practices
2. **Quality** - Only the best products for our customers
3. **Innovation** - Constantly improving our service
4. **Sustainability** - Environmentally responsible operations

## Contact Us

Have questions? We'd love to hear from you!

- Email: support@example.com
- Phone: +1 (555) 123-4567
- Address: 123 Main Street, City, State 12345

Thank you for choosing us!
''';

  static const String _privacyPolicyMarkdown = '''
# Privacy Policy

**Last Updated**: December 2025

## Introduction

We respect your privacy and are committed to protecting your personal data.

## Information We Collect

We collect the following types of information:

- **Personal Information**: Name, email, phone number, shipping address
- **Payment Information**: Credit card details (securely processed)
- **Usage Data**: Browsing behavior, preferences, order history

## How We Use Your Information

Your information is used to:

1. Process and fulfill your orders
2. Improve our services and user experience
3. Send promotional materials (with your consent)
4. Comply with legal obligations

## Data Security

We implement industry-standard security measures to protect your data:

- SSL encryption for all transactions
- Secure payment processing
- Regular security audits
- Limited access to personal information

## Your Rights

You have the right to:

- Access your personal data
- Request corrections to your data
- Delete your account and data
- Opt-out of marketing communications

## Cookies

We use cookies to enhance your browsing experience. You can manage cookie preferences in your browser settings.

## Third-Party Services

We may share data with trusted third-party service providers for:

- Payment processing
- Shipping and logistics
- Analytics and marketing

## Children's Privacy

Our services are not intended for children under 13. We do not knowingly collect data from children.

## Changes to This Policy

We may update this policy periodically. Changes will be posted on this page with an updated date.

## Contact Us

For privacy concerns, contact us at:
- Email: privacy@example.com
- Phone: +1 (555) 123-4567
''';

  static const String _termsAndConditionsMarkdown = '''
# Terms & Conditions

**Effective Date**: December 2025

## Agreement to Terms

By accessing and using our services, you agree to these Terms & Conditions.

## Use of Service

### Eligibility

You must be at least 18 years old to use our services.

### Account Responsibilities

- Maintain accurate account information
- Keep your password secure
- Notify us of unauthorized access
- You are responsible for all activity under your account

## Products and Orders

### Product Information

- We strive for accuracy in product descriptions
- Images are for illustration purposes
- Prices are subject to change without notice

### Order Acceptance

- We reserve the right to refuse or cancel orders
- Payment must be received before order processing
- Order confirmation does not guarantee acceptance

## Shipping and Delivery

- Shipping times are estimates only
- Risk of loss passes to you upon delivery
- International orders may incur customs fees

## Returns and Refunds

- 30-day return policy for unused items
- Items must be in original condition with tags
- Refunds processed within 5-10 business days

## Intellectual Property

All content on our platform is protected by copyright and trademark laws:

- Product images and descriptions
- Website design and layout
- Logos and branding materials

## Limitation of Liability

To the maximum extent permitted by law:

- We are not liable for indirect or consequential damages
- Our liability is limited to the purchase price
- We do not guarantee uninterrupted service

## User Conduct

You agree not to:

1. Violate any laws or regulations
2. Infringe on intellectual property rights
3. Transmit malicious code or viruses
4. Attempt unauthorized access to our systems

## Dispute Resolution

- Disputes will be governed by state law
- You agree to attempt mediation before litigation
- Class action waivers apply where permitted

## Modifications

We reserve the right to modify these terms at any time. Continued use constitutes acceptance of changes.

## Termination

We may terminate or suspend your account for:

- Violation of these terms
- Fraudulent activity
- Any reason at our discretion

## Contact Information

For questions about these terms:
- Email: legal@example.com
- Phone: +1 (555) 123-4567
- Address: 123 Main Street, City, State 12345

---

**By using our services, you acknowledge that you have read and understood these Terms & Conditions.**
''';
}
