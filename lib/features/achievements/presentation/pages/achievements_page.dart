import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_constants.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final isMobile = width < 850;

    final achievements = [
      {
        "target": 5.0,
        "prefix": "",
        "suffix": "+",
        "label": "Years of Experience",
        "desc": "Delivering high-quality cross-platform and backend code.",
        "icon": Icons.timeline,
      },
      {
        "target": 5.0,
        "prefix": "",
        "suffix": "+",
        "label": "Production Apps Shipped",
        "desc": "Built and deployed stable applications in Play Store, App Store & Web.",
        "icon": Icons.phone_android,
      },
      {
        "target": 4.0,
        "prefix": "",
        "suffix": "+",
        "label": "Multiple Industry Verticals",
        "desc": "Shipped solutions in FinTech, Restaurant management, and Social Media.",
        "icon": Icons.business_center_outlined,
      },
      {
        "target": 95.0,
        "prefix": "",
        "suffix": "%",
        "label": "CI/CD Pipeline Automation",
        "desc": "Utilized Fastlane and GitHub Actions to automate app distribution.",
        "icon": Icons.autorenew,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "MILESTONES & ACHIEVEMENTS",
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
              
              const SizedBox(height: 16),
              Text(
                "Key performance metrics and career highlights.",
                style: theme.textTheme.bodyLarge,
              ),

              const SizedBox(height: 60),

              // Achievements Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  final gridCols = width > 900 ? 4 : (width > 600 ? 2 : 1);
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridCols,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: gridCols == 4 ? 0.9 : 1.2,
                    ),
                    itemCount: achievements.length,
                    itemBuilder: (context, index) {
                      final item = achievements[index];
                      return AchievementCard(
                        target: item["target"] as double,
                        prefix: item["prefix"] as String,
                        suffix: item["suffix"] as String,
                        label: item["label"] as String,
                        desc: item["desc"] as String,
                        icon: item["icon"] as IconData,
                        index: index,
                        isDark: isDark,
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 80),

              // Certifications Section
              Text(
                "LICENSES & CERTIFICATIONS",
                style: theme.textTheme.displaySmall?.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 24),
              _buildCertificationsList(context, isDark, isMobile),

              const SizedBox(height: 80),

              // Testimonials Section
              Text(
                "RECOMMENDATIONS",
                style: theme.textTheme.displaySmall?.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 24),
              
              _buildTestimonialsList(context, isDark, isMobile),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestimonialsList(BuildContext context, bool isDark, bool isMobile) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isMobile) {
          return Column(
            children: AppConstants.testimonials.map((t) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TestimonialCard(data: t, isDark: isDark),
            )).toList(),
          );
        }
        
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: AppConstants.testimonials.map((t) => Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TestimonialCard(data: t, isDark: isDark),
            ),
          )).toList(),
        );
      },
    );
  }

  Widget _buildCertificationsList(BuildContext context, bool isDark, bool isMobile) {
    final certs = [
      {
        "title": "Deep Learning Certification",
        "authority": "Udemy",
        "url": "https://www.udemy.com/certificate/UC-a2443ed0-f5a7-4fe4-87fc-a98ac086509a/",
        "icon": Icons.psychology_outlined,
      },
      {
        "title": "Flutter Development Certification",
        "authority": "Udemy",
        "url": "https://www.udemy.com/certificate/UC-c7a4765b-8b99-41e4-95ee-6be9711e4220/",
        "icon": Icons.phone_android_outlined,
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final gridCols = isMobile ? 1 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridCols,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: isMobile ? 3.4 : 4.2,
          ),
          itemCount: certs.length,
          itemBuilder: (context, index) {
            final cert = certs[index];
            return CertificationCard(
              title: cert["title"] as String,
              authority: cert["authority"] as String,
              url: cert["url"] as String,
              icon: cert["icon"] as IconData,
              isDark: isDark,
            );
          },
        );
      },
    );
  }
}

class TestimonialCard extends StatefulWidget {
  final Map<String, String> data;
  final bool isDark;

  const TestimonialCard({
    super.key,
    required this.data,
    required this.isDark,
  });

