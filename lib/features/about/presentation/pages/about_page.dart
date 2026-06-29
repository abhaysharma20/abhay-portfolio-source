import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_constants.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final isMobile = width < 900;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ABOUT ME",
                style: theme.textTheme.displayMedium?.copyWith(
                  fontSize: isMobile ? 36 : 48,
                  letterSpacing: -1.0,
                ),
              ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1),
              const SizedBox(height: 12),
              Container(
                height: 4,
                width: 60,
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ).animate().fadeIn(delay: 200.ms).scaleX(begin: 0),
              const SizedBox(height: 48),
              
              // Narrative + Stats Grid
              isMobile
                  ? Column(
                      children: [
                        _buildNarrative(context, isDark),
                        const SizedBox(height: 48),
                        _buildStatsGrid(context, isDark),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _buildNarrative(context, isDark)),
                        const SizedBox(width: 60),
                        Expanded(flex: 3, child: _buildStatsGrid(context, isDark)),
                      ],
                    ),

              // Beyond Code — YouTube section
              const SizedBox(height: 64),
              _buildBeyondCode(context, isDark, isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBeyondCode(BuildContext context, bool isDark, bool isMobile) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "BEYOND CODE",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 2.5,
                color: isDark ? Colors.white54 : Colors.black45,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                height: 1,
                color: isDark ? Colors.white12 : Colors.black12,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 400.ms),
        const SizedBox(height: 28),
        _YouTubeCard(isDark: isDark, isMobile: isMobile),
      ],
    );
  }

  Widget _buildNarrative(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Engineering Quality Interfaces & Scalable Systems",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 20),
        Text(
          AppConstants.professionalSummary,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ).animate().fadeIn(delay: 350.ms),
        const SizedBox(height: 32),
        
        // Brief block detailing core philosophy
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.primaryColor.withOpacity(0.12)),
          ),
          child: Row(
            children: [
              Icon(Icons.lightbulb_outline, color: theme.primaryColor, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  "Philosophy: Write self-documenting code, maintain absolute separation of concerns, and design responsive layouts that delight users on any screen factor.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context, bool isDark) {
    final stats = [
      {
        "title": "5+ Years",
        "label": "Experience",
        "desc": "Deep proficiency in Dart, Flutter APIs, and modular architectures.",
        "icon": Icons.timeline,
      },
      {
        "title": "15+ Apps",
        "label": "Production Delivered",
        "desc": "Shipped to App Store, Google Play Store, and web hosting panels.",
        "icon": Icons.backup_outlined,
      },
      {
        "title": "Clean Arch",
        "label": "Architecture Expert",
        "desc": "Strict MVVM structure, clean Repository patterns, decoupling models.",
        "icon": Icons.architecture,
      },
      {
        "title": "Flutter Spec.",
        "label": "Domain Authority",
        "desc": "Custom painter widgets, advanced state managers, and platform integrations.",
        "icon": Icons.flutter_dash,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return StatCard(
          title: stat["title"] as String,
          label: stat["label"] as String,
          desc: stat["desc"] as String,
          icon: stat["icon"] as IconData,
          index: index,
        );
      },
    );
  }
}

class _YouTubeCard extends StatefulWidget {
  final bool isDark;
  final bool isMobile;

  const _YouTubeCard({required this.isDark, required this.isMobile});

  @override
  State<_YouTubeCard> createState() => _YouTubeCardState();
}

class _YouTubeCardState extends State<_YouTubeCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _openYouTube() async {
    final uri = Uri.parse(AppConstants.youtube);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _openYouTube,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          transform: _isHovered
              ? (Matrix4.identity()..translate(0, -5.0, 0))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _isHovered
                  ? [
                      const Color(0xFFFF0000).withOpacity(0.18),
                      const Color(0xFF7C4DFF).withOpacity(0.12),
                    ]
                  : [
                      widget.isDark
                          ? const Color(0xFF1A0000).withOpacity(0.7)
                          : const Color(0xFFFFF5F5),
                      widget.isDark
                          ? const Color(0xFF120A1F).withOpacity(0.7)
                          : const Color(0xFFF5F0FF),
                    ],
            ),
            border: Border.all(
              color: _isHovered
                  ? const Color(0xFFFF0000).withOpacity(0.5)
                  : (widget.isDark
                      ? AppConstants.borderDark
                      : AppConstants.borderLight),
              width: 1.5,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: const Color(0xFFFF0000).withOpacity(0.15),
                      blurRadius: 28,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          padding: EdgeInsets.all(widget.isMobile ? 20 : 28),
          child: widget.isMobile
              ? _buildMobileLayout(theme)
              : _buildDesktopLayout(theme),
        ),
      ),
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.08);
  }

  Widget _buildDesktopLayout(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildYouTubeIcon(),
        const SizedBox(width: 28),
        Expanded(child: _buildContent(theme)),
        const SizedBox(width: 24),
        _buildOpenButton(theme),
      ],
    );
  }

  Widget _buildMobileLayout(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildYouTubeIcon(),
            const SizedBox(width: 16),
            Expanded(child: _buildContent(theme)),
          ],
        ),
        const SizedBox(height: 20),
        _buildOpenButton(theme),
      ],
    );
  }

  Widget _buildYouTubeIcon() {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (context, child) {
        return Transform.scale(
          scale: _isHovered ? 1.0 : _pulseAnim.value,
          child: child,
        );
      },
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: const Color(0xFFFF0000),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF0000).withOpacity(0.4),
              blurRadius: 16,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Icon(
          Icons.play_arrow_rounded,
          color: Colors.white,
          size: 36,
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Piano & Vocals",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Beyond engineering, I play piano and sing — sharing covers and originals on YouTube. Music is where I find my flow outside of code.",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: widget.isDark ? Colors.white60 : Colors.black54,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            _Chip(label: "🎹 Piano", isDark: widget.isDark),
            _Chip(label: "🎤 Vocals", isDark: widget.isDark),
            _Chip(label: "🎵 Covers", isDark: widget.isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildOpenButton(ThemeData theme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: _isHovered
            ? const Color(0xFFFF0000)
            : const Color(0xFFFF0000).withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFF0000).withOpacity(0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.open_in_new_rounded,
            size: 16,
            color: _isHovered ? Colors.white : const Color(0xFFFF0000),
          ),
          const SizedBox(width: 8),
          Text(
            "Visit Channel",
            style: theme.textTheme.labelLarge?.copyWith(
              color: _isHovered ? Colors.white : const Color(0xFFFF0000),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isDark;

  const _Chip({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.06)
            : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.black12,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.white70 : Colors.black54,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class StatCard extends StatefulWidget {
  final String title;
  final String label;
  final String desc;
  final IconData icon;
  final int index;

  const StatCard({
    super.key,
    required this.title,
    required this.label,
    required this.desc,
    required this.icon,
    required this.index,
  });

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: _isHovered 
            ? (Matrix4.identity()..translate(0, -6, 0))
            : Matrix4.identity(),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark 
              ? (_isHovered ? Colors.white.withOpacity(0.03) : AppConstants.cardDark)
              : (_isHovered ? Colors.black.withOpacity(0.01) : AppConstants.cardLight),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered 
                ? theme.primaryColor.withOpacity(0.4) 
                : (isDark ? AppConstants.borderDark : AppConstants.borderLight),
            width: 1.5,
          ),
          boxShadow: _isHovered 
              ? [
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(0.08),
                    blurRadius: 16,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  widget.icon,
                  color: _isHovered ? theme.primaryColor : theme.iconTheme.color?.withOpacity(0.6),
                  size: 24,
                ),
                Container(
                  height: 6,
                  width: 6,
                  decoration: BoxDecoration(
                    color: _isHovered ? theme.primaryColor : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _isHovered ? theme.primaryColor : theme.textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.desc,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (widget.index * 150).ms).slideY(begin: 0.1);
  }
}
