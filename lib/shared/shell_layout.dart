import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import '../widgets/navbar.dart';
import '../widgets/mouse_glow_wrapper.dart';
import '../core/constants/app_constants.dart';

class ShellLayout extends StatefulWidget {
  final Widget child;
  final String currentPath;

  const ShellLayout({
    super.key,
    required this.child,
    required this.currentPath,
  });

  @override
  State<ShellLayout> createState() => _ShellLayoutState();
}

class _ShellLayoutState extends State<ShellLayout> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  
  double _scrollProgress = 0.0;
  late AnimationController _bgAnimationController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _bgAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant ShellLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPath != widget.currentPath) {
      // Reset scroll instantly so new page always starts at top
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0.0);
      }
      // Close mobile drawer if open
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scaffoldKey.currentState?.isEndDrawerOpen ?? false) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _bgAnimationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    
    setState(() {
      _scrollProgress = maxScroll > 0 ? (currentScroll / maxScroll).clamp(0.0, 1.0) : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _buildMobileDrawer(context),
      body: MouseGlowWrapper(
        child: Stack(
          children: [
            // Animated background mesh gradient
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _bgAnimationController,
                builder: (context, _) {
                  return CustomPaint(
                    painter: MeshBackgroundPainter(
                      progress: _bgAnimationController.value,
                      isDarkMode: isDark,
                      primaryGlow: AppConstants.primaryColor,
                      secondaryGlow: AppConstants.secondaryColor,
                    ),
                  );
                },
              ),
            ),

            // Scrollable Content
            Positioned.fill(
              child: Column(
                children: [
                  // Sticky Header / Navbar
                  Navbar(
                    currentPath: widget.currentPath,
                    onMenuPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                  ),
                  
                  // Main Body
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height - 150,
                            ),
                            child: widget.child,
                          ),
                          _buildFooter(context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Top Scroll Progress Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 3,
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: _scrollProgress,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [AppConstants.primaryColor, AppConstants.secondaryColor]
                            : [AppConstants.secondaryColor, AppConstants.accentColor],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileDrawer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Drawer(
      backgroundColor: isDark ? AppConstants.bgDark : AppConstants.bgLight,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "NAVIGATION",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                children: [
                  _drawerItem(context, "Home", "/", Icons.home_outlined),
                  _drawerItem(context, "About Me", "/about", Icons.person_outline),
                  _drawerItem(context, "Skills Matrix", "/skills", Icons.code),
                  _drawerItem(context, "Experience", "/experience", Icons.work_outline),
                  _drawerItem(context, "Projects", "/projects", Icons.rocket_launch_outlined),
                  _drawerItem(context, "Achievements", "/achievements", Icons.emoji_events_outlined),
                  _drawerItem(context, "Contact", "/contact", Icons.mail_outline),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                "© 2026 Abhay Sharma",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(BuildContext context, String title, String path, IconData icon) {
    final isSelected = widget.currentPath == path;
    final theme = Theme.of(context);
    
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? theme.primaryColor : theme.iconTheme.color?.withOpacity(0.7),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? theme.primaryColor : null,
        ),
      ),
      selected: isSelected,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: () {
        context.go(path);
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? AppConstants.bgDarkSecondary : AppConstants.bgLightSecondary,
        border: Border(
          top: BorderSide(
            color: isDark ? AppConstants.borderDark : AppConstants.borderLight,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Designed & Developed using Flutter Web",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.flash_on, color: Colors.amber, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "© 2026 Abhay Sharma. All rights reserved.",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

// Background painter that draws fluid, organic blurred glow spots
class MeshBackgroundPainter extends CustomPainter {
  final double progress;
  final bool isDarkMode;
  final Color primaryGlow;
  final Color secondaryGlow;

  MeshBackgroundPainter({
    required this.progress,
    required this.isDarkMode,
    required this.primaryGlow,
    required this.secondaryGlow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = isDarkMode ? AppConstants.bgDark : AppConstants.bgLight;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final angle = progress * 2 * math.pi;

    // Blob 1 coordinates (Primary Neon Cyan / Purple)
    final blob1x = size.width * (0.75 + 0.15 * math.cos(angle));
    final blob1y = size.height * (0.35 + 0.20 * math.sin(angle));
    final radius1 = math.max(size.width, size.height) * 0.45;

    final paint1 = Paint()
      ..shader = RadialGradient(
        colors: [
          (isDarkMode ? primaryGlow : secondaryGlow).withOpacity(isDarkMode ? 0.08 : 0.05),
          (isDarkMode ? primaryGlow : secondaryGlow).withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(center: Offset(blob1x, blob1y), radius: radius1));

    canvas.drawCircle(Offset(blob1x, blob1y), radius1, paint1);

    // Blob 2 coordinates (Secondary Purple / Accent Pink)
    final blob2x = size.width * (0.25 + 0.20 * math.sin(angle + math.pi));
    final blob2y = size.height * (0.65 + 0.15 * math.cos(angle + math.pi));
    final radius2 = math.max(size.width, size.height) * 0.50;

    final paint2 = Paint()
      ..shader = RadialGradient(
        colors: [
          (isDarkMode ? secondaryGlow : AppConstants.accentColor).withOpacity(isDarkMode ? 0.06 : 0.04),
          (isDarkMode ? secondaryGlow : AppConstants.accentColor).withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(center: Offset(blob2x, blob2y), radius: radius2));

    canvas.drawCircle(Offset(blob2x, blob2y), radius2, paint2);
  }

  @override
  bool shouldRepaint(MeshBackgroundPainter oldDelegate) =>
      progress != oldDelegate.progress ||
      isDarkMode != oldDelegate.isDarkMode ||
      primaryGlow != oldDelegate.primaryGlow ||
      secondaryGlow != oldDelegate.secondaryGlow;
}
