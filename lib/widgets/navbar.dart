import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../core/providers/theme_provider.dart';
import '../core/constants/app_constants.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final String currentPath;
  final VoidCallback onMenuPressed;

  const Navbar({
    super.key,
    required this.currentPath,
    required this.onMenuPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 850;

    return Container(
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withOpacity(0.4)
            : Colors.white.withOpacity(0.4),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.black.withOpacity(0.05),
            width: 1,
          ),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ── Logo ───────────────────────────────────────────
                GestureDetector(
                  onTap: () => context.go('/'),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Row(
                      children: [
                        _AnimatedLogoWidget(isDark: isDark),
                        const SizedBox(width: 12),
                        Text(
                          "Abhay Sharma",
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                    fontSize: 18,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Nav Items (Desktop) ─────────────────────────────
                if (!isMobile)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _navItem(context, "Home", "/"),
                      _navItem(context, "About", "/about"),
                      _navItem(context, "Skills", "/skills"),
                      _navItem(context, "Experience", "/experience"),
                      _navItem(context, "Projects", "/projects"),
                      _navItem(context, "Achievements", "/achievements"),
                      _navItem(context, "Contact", "/contact"),
                    ],
                  ),

                // ── Actions (Theme toggle & Mobile menu) ────────────
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        isDark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                      onPressed: () => themeProvider.toggleTheme(),
                      tooltip: "Toggle Theme",
                    ),
                    if (isMobile) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                        onPressed: onMenuPressed,
                      ),
                    ]
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, String title, String path) {
    final isSelected = currentPath == path;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        onPressed: () => context.go(path),
        style: TextButton.styleFrom(
          foregroundColor: isSelected
              ? theme.primaryColor
              : (isDark ? Colors.white70 : Colors.black87),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
            color: isSelected
                ? theme.primaryColor
                : (isDark ? Colors.white70 : Colors.black87),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title),
              if (isSelected)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  height: 2,
                  width: 16,
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Animated Person-Coding ↔ </> Logo ───────────────────────────────────────

class _AnimatedLogoWidget extends StatefulWidget {
  final bool isDark;
  const _AnimatedLogoWidget({required this.isDark});

  @override
  State<_AnimatedLogoWidget> createState() => _AnimatedLogoWidgetState();
}

class _AnimatedLogoWidgetState extends State<_AnimatedLogoWidget>
    with SingleTickerProviderStateMixin {
  /// true  = person+laptop icon visible
  /// false = </> code icon visible
  bool _showPerson = true;

  // Glow pulse controller — only active while </> is shown
  late final AnimationController _glowCtrl;
  late final Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();

    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _glowAnim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut),
    );

    _startLoop();
  }

  Future<void> _startLoop() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return;
      setState(() => _showPerson = false); // fade to </>

      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return;
      setState(() => _showPerson = true); // fade back to person
    }
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    super.dispose();
  }

  List<Color> get _colors => widget.isDark
      ? [AppConstants.primaryColor, AppConstants.secondaryColor]
      : [AppConstants.secondaryColor, AppConstants.accentColor];

  /// Shared gradient badge shell used by both icons.
  Widget _badge({required Widget child, bool glow = false}) {
    return AnimatedBuilder(
      animation: _glowCtrl,
      builder: (_, __) {
        return Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: (glow && !_showPerson)
                ? [
                    BoxShadow(
                      color: AppConstants.primaryColor
                          .withOpacity(0.45 * _glowAnim.value),
                      blurRadius: 18 * _glowAnim.value,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 46,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── Person + Laptop (coding person icon) ──────────────────
          AnimatedOpacity(
            opacity: _showPerson ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            child: AnimatedScale(
              scale: _showPerson ? 1.0 : 0.8,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: _badge(
                child: Stack(
                  alignment: Alignment.center,
                  children: const [
                    Positioned(
                      top: 6,
                      child: Icon(
                        Icons.person,
                        color: Colors.black,
                        size: 19,
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      child: Icon(
                        Icons.laptop_mac,
                        color: Colors.black,
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── </> Code Icon ─────────────────────────────────────────
          AnimatedOpacity(
            opacity: _showPerson ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            child: AnimatedScale(
              scale: _showPerson ? 0.8 : 1.0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: _badge(
                glow: true,
                child: const Center(
                  child: Text(
                    "</>",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
