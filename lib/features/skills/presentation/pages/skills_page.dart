import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/app_constants.dart';

// ─── Skill Icon Registry ──────────────────────────────────────────────────────
// Maps each skill name to an (IconData, Color) pair.
// FontAwesome brand icons are used where available; Material icons as fallback.

const _kDefaultColor = Color(0xFF607D8B);

const Map<String, ({IconData icon, Color color})> _skillIcons = {
  // Mobile
  "Flutter": (icon: FontAwesomeIcons.flutter, color: Color(0xFF54C5F8)),
  "Dart": (icon: FontAwesomeIcons.dartLang, color: Color(0xFF00B4AB)),
  "React Native": (icon: FontAwesomeIcons.react, color: Color(0xFF61DAFB)),
  "Kotlin": (icon: FontAwesomeIcons.java, color: Color(0xFF7F52FF)),

  // Backend
  "Python": (icon: FontAwesomeIcons.python, color: Color(0xFF3776AB)),
  "REST APIs": (icon: FontAwesomeIcons.plug, color: Color(0xFF4CAF50)),
  "Firebase": (icon: FontAwesomeIcons.fire, color: Color(0xFFFF9800)),
  "Authentication": (icon: FontAwesomeIcons.lock, color: Color(0xFF9C27B0)),
  "JSON": (icon: FontAwesomeIcons.fileCode, color: Color(0xFFFFEB3B)),

  // Architecture
  "Clean Architecture": (icon: FontAwesomeIcons.layerGroup, color: Color(0xFF00E5FF)),
  "MVVM": (icon: FontAwesomeIcons.codeBranch, color: Color(0xFF7C4DFF)),
  "Repository Pattern": (icon: FontAwesomeIcons.database, color: Color(0xFF2196F3)),
  "Dependency Injection": (icon: FontAwesomeIcons.syringe, color: Color(0xFFE91E63)),

  // State Management
  "GetX": (icon: FontAwesomeIcons.bolt, color: Color(0xFFFF5722)),
  "Provider": (icon: FontAwesomeIcons.cubesStacked, color: Color(0xFF00BCD4)),
  "BLoC": (icon: FontAwesomeIcons.stream, color: Color(0xFF3F51B5)),

  // Database
  "Hive": (icon: FontAwesomeIcons.hive, color: Color(0xFFFFC107)),
  "SQLite": (icon: FontAwesomeIcons.database, color: Color(0xFF607D8B)),
  "Firebase Firestore": (icon: FontAwesomeIcons.cloudArrowUp, color: Color(0xFFFF9800)),
  "Shared Preferences": (icon: FontAwesomeIcons.floppyDisk, color: Color(0xFF8BC34A)),

  // Tools
  "Android Studio": (icon: FontAwesomeIcons.android, color: Color(0xFF3DDC84)),
  "VS Code": (icon: FontAwesomeIcons.microsoft, color: Color(0xFF0078D7)),
  "Git": (icon: FontAwesomeIcons.gitAlt, color: Color(0xFFF05032)),
  "GitHub": (icon: FontAwesomeIcons.github, color: Color(0xFFFFFFFF)),
  "Figma": (icon: FontAwesomeIcons.figma, color: Color(0xFF00C4CC)),
  "Postman": (icon: FontAwesomeIcons.satellite, color: Color(0xFFFF6C37)),

  // CI/CD
  "Fastlane": (icon: FontAwesomeIcons.rocket, color: Color(0xFFE53935)),
  "GitHub Actions": (icon: FontAwesomeIcons.github, color: Color(0xFF24292E)),

  // UI/UX
  "Responsive Design": (icon: FontAwesomeIcons.mobileScreen, color: Color(0xFF26C6DA)),
  "Material Design": (icon: FontAwesomeIcons.google, color: Color(0xFF4285F4)),
  "Custom Paint": (icon: FontAwesomeIcons.paintbrush, color: Color(0xFFAB47BC)),
  "Custom Animations": (icon: FontAwesomeIcons.wandMagicSparkles, color: Color(0xFFFF4081)),
  "Hero Animations": (icon: FontAwesomeIcons.masksTheater, color: Color(0xFF00E5FF)),
  "Implicit & Explicit Animations": (
    icon: FontAwesomeIcons.film,
    color: Color(0xFFFFD740)
  ),

  // Integrations
  "Payment Gateway": (icon: FontAwesomeIcons.creditCard, color: Color(0xFF4CAF50)),
  "Push Notifications": (icon: FontAwesomeIcons.bell, color: Color(0xFFFF9800)),
  "Google Maps": (icon: FontAwesomeIcons.map, color: Color(0xFF34A853)),
  "Camera": (icon: FontAwesomeIcons.camera, color: Color(0xFF90A4AE)),
  "Location": (icon: FontAwesomeIcons.locationDot, color: Color(0xFFEF5350)),
  "Deep Linking": (icon: FontAwesomeIcons.link, color: Color(0xFF5C6BC0)),
  "Social Login": (icon: FontAwesomeIcons.userShield, color: Color(0xFF42A5F5)),

  // Payments
  "Stripe": (icon: FontAwesomeIcons.stripe, color: Color(0xFF6772E5)),
  "Paymob": (icon: FontAwesomeIcons.moneyBillWave, color: Color(0xFF00A86B)),
  "Razorpay": (icon: FontAwesomeIcons.rupeeSign, color: Color(0xFF2D81F7)),
  "In-App Purchases (IAP)": (icon: FontAwesomeIcons.bagShopping, color: Color(0xFFFF6F00)),

  // Node/Backend extras (used in projects)
  "Node.js": (icon: FontAwesomeIcons.nodeJs, color: Color(0xFF339933)),
  "Express": (icon: FontAwesomeIcons.server, color: Color(0xFF90A4AE)),
  "MongoDB": (icon: FontAwesomeIcons.leaf, color: Color(0xFF47A248)),
  "WebSockets": (icon: FontAwesomeIcons.wifi, color: Color(0xFF29B6F6)),
};

