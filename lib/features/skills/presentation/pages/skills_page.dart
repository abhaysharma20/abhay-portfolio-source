import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_constants.dart';

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

  // Generate skills with competency mapping (mock levels for aesthetic detail)
  List<Map<String, dynamic>> _getFilteredSkills() {
    final List<Map<String, dynamic>> allSkillsList = [];

    // Map competency levels to mock progress values
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
      "Social Login": 0.88
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
    final size = MediaQuery.of(context).size;
    final width = size.width;
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

              // Search & Filters Panel
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
                            flex: 3, child: _buildSearchBar(context, isDark)),
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
                            childAspectRatio: 1.5,
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
      onChanged: (val) {
        setState(() {
          _searchQuery = val;
        });
      },
      decoration: InputDecoration(
        hintText: "Search skills (e.g. BLoC, FastAPI)...",
        prefixIcon:
            Icon(Icons.search, color: theme.iconTheme.color?.withOpacity(0.5)),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = "";
                  });
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
            if (selected) {
              setState(() {
                _selectedCategory = cat;
              });
            }
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
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

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

    // Start progress animation
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

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? (_isHovered
                  ? Colors.white.withOpacity(0.02)
                  : AppConstants.cardDark)
              : (_isHovered
                  ? Colors.black.withOpacity(0.01)
                  : AppConstants.cardLight),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? theme.primaryColor.withOpacity(0.5)
                : (isDark ? AppConstants.borderDark : AppConstants.borderLight),
            width: 1.2,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(0.06),
                    blurRadius: 12,
                    spreadRadius: 1,
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.category,
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),

            // Animated Progress Indicator
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Competency",
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                    ),
                    Text(
                      "${(widget.level * 100).toInt()}%",
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: _isHovered ? theme.primaryColor : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: _progressAnimation.value,
                      minHeight: 4,
                      backgroundColor: isDark
                          ? Colors.white.withOpacity(0.06)
                          : Colors.black.withOpacity(0.06),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _isHovered
                            ? theme.primaryColor
                            : theme.primaryColor.withOpacity(0.85),
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
