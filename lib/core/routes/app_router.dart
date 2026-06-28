import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/shell_layout.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/about/presentation/pages/about_page.dart';
import '../../features/skills/presentation/pages/skills_page.dart';
import '../../features/experience/presentation/pages/experience_page.dart';
import '../../features/projects/presentation/pages/projects_page.dart';
import '../../features/achievements/presentation/pages/achievements_page.dart';
import '../../features/contact/presentation/pages/contact_page.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          'Page not found: ${state.error}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    ),
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ShellLayout(
            currentPath: state.matchedLocation,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => _customTransitionPage(
              state: state,
              child: const HomePage(),
            ),
          ),
          GoRoute(
            path: '/about',
            pageBuilder: (context, state) => _customTransitionPage(
              state: state,
              child: const AboutPage(),
            ),
          ),
          GoRoute(
            path: '/skills',
            pageBuilder: (context, state) => _customTransitionPage(
              state: state,
              child: const SkillsPage(),
            ),
          ),
          GoRoute(
            path: '/experience',
            pageBuilder: (context, state) => _customTransitionPage(
              state: state,
              child: const ExperiencePage(),
            ),
          ),
          GoRoute(
            path: '/projects',
            pageBuilder: (context, state) => _customTransitionPage(
              state: state,
              child: const ProjectsPage(),
            ),
          ),
          GoRoute(
            path: '/achievements',
            pageBuilder: (context, state) => _customTransitionPage(
              state: state,
              child: const AchievementsPage(),
            ),
          ),
          GoRoute(
            path: '/contact',
            pageBuilder: (context, state) => _customTransitionPage(
              state: state,
              child: const ContactPage(),
            ),
          ),
        ],
      ),
    ],
  );

  static CustomTransitionPage _customTransitionPage({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.04),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}
