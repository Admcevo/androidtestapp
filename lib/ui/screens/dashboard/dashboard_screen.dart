import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/theme_config.dart';
import '../../../viewmodels/dashboard_viewmodel.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../widgets/cognitive_load_card.dart';
import '../../widgets/recommendation_card.dart';

/// Main dashboard screen showing cognitive load and recommendations
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardViewModel>().loadDashboardData();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Dashboard - already here
        break;
      case 1:
        context.go('/notifications');
        break;
      case 2:
        context.go('/digital-diet');
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
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: Consumer<DashboardViewModel>(
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
                  // Welcome message
                  Consumer<AuthViewModel>(
                    builder: (context, authViewModel, _) {
                      return Text(
                        'Welcome back, ${authViewModel.currentUser?.name ?? "User"}!',
                        style: Theme.of(context).textTheme.displaySmall,
                      );
                    },
                  ),
                  
                  const SizedBox(height: ThemeConfig.spacingSmall),
                  
                  Text(
                    'Here\'s your cognitive load overview',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: ThemeConfig.secondaryText,
                    ),
                  ),
                  
                  const SizedBox(height: ThemeConfig.spacingLarge),
                  
                  // Quick stats
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Screen Time',
                          '${viewModel.todayScreenTime ~/ 60}h ${viewModel.todayScreenTime % 60}m',
                          Icons.phone_android,
                          ThemeConfig.infoColor,
                        ),
                      ),
                      const SizedBox(width: ThemeConfig.spacingMedium),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Notifications',
                          '${viewModel.todayNotificationCount}',
                          Icons.notifications_outlined,
                          ThemeConfig.warningColor,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: ThemeConfig.spacingLarge),
                  
                  // Cognitive load card
                  if (viewModel.currentCognitiveLoad != null)
                    CognitiveLoadCard(
                      cognitiveLoad: viewModel.currentCognitiveLoad!,
                    ),
                  
                  const SizedBox(height: ThemeConfig.spacingLarge),
                  
                  // Focus session card
                  if (viewModel.activeFocusSession != null)
                    _buildActiveFocusCard(context, viewModel)
                  else
                    _buildStartFocusCard(context, viewModel),
                  
                  const SizedBox(height: ThemeConfig.spacingLarge),
                  
                  // Today's recommendations
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today\'s Recommendations',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      TextButton(
                        onPressed: () => context.go('/digital-diet'),
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: ThemeConfig.spacingMedium),
                  
                  if (viewModel.todayRecommendations.isEmpty)
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
                                'Great job! No recommendations for now.',
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    ...viewModel.todayRecommendations.map((recommendation) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: ThemeConfig.spacingMedium),
                        child: RecommendationCard(
                          recommendation: recommendation,
                          onComplete: () {
                            viewModel.completeRecommendation(recommendation.id);
                          },
                        ),
                      );
                    }),
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

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConfig.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: ThemeConfig.spacingSmall),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ThemeConfig.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartFocusCard(BuildContext context, DashboardViewModel viewModel) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConfig.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.psychology_outlined,
                  color: ThemeConfig.primaryPurple,
                  size: 32,
                ),
                const SizedBox(width: ThemeConfig.spacingMedium),
                Expanded(
                  child: Text(
                    'Start a Focus Session',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: ThemeConfig.spacingMedium),
            Text(
              'Minimize distractions and boost your productivity',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ThemeConfig.secondaryText,
              ),
            ),
            const SizedBox(height: ThemeConfig.spacingLarge),
            Wrap(
              spacing: ThemeConfig.spacingSmall,
              runSpacing: ThemeConfig.spacingSmall,
              children: [15, 25, 45, 60].map((duration) {
                return ElevatedButton(
                  onPressed: () => viewModel.startFocusSession(duration),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeConfig.primaryPurple.withOpacity(0.1),
                    foregroundColor: ThemeConfig.primaryPurple,
                    elevation: 0,
                  ),
                  child: Text('$duration min'),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFocusCard(BuildContext context, DashboardViewModel viewModel) {
    final session = viewModel.activeFocusSession!;
    final remaining = session.remainingMinutes ?? 0;

    return Card(
      color: ThemeConfig.primaryPurple.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(ThemeConfig.spacingLarge),
        child: Column(
          children: [
            const Icon(
              Icons.psychology,
              color: ThemeConfig.primaryPurple,
              size: 48,
            ),
            const SizedBox(height: ThemeConfig.spacingMedium),
            Text(
              'Focus Mode Active',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: ThemeConfig.primaryPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: ThemeConfig.spacingSmall),
            Text(
              '$remaining minutes remaining',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: ThemeConfig.spacingLarge),
            ElevatedButton(
              onPressed: () => viewModel.endFocusSession(),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeConfig.errorColor,
              ),
              child: const Text('End Session'),
            ),
          ],
        ),
      ),
    );
  }
}
