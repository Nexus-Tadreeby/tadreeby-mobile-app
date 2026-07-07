// lib/features/admin/presentation/widgets/university_stat_item.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class UniversityStatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final Color? iconColor;

  const UniversityStatItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon, 
          size: 18, 
          color: iconColor ?? AppColors.textGrey,
        ),
        const SizedBox(height: 4),
        Text(
          _formatValue(value),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }

  String _formatValue(int value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }
}