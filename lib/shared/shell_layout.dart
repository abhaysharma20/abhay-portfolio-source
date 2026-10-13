import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../widgets/navbar.dart';
import '../widgets/mouse_glow_wrapper.dart';
import '../core/constants/app_constants.dart';
import '../core/providers/theme_provider.dart';
import 'single_page_view.dart';

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

class _ShellLayoutState extends State<ShellLayout>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<SinglePageViewState> _singlePageKey =
      GlobalKey<SinglePageViewState>();

  double _scrollProgress = 0.0;
  late AnimationController _bgAnimationController;

  // Active section in single-page mode
  String _activeSinglePagePath = '/';

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
    final isSingle =
        Provider.of<ThemeProvider>(context, listen: false).isSinglePage;
    if (!isSingle && oldWidget.currentPath != widget.currentPath) {
      // Tab mode: reset scroll on route change
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0.0);
      }
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
    final current = _scrollController.position.pixels;
    setState(() {
      _scrollProgress =
          maxScroll > 0 ? (current / maxScroll).clamp(0.0, 1.0) : 0.0;
    });
  }

  /// Called when navbar item tapped in single-page mode
  void _scrollToSection(String path) {
    _singlePageKey.currentState?.scrollToSection(path);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isSinglePage =
        context.watch<ThemeProvider>().isSinglePage;

    // Which path to highlight in the navbar
    final activePath =
        isSinglePage ? _activeSinglePagePath : widget.currentPath;

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _buildMobileDrawer(context, isSinglePage, activePath),
      body: MouseGlowWrapper(
        child: Stack(
          children: [
            // ── Animated background ─────────────────────────────────
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _bgAnimationController,
                builder: (context, _) => CustomPaint(
                  painter: MeshBackgroundPainter(
                    progress: _bgAnimationController.value,
                    isDarkMode: isDark,
                    primaryGlow: AppConstants.primaryColor,
                    secondaryGlow: AppConstants.secondaryColor,
                  ),
                ),
              ),
            ),

            // ── Scrollable content ───────────────────────────────────
            Positioned.fill(
              child: Column(
                children: [
                  Navbar(
                    currentPath: activePath,
                    isSinglePage: isSinglePage,
                    onMenuPressed: () =>
                        _scaffoldKey.currentState?.openEndDrawer(),
                    onNavItemTapped: isSinglePage ? _scrollToSection : null,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          if (isSinglePage)
                            // ── Single-page: all sections stacked ───
                            SinglePageView(
                              key: _singlePageKey,
                              scrollController: _scrollController,
                              onSectionChanged: (path) {
                                if (mounted) {
                                  setState(
                                      () => _activeSinglePagePath = path);
                                }
                              },
                            )
                          else
                            // ── Tab mode: routed child ───────────────
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight:
                                    MediaQuery.of(context).size.height - 150,
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

            // ── Scroll progress bar ──────────────────────────────────
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
                            ? [
                                AppConstants.primaryColor,
                                AppConstants.secondaryColor
                              ]
                            : [
                                AppConstants.secondaryColor,
                                AppConstants.accentColor
                              ],
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

  Widget _buildMobileDrawer(
      BuildContext context, bool isSinglePage, String activePath) {
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
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                children: [
                  _drawerItem(context, "Home", "/", Icons.home_outlined,
                      isSinglePage, activePath),
                  _drawerItem(context, "About Me", "/about",
                      Icons.person_outline, isSinglePage, activePath),
                  _drawerItem(context, "Skills Matrix", "/skills", Icons.code,
                      isSinglePage, activePath),
                  _drawerItem(context, "Experience", "/experience",
                      Icons.work_outline, isSinglePage, activePath),
                  _drawerItem(context, "Projects", "/projects",
                      Icons.rocket_launch_outlined, isSinglePage, activePath),
                  _drawerItem(context, "Achievements", "/achievements",
                      Icons.emoji_events_outlined, isSinglePage, activePath),
                  _drawerItem(context, "Contact", "/contact",
                      Icons.mail_outline, isSinglePage, activePath),
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

  Widget _drawerItem(
    BuildContext context,
    String title,
    String path,
    IconData icon,
    bool isSinglePage,
    String activePath,
  ) {
    final isSelected = activePath == path;
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? theme.primaryColor
            : theme.iconTheme.color?.withOpacity(0.7),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? theme.primaryColor : null,
        ),
      ),
      selected: isSelected,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: () {
        Navigator.of(context).pop();
        if (isSinglePage) {
          _scrollToSection(path);
        } else {
          context.go(path);
        }
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: isDark
            ? AppConstants.bgDarkSecondary
            : AppConstants.bgLightSecondary,
        border: Border(
          top: BorderSide(
            color:
                isDark ? AppConstants.borderDark : AppConstants.borderLight,
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

// ── Background painter ───────────────────────────────────────────────────────

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

    final blob1x = size.width * (0.75 + 0.15 * math.cos(angle));
    final blob1y = size.height * (0.35 + 0.20 * math.sin(angle));
    final radius1 = math.max(size.width, size.height) * 0.45;

    final paint1 = Paint()
      ..shader = RadialGradient(
        colors: [
          (isDarkMode ? primaryGlow : secondaryGlow)
              .withOpacity(isDarkMode ? 0.08 : 0.05),
          (isDarkMode ? primaryGlow : secondaryGlow).withOpacity(0.0),
        ],
      ).createShader(
          Rect.fromCircle(center: Offset(blob1x, blob1y), radius: radius1));
    canvas.drawCircle(Offset(blob1x, blob1y), radius1, paint1);

    final blob2x = size.width * (0.25 + 0.20 * math.sin(angle + math.pi));
    final blob2y =
        size.height * (0.65 + 0.15 * math.cos(angle + math.pi));
    final radius2 = math.max(size.width, size.height) * 0.50;

    final paint2 = Paint()
      ..shader = RadialGradient(
        colors: [
          (isDarkMode ? secondaryGlow : AppConstants.accentColor)
              .withOpacity(isDarkMode ? 0.06 : 0.04),
          (isDarkMode ? secondaryGlow : AppConstants.accentColor)
              .withOpacity(0.0),
        ],
      ).createShader(
          Rect.fromCircle(center: Offset(blob2x, blob2y), radius: radius2));
    canvas.drawCircle(Offset(blob2x, blob2y), radius2, paint2);
  }

  @override
  bool shouldRepaint(MeshBackgroundPainter old) =>
      progress != old.progress ||
      isDarkMode != old.isDarkMode ||
      primaryGlow != old.primaryGlow ||
      secondaryGlow != old.secondaryGlow;
}
