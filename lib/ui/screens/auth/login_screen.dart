import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/theme_config.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

/// Login screen with email and password authentication
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authViewModel = context.read<AuthViewModel>();
    
    final success = await authViewModel.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      rememberMe: _rememberMe,
    );

    if (!mounted) return;

    if (success) {
      context.go('/dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authViewModel.errorMessage ?? 'Login failed'),
          backgroundColor: ThemeConfig.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(ThemeConfig.spacingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Demo Mode Banner
                Container(
                  padding: const EdgeInsets.all(ThemeConfig.spacingMedium),
                  decoration: BoxDecoration(
                    color: ThemeConfig.primaryPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(ThemeConfig.borderRadiusMedium),
                    border: Border.all(
                      color: ThemeConfig.primaryPurple.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: ThemeConfig.primaryPurple,
                        size: 20,
                      ),
                      const SizedBox(width: ThemeConfig.spacingSmall),
                      Expanded(
                        child: Text(
                          'Demo Mode: Use demo@example.com / demo123',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: ThemeConfig.primaryPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: ThemeConfig.spacingXLarge),
                
                // Logo
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: ThemeConfig.primaryGradient,
                      borderRadius: BorderRadius.circular(ThemeConfig.borderRadiusMedium),
                    ),
                    child: const Icon(
                      Icons.psychology_outlined,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
                
                const SizedBox(height: ThemeConfig.spacingLarge),
                
                // Welcome Text
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: ThemeConfig.spacingSmall),
                
                Text(
                  'Sign in to continue your mindful journey',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ThemeConfig.secondaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: ThemeConfig.spacingXLarge),
                
                // Email Field
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: ThemeConfig.spacingMedium),
                
                // Password Field
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_outlined,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: ThemeConfig.spacingMedium),
                
                // Remember Me Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                      activeColor: ThemeConfig.primaryPurple,
                    ),
                    Text(
                      'Remember me',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                
                const SizedBox(height: ThemeConfig.spacingLarge),
                
                // Login Button
                Consumer<AuthViewModel>(
                  builder: (context, authViewModel, _) {
                    return CustomButton(
                      text: 'Sign In',
                      onPressed: authViewModel.isLoading ? null : _handleLogin,
                      isLoading: authViewModel.isLoading,
                    );
                  },
                ),
                
                const SizedBox(height: ThemeConfig.spacingMedium),
                
                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        context.go('/register');
                      },
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