({IconData icon, Color color}) _iconFor(String name) =>
    _skillIcons[name] ?? (icon: FontAwesomeIcons.code, color: _kDefaultColor);

// ─────────────────────────────────────────────────────────────────────────────

class SkillsPage extends StatefulWidget {
  const SkillsPage({super.key});

  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = "All";
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredSkills() {
    final List<Map<String, dynamic>> allSkillsList = [];

    final Map<String, double> skillLevels = {
      "Flutter": 0.95,
      "Dart": 0.95,
      "React Native": 0.75,
      "Kotlin": 0.70,
      "Python": 0.85,
      "REST APIs": 0.90,
      "Firebase": 0.90,
      "Authentication": 0.88,
      "JSON": 0.95,
      "Clean Architecture": 0.95,
      "MVVM": 0.90,
      "Repository Pattern": 0.90,
      "Dependency Injection": 0.88,
      "GetX": 0.85,
      "Provider": 0.92,
      "BLoC": 0.90,
      "Hive": 0.85,
      "SQLite": 0.82,
      "Firebase Firestore": 0.90,
      "Shared Preferences": 0.95,
      "Android Studio": 0.90,
      "VS Code": 0.92,
      "Git": 0.88,
      "GitHub": 0.90,
      "Figma": 0.78,
      "Postman": 0.88,
      "Fastlane": 0.85,
      "GitHub Actions": 0.80,
      "Responsive Design": 0.95,
      "Material Design": 0.92,
      "Custom Paint": 0.85,
      "Custom Animations": 0.90,
      "Hero Animations": 0.92,
      "Implicit & Explicit Animations": 0.90,
      "Payment Gateway": 0.85,
      "Push Notifications": 0.88,
      "Google Maps": 0.85,
      "Camera": 0.80,
      "Location": 0.82,
      "Deep Linking": 0.85,
      "Social Login": 0.88,
      "Stripe": 0.85,
      "Paymob": 0.82,
      "Razorpay": 0.80,
      "In-App Purchases (IAP)": 0.85,
    };

    AppConstants.skills.forEach((category, list) {
      for (var skillName in list) {
        final level = skillLevels[skillName] ?? 0.80;
        allSkillsList.add({
          "name": skillName,
          "category": category,
          "level": level,
        });
      }
    });

    return allSkillsList.where((skill) {
      final matchesCategory =
          _selectedCategory == "All" || skill["category"] == _selectedCategory;
      final matchesSearch = skill["name"]
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 850;

    final categories = ["All", ...AppConstants.skills.keys];
    final filteredSkills = _getFilteredSkills();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SKILLS MATRIX",
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

              // Search & Filters
              isMobile
                  ? Column(
                      children: [
                        _buildSearchBar(context, isDark),
                        const SizedBox(height: 20),
                        _buildCategoryTabs(context, categories, isDark),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 3,
                            child: _buildSearchBar(context, isDark)),
                        const SizedBox(width: 32),
                        Expanded(
                            flex: 7,
                            child: _buildCategoryTabs(
                                context, categories, isDark)),
                      ],
                    ),

              const SizedBox(height: 48),

              // Skills Grid
              filteredSkills.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 80),
                        child: Text(
                          "No skills matching current criteria",
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final gridColumns =
                            width > 1000 ? 4 : (width > 700 ? 3 : 2);
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: gridColumns,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.35,
                          ),
                          itemCount: filteredSkills.length,
                          itemBuilder: (context, index) {
                            final skill = filteredSkills[index];
                            return SkillCard(
                              name: skill["name"] as String,
                              category: skill["category"] as String,
                              level: skill["level"] as double,
                              key: ValueKey(skill["name"]),
                            );
                          },
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    return TextField(
      controller: _searchController,
      onChanged: (val) => setState(() => _searchQuery = val),
      decoration: InputDecoration(
        hintText: "Search skills (e.g. BLoC, Firebase)...",
        prefixIcon:
            Icon(Icons.search, color: theme.iconTheme.color?.withOpacity(0.5)),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = "");
                },
              )
            : null,
      ),
    );
  }

  Widget _buildCategoryTabs(
      BuildContext context, List<String> categories, bool isDark) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: width > 850 ? 180 : 130,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: width > 850 ? 3.5 : 2.8,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        final isSelected = _selectedCategory == cat;

        return ChoiceChip(
          label: Center(
            child: Text(
              cat,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: width > 850 ? 12 : 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? (isDark ? Colors.black : Colors.white)
                    : (isDark ? Colors.white70 : Colors.black87),
              ),
            ),
          ),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) setState(() => _selectedCategory = cat);
          },
          selectedColor: theme.primaryColor,
          backgroundColor:
              isDark ? AppConstants.cardDark : AppConstants.cardLight,
          checkmarkColor: isDark ? Colors.black : Colors.white,
          showCheckmark: false,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected
                  ? theme.primaryColor
                  : (isDark
                      ? AppConstants.borderDark
                      : AppConstants.borderLight),
            ),
          ),
        );
      },
    );
  }
}

