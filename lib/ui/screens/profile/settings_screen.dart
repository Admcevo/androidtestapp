import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/theme_config.dart';
import '../../../core/config/app_config.dart';
import '../../../core/services/storage_service.dart';
import '../../../viewmodels/theme_viewmodel.dart';
import '../../widgets/custom_text_field.dart';

/// Settings screen for app configuration
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _apiEndpointController = TextEditingController();
  bool _notificationsEnabled = true;
  bool _focusModeAutoStart = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _apiEndpointController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final endpoint = StorageService.instance.getApiEndpoint();
    setState(() {
      _apiEndpointController.text = endpoint;
    });
  }

  Future<void> _saveApiEndpoint() async {
    final endpoint = _apiEndpointController.text.trim();
    if (endpoint.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid API endpoint'),
          backgroundColor: ThemeConfig.errorColor,
        ),
      );
      return;
    }

    await StorageService.instance.saveApiEndpoint(endpoint);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('API endpoint updated successfully'),
          backgroundColor: ThemeConfig.successColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/profile'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ThemeConfig.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appearance Section
            Text(
              'Appearance',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: ThemeConfig.spacingMedium),
            
            Card(
              child: Column(
                children: [
                  Consumer<ThemeViewModel>(
                    builder: (context, themeViewModel, _) {
                      return Column(
                        children: [
                          RadioListTile<ThemeMode>(
                            title: const Text('Light Mode'),
                            value: ThemeMode.light,
                            groupValue: themeViewModel.themeMode,
                            onChanged: (value) {
                              if (value != null) {
                                themeViewModel.setThemeMode(value);
                              }
                            },
                            activeColor: ThemeConfig.primaryPurple,
                          ),
                          const Divider(height: 1),
                          RadioListTile<ThemeMode>(
                            title: const Text('Dark Mode'),
                            value: ThemeMode.dark,
                            groupValue: themeViewModel.themeMode,
                            onChanged: (value) {
                              if (value != null) {
                                themeViewModel.setThemeMode(value);
                              }
                            },
                            activeColor: ThemeConfig.primaryPurple,
                          ),
                          const Divider(height: 1),
                          RadioListTile<ThemeMode>(
                            title: const Text('System Default'),
                            value: ThemeMode.system,
                            groupValue: themeViewModel.themeMode,
                            onChanged: (value) {
                              if (value != null) {
                                themeViewModel.setThemeMode(value);
                              }
                            },
                            activeColor: ThemeConfig.primaryPurple,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: ThemeConfig.spacingLarge),
            
            // Notifications Section
            Text(
              'Notifications',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: ThemeConfig.spacingMedium),
            
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Enable Notifications'),
                    subtitle: const Text('Receive app notifications'),
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                    activeColor: ThemeConfig.primaryPurple,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Focus Mode Auto-Start'),
                    subtitle: const Text('Automatically start focus mode at scheduled times'),
                    value: _focusModeAutoStart,
                    onChanged: (value) {
                      setState(() {
                        _focusModeAutoStart = value;
                      });
                    },
                    activeColor: ThemeConfig.primaryPurple,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: ThemeConfig.spacingLarge),
            
            // API Configuration Section
            Text(
              'API Configuration',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: ThemeConfig.spacingMedium),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(ThemeConfig.spacingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'API Endpoint',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: ThemeConfig.spacingSmall),
                    Text(
                      'Configure the backend API endpoint for authentication and data sync',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ThemeConfig.secondaryText,
                      ),
                    ),
                    const SizedBox(height: ThemeConfig.spacingMedium),
                    TextField(
                      controller: _apiEndpointController,
                      decoration: InputDecoration(
                        hintText: 'http://localhost:3000/api',
                        prefixIcon: const Icon(Icons.link),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.save),
                          onPressed: _saveApiEndpoint,
                        ),
                      ),
                    ),
                    const SizedBox(height: ThemeConfig.spacingSmall),
                    Text(
                      'Current: ${AppConfig.baseUrl}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ThemeConfig.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: ThemeConfig.spacingLarge),
            
            // Data & Privacy Section
            Text(
              'Data & Privacy',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: ThemeConfig.spacingMedium),
            
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.download, color: ThemeConfig.primaryPurple),
                    title: const Text('Export Data'),
                    subtitle: const Text('Download your data'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Implement data export
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Data export coming soon')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.delete_forever, color: ThemeConfig.errorColor),
                    title: const Text('Clear All Data'),
                    subtitle: const Text('Remove all local data'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Clear All Data'),
                          content: const Text(
                            'This will remove all local data including settings and cached information. This action cannot be undone.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ThemeConfig.errorColor,
                              ),
                              child: const Text('Clear Data'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true && mounted) {
                        await StorageService.instance.clearAll();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('All data cleared successfully'),
                              backgroundColor: ThemeConfig.successColor,
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: ThemeConfig.spacingLarge),
            
            // App Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(ThemeConfig.spacingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'App Information',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: ThemeConfig.spacingMedium),
                    _buildInfoRow('Version', AppConfig.appVersion),
                    _buildInfoRow('App Name', AppConfig.appName),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: ThemeConfig.spacingSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: ThemeConfig.secondaryText,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
