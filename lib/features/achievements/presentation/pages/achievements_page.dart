import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/pub_packages.dart';

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

              // Open Source Packages Section
              Text(
                "OPEN SOURCE PACKAGES",
                style: theme.textTheme.displaySmall?.copyWith(fontSize: 28),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 8),
              Text(
                "Published Flutter & Dart packages on pub.dev.",
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              _buildPackagesList(context, isDark, isMobile),

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

  Widget _buildPackagesList(BuildContext context, bool isDark, bool isMobile) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: PubPackages.packages.asMap().entries.map((entry) {
            final index = entry.key;
            final pkg = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: PubPackageCard(
                pkg: pkg,
                isDark: isDark,
                index: index,
              ),
            );
          }).toList(),
        );
      },
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

class PubPackageCard extends StatefulWidget {
  final Map<String, dynamic> pkg;
  final bool isDark;
  final int index;

  const PubPackageCard({
    super.key,
    required this.pkg,
    required this.isDark,
    required this.index,
  });

  @override
  State<PubPackageCard> createState() => _PubPackageCardState();
}

class _PubPackageCardState extends State<PubPackageCard> {
  bool _isHovered = false;

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pkg = widget.pkg;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _launchURL(pkg['url'] as String),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: widget.isDark
                ? (_isHovered
                    ? Colors.white.withOpacity(0.025)
                    : AppConstants.cardDark)
                : (_isHovered
                    ? Colors.black.withOpacity(0.01)
                    : AppConstants.cardLight),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered
                  ? theme.primaryColor.withOpacity(0.6)
                  : (widget.isDark
                      ? AppConstants.borderDark
                      : AppConstants.borderLight),
              width: 1.2,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: theme.primaryColor.withOpacity(0.08),
                      blurRadius: 24,
                      spreadRadius: 1,
                      offset: const Offset(0, 8),
                    )
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: package name + pub.dev badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // pub.dev icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.extension_rounded,
                      color: _isHovered
                          ? theme.primaryColor
                          : theme.primaryColor.withOpacity(0.6),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                pkg['name'] as String,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: _isHovered ? theme.primaryColor : null,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0175C2).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: const Color(0xFF0175C2).withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: const Text(
                                'pub.dev',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0175C2),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'v${pkg['version']}',
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _isHovered ? 1.0 : 0.3,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Description
              Text(
                pkg['description'] as String,
                style: theme.textTheme.bodySmall?.copyWith(
                  height: 1.6,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 20),

              // Stats row
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _StatChip(
                    icon: Icons.favorite_rounded,
                    value: '${pkg['likes']}',
                    label: 'likes',
                    color: const Color(0xFFFF4081),
                    isDark: widget.isDark,
                  ),
                  _StatChip(
                    icon: Icons.stars_rounded,
                    value: '${pkg['points']}',
                    label: 'pub points',
                    color: const Color(0xFFFFD700),
                    isDark: widget.isDark,
                  ),
                  _StatChip(
                    icon: Icons.download_rounded,
                    value: '${pkg['downloads']}',
                    label: 'downloads',
                    color: theme.primaryColor,
                    isDark: widget.isDark,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Tags
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: (pkg['tags'] as List<String>).map((tag) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: theme.primaryColor.withOpacity(0.15),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.primaryColor.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: (widget.index * 100).ms, duration: 400.ms)
        .slideY(begin: 0.05);
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final bool isDark;

  const _StatChip({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
