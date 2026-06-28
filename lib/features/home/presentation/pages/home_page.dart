import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final isMobile = width < 900;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const SizedBox(height: 40),
              
              // Hero Section
              isMobile
                  ? Column(
                      children: [
                        _buildHeroVisual(context, true),
                        const SizedBox(height: 40),
                        _buildHeroText(context, true),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: _buildHeroText(context, false)),
                        Expanded(child: _buildHeroVisual(context, false)),
                      ],
                    ),
                    
              const SizedBox(height: 100),
              
              // Focus Domains Section
              _buildDomainsSection(context),
              
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroText(BuildContext context, bool isMobile) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          "HELLO WORLD, I'M",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),
        ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2),
        const SizedBox(height: 12),
        Text(
          AppConstants.name,
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: theme.textTheme.displayLarge?.copyWith(
            fontSize: isMobile ? 48 : 72,
            height: 1.1,
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideY(begin: 0.1),
        const SizedBox(height: 16),
        
        // Typing Animation
        SizedBox(
          height: 40,
          child: DefaultTextStyle(
            style: theme.textTheme.headlineMedium!.copyWith(
              fontSize: isMobile ? 20 : 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText('Senior Flutter Developer', speed: const Duration(milliseconds: 80)),
                TypewriterAnimatedText('Python Backend Developer', speed: const Duration(milliseconds: 80)),
                TypewriterAnimatedText('Clean Architecture Architect', speed: const Duration(milliseconds: 80)),
              ],
              repeatForever: true,
              pause: const Duration(milliseconds: 1000),
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        Text(
          "I engineer high-performance mobile and web products utilizing Clean Architecture and automated deployment pipelines, backed by solid Python microservices.",
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideY(begin: 0.1),
        
        const SizedBox(height: 40),
        
        // CTA Buttons
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () => context.go('/contact'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: isDark ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Hire Me", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () => _launchURL(AppConstants.resumeUrl),
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.white : Colors.black87,
                side: BorderSide(color: isDark ? Colors.white30 : Colors.black26),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.download, size: 18),
                  SizedBox(width: 8),
                  Text("Download CV", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
          ],
        ).animate().scale(delay: 600.ms, duration: 400.ms, curve: Curves.easeOutBack),
        
        const SizedBox(height: 40),
        
        // Socials Link Icons
        Row(
          mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            _socialIcon(FontAwesomeIcons.github, () => _launchURL(AppConstants.github), "GitHub"),
            _socialIcon(FontAwesomeIcons.linkedin, () => _launchURL(AppConstants.linkedin), "LinkedIn"),
          ],
        ).animate().fadeIn(delay: 800.ms, duration: 500.ms),
      ],
    );
  }

  Widget _buildHeroVisual(BuildContext context, bool isMobile) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated rotating orbitals
          SizedBox(
            height: isMobile ? 300 : 420,
            width: isMobile ? 300 : 420,
            child: const OrbitalVisualizer(),
          ),
          
          // Center mock code badge
          Container(
            padding: const EdgeInsets.all(24),
            width: isMobile ? 220 : 280,
            decoration: BoxDecoration(
              color: isDark ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  "class Developer {",
                  style: TextStyle(fontFamily: 'Courier', fontSize: 13, color: Colors.blueAccent, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "  name = 'Abhay';\n  skills = [\n    'Flutter',\n    'Clean Arch',\n    'Python'\n  ];",
                  style: TextStyle(fontFamily: 'Courier', fontSize: 13, color: Colors.purpleAccent, height: 1.4),
                ),
                const Text(
                  "}",
                  style: TextStyle(fontFamily: 'Courier', fontSize: 13, color: Colors.blueAccent, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 400.ms, duration: 600.ms).scale(begin: const Offset(0.8, 0.8)),
        ],
      ),
    );
  }

  Widget _socialIcon(IconData icon, VoidCallback onTap, String tooltip) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.08)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: FaIcon(
              icon,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDomainsSection(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final domains = [
      {"icon": Icons.wallet, "title": "FinTech Apps", "desc": "Led secure transactions systems & wallets with multi-payment integrations."},
      {"icon": Icons.chat, "title": "Social Feeds", "desc": "Implemented WebSocket chat systems and reactive social grids."},
      {"icon": Icons.edit_note, "title": "Digital Journals", "desc": "Constructed offline-first custom rich-text HTML rendering engines."},
      {"icon": Icons.dashboard_customize, "title": "Enterprise Suite", "desc": "Built admin platforms & CRM apps using structured architectures."}
    ];

    return Column(
      children: [
        Text(
          "Core Industry Verticals",
          style: theme.textTheme.displaySmall?.copyWith(fontSize: 28),
        ).animate().fadeIn(),
        const SizedBox(height: 12),
        Text(
          "Experienced in engineering high-fidelity production applications across multiple sectors.",
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 48),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 280,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.1,
          ),
          itemCount: domains.length,
          itemBuilder: (context, index) {
            final item = domains[index];
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppConstants.cardDark : AppConstants.cardLight,
                border: Border.all(
                  color: isDark ? AppConstants.borderDark : AppConstants.borderLight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(item["icon"] as IconData, color: theme.primaryColor, size: 28),
                  const SizedBox(height: 16),
                  Text(
                    item["title"] as String,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      item["desc"] as String,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.1);
          },
        ),
      ],
    );
  }
}

// Beautiful CustomPainter to render neon rotating orbit lines & particles representing mobile systems
class OrbitalVisualizer extends StatefulWidget {
  const OrbitalVisualizer({super.key});

  @override
  State<OrbitalVisualizer> createState() => _OrbitalVisualizerState();
}

class _OrbitalVisualizerState extends State<OrbitalVisualizer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: OrbitalPainter(
            rotation: _controller.value,
            isDarkMode: isDark,
            cyanColor: AppConstants.primaryColor,
            purpleColor: AppConstants.secondaryColor,
          ),
        );
      },
    );
  }
}

class OrbitalPainter extends CustomPainter {
  final double rotation;
  final bool isDarkMode;
  final Color cyanColor;
  final Color purpleColor;

  OrbitalPainter({
    required this.rotation,
    required this.isDarkMode,
    required this.cyanColor,
    required this.purpleColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paintRing1 = Paint()
      ..color = cyanColor.withOpacity(isDarkMode ? 0.08 : 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final paintRing2 = Paint()
      ..color = purpleColor.withOpacity(isDarkMode ? 0.08 : 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw orbits
    final maxRadius = size.width * 0.45;
    canvas.drawCircle(center, maxRadius, paintRing1);
    canvas.drawCircle(center, maxRadius * 0.7, paintRing2);

    final angle1 = rotation * 2 * math.pi;
    final angle2 = -rotation * 2 * math.pi * 1.5;

    // Outer orbit particle (Cyan)
    final p1x = center.dx + maxRadius * math.cos(angle1);
    final p1y = center.dy + maxRadius * math.sin(angle1);
    final paintParticle1 = Paint()
      ..color = cyanColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(p1x, p1y), 8, paintParticle1);
    canvas.drawCircle(Offset(p1x, p1y), 4, Paint()..color = Colors.white);

    // Inner orbit particle (Purple)
    final p2x = center.dx + maxRadius * 0.7 * math.cos(angle2);
    final p2y = center.dy + maxRadius * 0.7 * math.sin(angle2);
    final paintParticle2 = Paint()
      ..color = purpleColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(p2x, p2y), 8, paintParticle2);
    canvas.drawCircle(Offset(p2x, p2y), 4, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(OrbitalPainter oldDelegate) =>
      rotation != oldDelegate.rotation || isDarkMode != oldDelegate.isDarkMode;
}
