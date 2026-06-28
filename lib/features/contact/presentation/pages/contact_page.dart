import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/contact_provider.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final isMobile = width < 900;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "GET IN TOUCH",
                style: theme.textTheme.displayMedium?.copyWith(
                  fontSize: isMobile ? 36 : 48,
                  letterSpacing: -1.0,
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
              const SizedBox(height: 12),
              Container(
                height: 4,
                width: 60,
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ).animate().fadeIn(delay: 150.ms).scaleX(begin: 0),
              
              const SizedBox(height: 48),

              // Split layout: Info pane vs Form pane
              isMobile
                  ? Column(
                      children: [
                        _buildContactInfo(context, isDark),
                        const SizedBox(height: 48),
                        _buildContactForm(context, isDark),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _buildContactInfo(context, isDark)),
                        const SizedBox(width: 60),
                        Expanded(flex: 4, child: _buildContactForm(context, isDark)),
                      ],
                    ),
              const SizedBox(height: 60),
              Center(
                child: Text(
                  "Version ${AppConstants.appVersion}",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Let's Collaborate",
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const Text(
          "If you have an enterprise project, a complex cross-platform mobile application, or backend requirements in Python, feel free to send a message.",
          style: TextStyle(height: 1.5),
        ),
        
        const SizedBox(height: 36),

        // Contact info blocks
        _infoBlock(
          context,
          icon: Icons.mail_outline,
          title: "Email",
          value: AppConstants.email,
          onTap: () => _launchURL("mailto:${AppConstants.email}"),
        ),
        _infoBlock(
          context,
          icon: Icons.phone_android,
          title: "Phone",
          value: AppConstants.phone,
          onTap: () => _launchURL("tel:${AppConstants.phone}"),
        ),
        _infoBlock(
          context,
          icon: Icons.location_on_outlined,
          title: "Location",
          value: AppConstants.location,
          onTap: () {},
        ),

        const SizedBox(height: 40),
        const Divider(height: 1),
        const SizedBox(height: 32),

        // Social handles
        Text(
          "Social Profiles",
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _socialButton(
              context,
              icon: FontAwesomeIcons.github,
              label: "GitHub",
              onTap: () => _launchURL(AppConstants.github),
              isDark: isDark,
            ),
            const SizedBox(width: 12),
            _socialButton(
              context,
              icon: FontAwesomeIcons.linkedin,
              label: "LinkedIn",
              onTap: () => _launchURL(AppConstants.linkedin),
              isDark: isDark,
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.05);
  }

  Widget _infoBlock(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: theme.primaryColor, size: 22),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: isDark ? AppConstants.borderDark : AppConstants.borderLight),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(icon, size: 16),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildContactForm(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final contactProvider = Provider.of<ContactProvider>(context);

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppConstants.cardDark : AppConstants.cardLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppConstants.borderDark : AppConstants.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Send Message",
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            
            // Name Field
            TextFormField(
              controller: contactProvider.nameController,
              validator: (val) => val == null || val.isEmpty ? "Please enter your name" : null,
              decoration: const InputDecoration(
                labelText: "Your Name",
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 20),

            // Email Field
            TextFormField(
              controller: contactProvider.emailController,
              validator: (val) {
                if (val == null || val.isEmpty) return "Please enter your email";
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
                  return "Please enter a valid email address";
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: "Your Email Address",
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 20),

            // Message Field
            TextFormField(
              controller: contactProvider.messageController,
              maxLines: 5,
              validator: (val) => val == null || val.isEmpty ? "Please enter a message" : null,
              decoration: const InputDecoration(
                labelText: "Your Message",
                alignLabelWithHint: true,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 80),
                  child: Icon(Icons.edit_outlined),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: contactProvider.isSending
                    ? null
                    : () => contactProvider.submitForm(_formKey, context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: isDark ? Colors.black : Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: contactProvider.isSending
                    ? SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isDark ? Colors.black : Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        "SUBMIT MESSAGE",
                        style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                      ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideY(begin: 0.05);
  }
}
