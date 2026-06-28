import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  String _selectedFilter = "All";

  List<Map<String, dynamic>> _getFilteredProjects() {
    if (_selectedFilter == "All") {
      return AppConstants.projects;
    }
    return AppConstants.projects.where((project) {
      final list = project["tech"] as List<String>;
      return list.contains(_selectedFilter);
    }).toList();
  }

  // Get all unique technology tags across projects
  List<String> _getFilterOptions() {
    final Set<String> tags = {"All"};
    for (var project in AppConstants.projects) {
      final list = project["tech"] as List<String>;
      tags.addAll(list);
    }
    return tags.toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final isMobile = width < 850;

    final filteredProjects = _getFilteredProjects();
    final filterOptions = _getFilterOptions();

    // Split journaling (highlighted) and others
    final highlightedProject =
        AppConstants.projects.firstWhere((p) => p["id"] == "journaling");
    final otherProjects =
        filteredProjects.where((p) => p["id"] != "journaling").toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "PROJECT SHOWCASE",
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
                "A curated display of production systems, custom engines, and mobile designs.",
                style: theme.textTheme.bodyLarge,
              ),

              const SizedBox(height: 48),

              // Filter Chips Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2.8,
                ),
                itemCount: filterOptions.length,
                itemBuilder: (context, index) {
                  final option = filterOptions[index];
                  final isSelected = _selectedFilter == option;
                  return ChoiceChip(
                    label: Center(
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? (isDark ? Colors.black : Colors.white)
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: theme.primaryColor,
                    checkmarkColor: Colors.transparent,
                    showCheckmark: false,
                    backgroundColor: isDark
                        ? AppConstants.cardDark
                        : AppConstants.cardLight,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedFilter = option;
                        });
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
              ),

              const SizedBox(height: 40),

              // Highlighted Project - Digital Journaling Platform (Always shown first if filter fits)
              if (_selectedFilter == "All" ||
                  (highlightedProject["tech"] as List<String>)
                      .contains(_selectedFilter)) ...[
                _buildHighlightedBanner(
                    context, highlightedProject, isDark, isMobile),
                const SizedBox(height: 40),
              ],

              // Others Grid
              otherProjects.isEmpty &&
                      (_selectedFilter != "All" &&
                          !(highlightedProject["tech"] as List<String>)
                              .contains(_selectedFilter))
                  ? const SizedBox(
                      height: 200,
                      child: Center(
                          child: Text("No other projects match this filter.")),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final gridColumns = width > 900 ? 2 : 1;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: gridColumns,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: gridColumns == 2 ? 1.4 : 1.6,
                          ),
                          itemCount: otherProjects.length,
                          itemBuilder: (context, index) {
                            final proj = otherProjects[index];
                            return ProjectCard(
                              title: proj["title"] as String,
                              desc: proj["desc"] as String,
                              tech: proj["tech"] as List<String>,
                              features: proj["features"] as List<String>,
                              isDark: isDark,
                              key: ValueKey(proj["title"]),
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

  Widget _buildHighlightedBanner(
    BuildContext context,
    Map<String, dynamic> project,
    bool isDark,
    bool isMobile,
  ) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppConstants.cardDark : AppConstants.cardLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.primaryColor.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.04),
            blurRadius: 20,
            spreadRadius: 2,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Decorative background glowing circle
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColor.withOpacity(0.04),
                      blurRadius: 50,
                      spreadRadius: 50,
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Highlight Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.primaryColor,
                          theme.colorScheme.secondary
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.black, size: 14),
                        SizedBox(width: 6),
                        Text(
                          "MOST RECENT PROJECT",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title & Desc
                  Text(
                    project["title"] as String,
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 24 : 32,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    project["desc"] as String,
                    style: theme.textTheme.bodyLarge,
                  ),

                  const SizedBox(height: 24),

                  // Key tech tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (project["tech"] as List<String>).map((t) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: theme.primaryColor.withOpacity(0.12)),
                        ),
                        child: Text(
                          t,
                          style: TextStyle(
                              fontSize: 12,
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),
                  const Divider(height: 1),
                  const SizedBox(height: 24),

                  // CTA to open editor demonstration
                  ElevatedButton(
                    onPressed: () => _openEditorDemoDialog(context, project),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit_note),
                        SizedBox(width: 10),
                        Text("Explore Editor Sample",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  // Navigate to the editor screen as a top-level route to avoid focus-trapping issues on web dialogs
  void _openEditorDemoDialog(
      BuildContext context, Map<String, dynamic> project) {
    context.push('/editor');
  }
}

class ProjectCard extends StatefulWidget {
  final String title;
  final String desc;
  final List<String> tech;
  final List<String> features;
  final bool isDark;

  const ProjectCard({
    super.key,
    required this.title,
    required this.desc,
    required this.tech,
    required this.features,
    required this.isDark,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;

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
              ? (_isHovered
                  ? Colors.white.withOpacity(0.02)
                  : AppConstants.cardDark)
              : (_isHovered
                  ? Colors.black.withOpacity(0.01)
                  : AppConstants.cardLight),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered
                ? theme.primaryColor.withOpacity(0.5)
                : (widget.isDark
                    ? AppConstants.borderDark
                    : AppConstants.borderLight),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.desc,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),

            // Features bullet highlight overview
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: widget.tech.map((t) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: theme.primaryColor.withOpacity(0.1)),
                      ),
                      child: Text(
                        t,
                        style: TextStyle(
                            fontSize: 10,
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.98, 0.98));
  }
}

