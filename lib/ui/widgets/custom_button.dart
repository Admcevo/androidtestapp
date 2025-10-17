import 'package:flutter/material.dart';
import '../../core/config/theme_config.dart';

/// Custom button widget with gradient and loading state
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConfig.borderRadiusMedium),
          ),
          side: const BorderSide(color: ThemeConfig.primaryPurple, width: 2),
        ),
        child: _buildButtonChild(context, ThemeConfig.primaryPurple),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: backgroundColor == null ? ThemeConfig.primaryGradient : null,
        color: backgroundColor,
        borderRadius: BorderRadius.circular(ThemeConfig.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: ThemeConfig.primaryPurple.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConfig.borderRadiusMedium),
          ),
        ),
        child: _buildButtonChild(context, textColor ?? Colors.white),
      ),
    );
  }

  Widget _buildButtonChild(BuildContext context, Color color) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: ThemeConfig.spacingSmall),
          Text(
            text,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: color,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: color,
      ),
    );
  }
}
