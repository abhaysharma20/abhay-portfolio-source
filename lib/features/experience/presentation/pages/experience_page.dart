import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_constants.dart';

class ExperiencePage extends StatelessWidget {
  const ExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final isMobile = width < 850;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "EXPERIENCE TIMELINE",
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
                "Over 5 years of experience delivering robust mobile apps and backend components.",
                style: theme.textTheme.bodyLarge,
              ).animate().fadeIn(delay: 200.ms),
              
              const SizedBox(height: 60),

              // Vertical Timeline Construction
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: AppConstants.experience.length,
                itemBuilder: (context, index) {
                  final exp = AppConstants.experience[index];
                  return TimelineItem(
                    role: exp["role"] as String,
                    company: exp["company"] as String,
                    period: exp["period"] as String,
                    description: exp["description"] as String,
                    domains: exp["domains"] as List<String>,
                    points: exp["points"] as List<String>,
                    isLast: index == AppConstants.experience.length - 1,
                    index: index,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimelineItem extends StatefulWidget {
  final String role;
  final String company;
  final String period;
  final String description;
  final List<String> domains;
  final List<String> points;
  final bool isLast;
  final int index;

  const TimelineItem({
    super.key,
    required this.role,
    required this.company,
    required this.period,
    required this.description,
    required this.domains,
    required this.points,
    required this.isLast,
    required this.index,
  });

  @override
  State<TimelineItem> createState() => _TimelineItemState();
}

class _TimelineItemState extends State<TimelineItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 850;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left Period label (Desktop)
            if (!isMobile)
              SizedBox(
                width: 140,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, right: 24),
                  child: Text(
                    widget.period,
                    textAlign: TextAlign.right,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _isHovered ? theme.primaryColor : theme.textTheme.titleMedium?.color?.withOpacity(0.8),
                    ),
                  ),
                ),
              ),

            // Timeline line & nodes
            Column(
              children: [
                const SizedBox(height: 16),
                // Node
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _isHovered ? theme.primaryColor : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.primaryColor,
                      width: 3,
                    ),
                    boxShadow: _isHovered 
                        ? [
                            BoxShadow(
                              color: theme.primaryColor.withOpacity(0.4),
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ]
                        : [],
                  ),
                ),
                // Connection Line
                if (!widget.isLast)
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 2,
                      color: _isHovered 
                          ? theme.primaryColor.withOpacity(0.4)
                          : (isDark ? AppConstants.borderDark : AppConstants.borderLight),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 24),

            // Content Card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark 
                        ? (_isHovered ? Colors.white.withOpacity(0.02) : AppConstants.cardDark)
                        : (_isHovered ? Colors.black.withOpacity(0.01) : AppConstants.cardLight),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _isHovered 
                          ? theme.primaryColor.withOpacity(0.4)
                          : (isDark ? AppConstants.borderDark : AppConstants.borderLight),
                      width: 1.2,
                    ),
                    boxShadow: _isHovered 
                        ? [
                            BoxShadow(
                              color: theme.primaryColor.withOpacity(0.06),
                              blurRadius: 16,
                              spreadRadius: 1,
                            )
                          ]
                        : [],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Role & Period (Mobile)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.role,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _isHovered ? theme.primaryColor : null,
                              ),
                            ),
                          ),
                          if (isMobile)
                            Text(
                              widget.period,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.company,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.description,
                        style: theme.textTheme.bodyMedium,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Work Domains Tags
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.domains.map((domain) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: theme.primaryColor.withOpacity(0.12)),
                            ),
                            child: Text(
                              domain,
                              style: TextStyle(
                                fontSize: 11,
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 24),
                      const Divider(height: 1),
                      const SizedBox(height: 16),
                      
                      // Points Detail
                      ...widget.points.map((p) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 6, right: 12),
                                  child: Container(
                                    height: 5,
                                    width: 5,
                                    decoration: BoxDecoration(
                                      color: theme.primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    p,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (widget.index * 200).ms).slideY(begin: 0.1);
  }
}
