import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/about/presentation/pages/about_page.dart';
import '../../features/skills/presentation/pages/skills_page.dart';
import '../../features/experience/presentation/pages/experience_page.dart';
import '../../features/projects/presentation/pages/projects_page.dart';
import '../../features/achievements/presentation/pages/achievements_page.dart';
import '../../features/contact/presentation/pages/contact_page.dart';

/// Sections in the order they appear on the single-page view.
const kSectionRoutes = [
  '/',
  '/about',
  '/skills',
  '/experience',
  '/projects',
  '/achievements',
  '/contact',
];

/// Widget that renders all portfolio sections in a single scrollable column.
/// Reports the currently-visible section path via [onSectionChanged].
class SinglePageView extends StatefulWidget {
  final ScrollController scrollController;
  final void Function(String sectionPath) onSectionChanged;

  const SinglePageView({
    super.key,
    required this.scrollController,
    required this.onSectionChanged,
  });

  @override
  State<SinglePageView> createState() => SinglePageViewState();
}

class SinglePageViewState extends State<SinglePageView> {
  // One GlobalKey per section — used by scrollToSection()
  final List<GlobalKey> _keys = List.generate(
    kSectionRoutes.length,
    (_) => GlobalKey(),
  );

  // Visibility fraction per section
  final Map<String, double> _visibility = {};

  String _activePath = '/';

  /// Called from [ShellLayout] / [Navbar] to jump to a section.
  void scrollToSection(String path) {
    final idx = kSectionRoutes.indexOf(path);
    if (idx < 0) return;
    final ctx = _keys[idx].currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
      alignment: 0.0,
    );
  }

  void _onVisibilityChanged(String path, double fraction) {
    _visibility[path] = fraction;
    // Find the section with the highest visibility fraction
    final best = _visibility.entries.reduce(
      (a, b) => a.value >= b.value ? a : b,
    );
    if (best.value > 0.05 && best.key != _activePath) {
      _activePath = best.key;
      widget.onSectionChanged(best.key);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sections = [
      const HomePage(),
      const AboutPage(),
      const SkillsPage(),
      const ExperiencePage(),
      const ProjectsPage(),
      const AchievementsPage(),
      const ContactPage(),
    ];

    return Column(
      children: List.generate(sections.length, (i) {
        return VisibilityDetector(
          key: Key('section_${kSectionRoutes[i]}'),
          onVisibilityChanged: (info) =>
              _onVisibilityChanged(kSectionRoutes[i], info.visibleFraction),
          child: KeyedSubtree(
            key: _keys[i],
            child: sections[i],
          ),
        );
      }),
    );
  }
}
