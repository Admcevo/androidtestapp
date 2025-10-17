import 'package:flutter/material.dart';
import '../../core/config/theme_config.dart';
import '../../models/digital_diet_model.dart';

/// Card widget for displaying recommendations
class RecommendationCard extends StatelessWidget {
  final DigitalDietRecommendation recommendation;
  final VoidCallback? onComplete;
  final VoidCallback? onDismiss;

  const RecommendationCard({
    super.key,
    required this.recommendation,
    this.onComplete,
    this.onDismiss,
  });

  Color _getPriorityColor() {
    if (recommendation.priority >= 4) return ThemeConfig.errorColor;
    if (recommendation.priority >= 3) return ThemeConfig.warningColor;
    return ThemeConfig.infoColor;
  }

  @override
  Widget build(BuildContext context) {
    final priorityColor = _getPriorityColor();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConfig.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(ThemeConfig.borderRadiusSmall),
                  ),
                  child: Center(
                    child: Text(
                      recommendation.categoryIcon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: ThemeConfig.spacingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recommendation.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: ThemeConfig.spacingXSmall),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: priorityColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _getPriorityText(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: priorityColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: ThemeConfig.spacingMedium),
            
            Text(
              recommendation.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ThemeConfig.secondaryText,
              ),
            ),
            
            if (onComplete != null || onDismiss != null) ...[
              const SizedBox(height: ThemeConfig.spacingMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onDismiss != null)
                    TextButton(
                      onPressed: onDismiss,
                      child: const Text('Dismiss'),
                    ),
                  if (onComplete != null) ...[
                    const SizedBox(width: ThemeConfig.spacingSmall),
                    ElevatedButton(
                      onPressed: onComplete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeConfig.primaryPurple,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text('Complete'),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getPriorityText() {
    if (recommendation.priority >= 4) return 'High Priority';
    if (recommendation.priority >= 3) return 'Medium Priority';
    return 'Low Priority';
  }
}