// Widget representing the interactive editor pop-up
class InteractiveEditorShowcase extends StatefulWidget {
  final Map<String, dynamic> project;
  const InteractiveEditorShowcase({super.key, required this.project});

  @override
  State<InteractiveEditorShowcase> createState() =>
      _InteractiveEditorShowcaseState();
}

class _InteractiveEditorShowcaseState extends State<InteractiveEditorShowcase> {
  final TextEditingController _editorController = TextEditingController(
      text:
          "Welcome to my digital journaling environment! This interactive panel represents a custom WYSIWYG markdown block parser built on Flutter.\n\nHighlight text and toggle headers or styles to test the reactive UI!");

  bool _isBold = false;
  bool _isItalic = false;
  String _editorStatus = "Autosaved draft to Hive cache";

  @override
  void dispose() {
    _editorController.dispose();
    super.dispose();
  }

  void _triggerAutosave() {
    setState(() {
      _editorStatus = "Saving...";
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _editorStatus = "Sync queue synced to Cloud Firestore";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Digital Journaling Platform",
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 22),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text("Technical Challenge Details & Mock Editor Sandbox"),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Scrollable technical descriptions
          Expanded(
            child: ListView(
              children: [
                Text(
                  "Architectural Breakdown",
                  style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold, color: theme.primaryColor),
                ),
                const SizedBox(height: 8),
                const Text(
                  "This editor parses paragraph elements into atomic styling blocks (Node trees) and maps HTML inputs directly to Flutter native canvas nodes, resolving performance sluggishness common in web views.\n"
                  "Includes Hive caching for local offline changes and uses SQLite transactions to queue synchronization requests when network connectivity is variable.",
                  style: TextStyle(height: 1.4, fontSize: 13),
                ),
                const SizedBox(height: 24),

                // Sandbox Title
                Text(
                  "Interactive Rich-Text Sandbox",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text("Simulate the formatting toolbar features below:",
                    style: theme.textTheme.bodySmall),
                const SizedBox(height: 12),

                // Mock formatting toolbar
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.03)
                        : Colors.black.withOpacity(0.03),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    border: Border.all(
                        color: isDark
                            ? AppConstants.borderDark
                            : AppConstants.borderLight),
                  ),
                  child: Row(
                    children: [
                      _toolbarToggleButton(
                        icon: Icons.format_bold,
                        isActive: _isBold,
                        onPressed: () {
                          setState(() => _isBold = !_isBold);
                          _triggerAutosave();
                        },
                        tooltip: "Bold",
                      ),
                      _toolbarToggleButton(
                        icon: Icons.format_italic,
                        isActive: _isItalic,
                        onPressed: () {
                          setState(() => _isItalic = !_isItalic);
                          _triggerAutosave();
                        },
                        tooltip: "Italic",
                      ),
                      const VerticalDivider(width: 20, thickness: 1),
                      _toolbarActionButton(
                        icon: Icons.image_outlined,
                        onPressed: () {
                          _editorController.text +=
                              "\n[Inserted Embedded Media Block]";
                          _triggerAutosave();
                        },
                        tooltip: "Insert Media",
                      ),
                      _toolbarActionButton(
                        icon: Icons.link_outlined,
                        onPressed: () {
                          _editorController.text +=
                              "\n[link:https://github.com/abhay]";
                          _triggerAutosave();
                        },
                        tooltip: "Add Link",
                      ),
                      const Spacer(),
                      // Status dot
                      Row(
                        children: [
                          Container(
                            height: 6,
                            width: 6,
                            decoration: BoxDecoration(
                              color: _editorStatus.contains("queue")
                                  ? Colors.green
                                  : Colors.amber,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _editorStatus,
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Sandbox editing text canvas
                Container(
                  padding: const EdgeInsets.all(16),
                  height: 160,
                  decoration: BoxDecoration(
                    color:
                        isDark ? AppConstants.cardDark : AppConstants.cardLight,
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(12)),
                    border: Border(
                      left: BorderSide(
                          color: isDark
                              ? AppConstants.borderDark
                              : AppConstants.borderLight),
                      right: BorderSide(
                          color: isDark
                              ? AppConstants.borderDark
                              : AppConstants.borderLight),
                      bottom: BorderSide(
                          color: isDark
                              ? AppConstants.borderDark
                              : AppConstants.borderLight),
                    ),
                  ),
                  child: TextField(
                    controller: _editorController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      fillColor: Colors.transparent,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: TextStyle(
                      fontStyle:
                          _isItalic ? FontStyle.italic : FontStyle.normal,
                      fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toolbarToggleButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    final theme = Theme.of(context);
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon,
            color: isActive
                ? theme.primaryColor
                : theme.iconTheme.color?.withOpacity(0.6)),
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: isActive
              ? theme.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }

  Widget _toolbarActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    final theme = Theme.of(context);
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, color: theme.iconTheme.color?.withOpacity(0.6)),
        onPressed: onPressed,
      ),
    );
  }
}
