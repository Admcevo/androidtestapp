import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/theme_config.dart';
import '../../../core/config/app_config.dart';
import '../../../viewmodels/notification_viewmodel.dart';
import 'package:intl/intl.dart';

/// Notification management screen with filtering options
class NotificationManagementScreen extends StatefulWidget {
  const NotificationManagementScreen({super.key});

  @override
  State<NotificationManagementScreen> createState() => _NotificationManagementScreenState();
}

class _NotificationManagementScreenState extends State<NotificationManagementScreen> {
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationViewModel>().loadNotifications();
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
        // Notifications - already here
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
        title: const Text('Notification Management'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: Consumer<NotificationViewModel>(
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
                  // Statistics Card
                  if (viewModel.stats != null) _buildStatsCard(context, viewModel),
                  
                  const SizedBox(height: ThemeConfig.spacingLarge),
                  
                  // Category Filters
                  Text(
                    'Filter by Category',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  
                  const SizedBox(height: ThemeConfig.spacingMedium),
                  
                  _buildCategoryFilters(context, viewModel),
                  
                  const SizedBox(height: ThemeConfig.spacingLarge),
                  
                  // Recent Notifications
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Notifications',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        '${viewModel.getFilteredNotifications().length} active',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ThemeConfig.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: ThemeConfig.spacingMedium),
                  
                  if (viewModel.notifications.isEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(ThemeConfig.spacingLarge),
                        child: Center(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.notifications_off_outlined,
                                size: 48,
                                color: ThemeConfig.secondaryText,
                              ),
                              const SizedBox(height: ThemeConfig.spacingMedium),
                              Text(
                                'No notifications yet',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    ...viewModel.notifications.map((notification) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: ThemeConfig.spacingMedium),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: notification.isFiltered
                                ? ThemeConfig.secondaryText.withOpacity(0.2)
                                : ThemeConfig.primaryPurple.withOpacity(0.2),
                            child: Icon(
                              _getCategoryIcon(notification.category),
                              color: notification.isFiltered
                                  ? ThemeConfig.secondaryText
                                  : ThemeConfig.primaryPurple,
                            ),
                          ),
                          title: Text(
                            notification.title,
                            style: TextStyle(
                              decoration: notification.isFiltered
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (notification.body != null)
                                Text(
                                  notification.body!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    notification.appName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const Text(' • '),
                                  Text(
                                    _formatTime(notification.timestamp),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: notification.isFiltered
                              ? const Icon(Icons.block, color: ThemeConfig.errorColor)
                              : null,
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

  Widget _buildStatsCard(BuildContext context, NotificationViewModel viewModel) {
    final stats = viewModel.stats!;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConfig.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Statistics',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: ThemeConfig.spacingLarge),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Total',
                    '${stats.totalCount}',
                    ThemeConfig.infoColor,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Filtered',
                    '${stats.filteredCount}',
                    ThemeConfig.errorColor,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Allowed',
                    '${stats.allowedCount}',
                    ThemeConfig.successColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: ThemeConfig.spacingMedium),
            LinearProgressIndicator(
              value: stats.filterRate / 100,
              backgroundColor: ThemeConfig.successColor.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(ThemeConfig.errorColor),
            ),
            const SizedBox(height: ThemeConfig.spacingSmall),
            Text(
              '${stats.filterRate.toStringAsFixed(1)}% of notifications filtered',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildCategoryFilters(BuildContext context, NotificationViewModel viewModel) {
    return Wrap(
      spacing: ThemeConfig.spacingSmall,
      runSpacing: ThemeConfig.spacingSmall,
      children: AppConfig.notificationCategories.map((category) {
        final isFiltered = viewModel.categoryFilters[category] ?? false;
        
        return FilterChip(
          label: Text(category),
          selected: isFiltered,
          onSelected: (selected) {
            viewModel.toggleCategoryFilter(category);
          },
          selectedColor: ThemeConfig.errorColor.withOpacity(0.2),
          checkmarkColor: ThemeConfig.errorColor,
          avatar: isFiltered ? const Icon(Icons.block, size: 16) : null,
        );
      }).toList(),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Work':
        return Icons.work_outline;
      case 'Social':
        return Icons.people_outline;
      case 'Entertainment':
        return Icons.movie_outlined;
      case 'News':
        return Icons.newspaper_outlined;
      case 'Shopping':
        return Icons.shopping_bag_outlined;
      case 'Health':
        return Icons.favorite_outline;
      default:
        return Icons.notifications_outlined;
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat('MMM d, HH:mm').format(timestamp);
    }
  }
}