  @override
  State<TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<TestimonialCard> {
  bool _isHovered = false;

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _launchURL(AppConstants.linkedin),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(28),
          transform: Matrix4.translationValues(0, _isHovered ? -6 : 0, 0),
          decoration: BoxDecoration(
            color: widget.isDark 
                ? (_isHovered ? Colors.white.withOpacity(0.02) : AppConstants.cardDark)
                : (_isHovered ? Colors.black.withOpacity(0.01) : AppConstants.cardLight),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered 
                  ? theme.primaryColor.withOpacity(0.6) 
                  : (widget.isDark ? AppConstants.borderDark : AppConstants.borderLight),
              width: 1.2,
            ),
            boxShadow: _isHovered 
                ? [
                    BoxShadow(
                      color: theme.primaryColor.withOpacity(0.08),
                      blurRadius: 20,
                      spreadRadius: 1,
                      offset: const Offset(0, 8),
                    )
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.format_quote, 
                    color: _isHovered ? theme.primaryColor : theme.primaryColor.withOpacity(0.5), 
                    size: 36,
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _isHovered ? 1.0 : 0.4,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "View Profile ",
                          style: TextStyle(
                            fontSize: 11,
                            color: _isHovered ? theme.primaryColor : theme.textTheme.bodySmall?.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        FaIcon(
                          FontAwesomeIcons.linkedin,
                          color: _isHovered ? theme.primaryColor : theme.textTheme.bodySmall?.color,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                widget.data["quote"]!,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                widget.data["author"]!,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 2),
              Text(
                widget.data["role"]!,
                style: TextStyle(fontSize: 12, color: theme.primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AchievementCard extends StatefulWidget {
  final double target;
  final String prefix;
  final String suffix;
  final String label;
  final String desc;
  final IconData icon;
  final int index;
  final bool isDark;

  const AchievementCard({
    super.key,
    required this.target,
    required this.prefix,
    required this.suffix,
    required this.label,
    required this.desc,
    required this.icon,
    required this.index,
    required this.isDark,
  });

  @override
  State<AchievementCard> createState() => _AchievementCardState();
}

class _AchievementCardState extends State<AchievementCard> with SingleTickerProviderStateMixin {
  late AnimationController _counterController;
  late Animation<double> _counterAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _counterController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _counterAnimation = Tween<double>(begin: 0.0, end: widget.target)
        .chain(CurveTween(curve: Curves.easeOutCubic))
        .animate(_counterController);

    _counterController.forward();
  }

  @override
  void dispose() {
    _counterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: widget.isDark 
              ? (_isHovered ? Colors.white.withOpacity(0.02) : AppConstants.cardDark)
              : (_isHovered ? Colors.black.withOpacity(0.01) : AppConstants.cardLight),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered 
                ? theme.primaryColor.withOpacity(0.5) 
                : (widget.isDark ? AppConstants.borderDark : AppConstants.borderLight),
            width: 1.2,
          ),
          boxShadow: _isHovered 
              ? [
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(0.05),
                    blurRadius: 16,
                    spreadRadius: 1,
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              widget.icon,
              color: _isHovered ? theme.primaryColor : theme.iconTheme.color?.withOpacity(0.5),
              size: 28,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Animated value text
                AnimatedBuilder(
                  animation: _counterAnimation,
                  builder: (context, child) {
                    final val = _counterAnimation.value.toInt();
                    return Text(
                      "${widget.prefix}$val${widget.suffix}",
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: _isHovered ? theme.primaryColor : null,
                        fontSize: 36,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 6),
                Text(
                  widget.label,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.desc,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (widget.index * 150).ms).slideY(begin: 0.1);
  }
}

class CertificationCard extends StatefulWidget {
  final String title;
  final String authority;
  final String url;
  final IconData icon;
  final bool isDark;

  const CertificationCard({
    super.key,
    required this.title,
    required this.authority,
    required this.url,
    required this.icon,
    required this.isDark,
  });

  @override
  State<CertificationCard> createState() => _CertificationCardState();
}

class _CertificationCardState extends State<CertificationCard> {
  bool _isHovered = false;

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _launchURL(widget.url),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(16),
          transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
          decoration: BoxDecoration(
            color: widget.isDark
                ? (_isHovered ? Colors.white.withOpacity(0.02) : AppConstants.cardDark)
                : (_isHovered ? Colors.black.withOpacity(0.01) : AppConstants.cardLight),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered
                  ? theme.primaryColor.withOpacity(0.6)
                  : (widget.isDark ? AppConstants.borderDark : AppConstants.borderLight),
              width: 1.2,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: theme.primaryColor.withOpacity(0.06),
                      blurRadius: 16,
                      spreadRadius: 1,
                      offset: const Offset(0, 6),
                    )
                  ]
                : [],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.icon,
                  color: _isHovered ? theme.primaryColor : theme.primaryColor.withOpacity(0.6),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.authority,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
