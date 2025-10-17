import 'package:flutter/material.dart';
import '../../core/config/theme_config.dart';
import '../../models/cognitive_load_model.dart';

/// Card widget displaying cognitive load score
class CognitiveLoadCard extends StatelessWidget {
  final CognitiveLoadModel cognitiveLoad;

  const CognitiveLoadCard({
    super.key,
    required this.cognitiveLoad,
  });

  Color _getLoadColor() {
    if (cognitiveLoad.loadScore < 30) return ThemeConfig.successColor;
    if (cognitiveLoad.loadScore < 60) return ThemeConfig.infoColor;
    if (cognitiveLoad.loadScore < 80) return ThemeConfig.warningColor;
    return ThemeConfig.errorColor;
  }

  @override
  Widget build(BuildContext context) {
    final loadColor = _getLoadColor();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConfig.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cognitive Load',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: loadColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(ThemeConfig.borderRadiusSmall),
                  ),
                  child: Text(
                    cognitiveLoad.loadLevel,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: loadColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: ThemeConfig.spacingLarge),
            
            // Circular progress indicator
            Center(
              child: SizedBox(
                width: 150,
                height: 150,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: CircularProgressIndicator(
                        value: cognitiveLoad.loadScore / 100,
                        strokeWidth: 12,
                        backgroundColor: loadColor.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(loadColor),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${cognitiveLoad.loadScore}',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: loadColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Score',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ThemeConfig.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: ThemeConfig.spacingLarge),
            
            // Load factors
            Text(
              'Contributing Factors',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: ThemeConfig.spacingMedium),
            
            ...cognitiveLoad.factors.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: ThemeConfig.spacingSmall),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _formatFactorName(entry.key),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: LinearProgressIndicator(
                        value: (entry.value as num).toDouble() / 100,
                        backgroundColor: ThemeConfig.primaryPurple.withOpacity(0.1),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          ThemeConfig.primaryPurple,
                        ),
                      ),
                    ),
                    const SizedBox(width: ThemeConfig.spacingSmall),
                    Text(
                      '${entry.value}%',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  String _formatFactorName(String name) {
    return name
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}')
        .trim()
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
