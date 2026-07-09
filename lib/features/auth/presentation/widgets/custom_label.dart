// lib/core/widgets/custom_label.dart
import 'package:flutter/material.dart';
import 'package:tadreeby/core/theme/app_colors.dart';

class CustomLabel extends StatelessWidget {
  final String text;          
  final bool isRequired;
  final double fontSize;
  final FontWeight fontWeight;

  const CustomLabel({
    super.key,
    required this.text,        
    this.isRequired = false,
    this.fontSize = 14,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            fontWeight: fontWeight,
            fontSize: fontSize,
            color: AppColors.textDark,
          ),
        ),
        if (isRequired) ...[
          const SizedBox(width: 4),
          const Text(
            '*',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ],
    );
  }
}