// ─── Skill Card ───────────────────────────────────────────────────────────────

class SkillCard extends StatefulWidget {
  final String name;
  final String category;
  final double level;

  const SkillCard({
    super.key,
    required this.name,
    required this.category,
    required this.level,
  });

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late final AnimationController _progressController;
  late final Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: widget.level)
        .chain(CurveTween(curve: Curves.easeOutCubic))
        .animate(_progressController);
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final skillMeta = _iconFor(widget.name);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? (_isHovered
                  ? Colors.white.withOpacity(0.03)
                  : AppConstants.cardDark)
              : (_isHovered
                  ? skillMeta.color.withOpacity(0.04)
                  : AppConstants.cardLight),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? skillMeta.color.withOpacity(0.6)
                : (isDark ? AppConstants.borderDark : AppConstants.borderLight),
            width: 1.2,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: skillMeta.color.withOpacity(0.15),
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
            // ── Icon + Name row ─────────────────────────────────────
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: skillMeta.color
                        .withOpacity(_isHovered ? 0.2 : 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: FaIcon(
                      skillMeta.icon,
                      size: 18,
                      color: skillMeta.color,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.category,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          color: isDark
                              ? Colors.white38
                              : Colors.black38,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ── Competency Progress ──────────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Competency",
                      style: theme.textTheme.bodySmall
                          ?.copyWith(fontSize: 10),
                    ),
                    Text(
                      "${(widget.level * 100).toInt()}%",
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: _isHovered ? skillMeta.color : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, _) {
                    return LinearProgressIndicator(
                      value: _progressAnimation.value,
                      minHeight: 4,
                      backgroundColor: isDark
                          ? Colors.white.withOpacity(0.06)
                          : Colors.black.withOpacity(0.06),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _isHovered
                            ? skillMeta.color
                            : skillMeta.color.withOpacity(0.7),
                      ),
                      borderRadius: BorderRadius.circular(2),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.95, 0.95));
  }
}
