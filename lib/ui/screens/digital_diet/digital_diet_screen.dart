import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/config/theme_config.dart';
import '../../../viewmodels/digital_diet_viewmodel.dart';
import '../../widgets/recommendation_card.dart';

/// Digital diet coach screen with analytics and recommendations
class DigitalDietScreen extends StatefulWidget {
  const DigitalDietScreen({super.key});

  @override
  State<DigitalDietScreen> createState() => _DigitalDietScreenState();
}

class _DigitalDietScreenState extends State<DigitalDietScreen> {
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DigitalDietViewModel>().loadWeeklySummary();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/notifications');
        break;
      case 2:
        // Digital Diet - already here
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Diet Coach'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: Consumer<DigitalDietViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: viewModel.refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(ThemeConfig.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Weekly Summary Card
                  if (viewModel.weeklySummary != null)
                    _buildWeeklySummaryCard(context, viewModel),
                  
                  const SizedBox(height: ThemeConfig.spacingLarge),
                  
                  // Screen Time Chart
                  Text(
                    'Weekly Screen Time',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  
                  const SizedBox(height: ThemeConfig.spacingMedium),
                  
                  if (viewModel.weeklyScreenTime.isNotEmpty)
                    _buildScreenTimeChart(context, viewModel),
                  
                  const SizedBox(height: ThemeConfig.spacingLarge),
                  
                  // Recommendations
                  Text(
                    'Personalized Recommendations',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  
                  const SizedBox(height: ThemeConfig.spacingMedium),
                  
                  if (viewModel.recommendations.isEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(ThemeConfig.spacingLarge),
                        child: Center(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                size: 48,
                                color: ThemeConfig.successColor,
                              ),
                              const SizedBox(height: ThemeConfig.spacingMedium),
                              Text(
                                'You\'re doing great! No recommendations at the moment.',
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    ...viewModel.recommendations.map((recommendation) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: ThemeConfig.spacingMedium),
                        child: RecommendationCard(
                          recommendation: recommendation,
                          onComplete: () {
                            viewModel.completeRecommendation(recommendation.id);
                          },
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: ThemeConfig.primaryPurple,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklySummaryCard(BuildContext context, DigitalDietViewModel viewModel) {
    final summary = viewModel.weeklySummary!;
    final trend = viewModel.getScreenTimeTrend();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConfig.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This Week\'s Overview',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: ThemeConfig.spacingLarge),
            
            // Stats Grid
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    context,
                    'Total Screen Time',
                    summary.formattedTotalScreenTime,
                    Icons.phone_android,
                    _getTrendColor(trend),
                  ),
                ),
                const SizedBox(width: ThemeConfig.spacingMedium),
                Expanded(
                  child: _buildSummaryItem(
                    context,
                    'Daily Average',
                    summary.formattedAverageDailyScreenTime,
                    Icons.today,
                    ThemeConfig.infoColor,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: ThemeConfig.spacingMedium),
            
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    context,
                    'Notifications',
                    '${summary.totalNotifications}',
                    Icons.notifications_outlined,
                    ThemeConfig.warningColor,
                  ),
                ),
                const SizedBox(width: ThemeConfig.spacingMedium),
                Expanded(
                  child: _buildSummaryItem(
                    context,
                    'Focus Sessions',
                    '${summary.totalFocusSessions}',
                    Icons.psychology_outlined,
                    ThemeConfig.successColor,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: ThemeConfig.spacingLarge),
            
            // Trend indicator
            Container(
              padding: const EdgeInsets.all(ThemeConfig.spacingMedium),
              decoration: BoxDecoration(
                color: _getTrendColor(trend).withOpacity(0.1),
                borderRadius: BorderRadius.circular(ThemeConfig.borderRadiusSmall),
              ),
              child: Row(
                children: [
                  Icon(_getTrendIcon(trend), color: _getTrendColor(trend)),
                  const SizedBox(width: ThemeConfig.spacingSmall),
                  Text(
                    _getTrendText(trend),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _getTrendColor(trend),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: ThemeConfig.spacingSmall),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: ThemeConfig.secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildScreenTimeChart(BuildContext context, DigitalDietViewModel viewModel) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConfig.spacingLarge),
        child: SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: viewModel.weeklyScreenTime
                  .map((e) => e.totalMinutes.toDouble())
                  .reduce((a, b) => a > b ? a : b) * 1.2,
              barTouchData: BarTouchData(enabled: true),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                      return Text(
                        days[value.toInt() % 7],
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${(value / 60).toInt()}h',
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 60,
              ),
              borderData: FlBorderData(show: false),
              barGroups: viewModel.weeklyScreenTime.asMap().entries.map((entry) {
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value.totalMinutes.toDouble(),
                      color: ThemeConfig.primaryPurple,
                      width: 16,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Color _getTrendColor(String trend) {
    switch (trend) {
      case 'increasing':
        return ThemeConfig.errorColor;
      case 'decreasing':
        return ThemeConfig.successColor;
      default:
        return ThemeConfig.infoColor;
    }
  }

  IconData _getTrendIcon(String trend) {
    switch (trend) {
      case 'increasing':
        return Icons.trending_up;
      case 'decreasing':
        return Icons.trending_down;
      default:
        return Icons.trending_flat;
    }
  }

  String _getTrendText(String trend) {
    switch (trend) {
      case 'increasing':
        return 'Screen time is increasing this week';
      case 'decreasing':
        return 'Great! Screen time is decreasing';
      default:
        return 'Screen time is stable this week';
    }
  }
}
