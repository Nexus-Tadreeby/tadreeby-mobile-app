// lib/core/widgets/custom_text_field.dart
import 'package:flutter/material.dart';
import 'package:tadreeby/core/theme/app_colors.dart';
import 'custom_label.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool isRequired;
  final bool showLabel;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final VoidCallback? onTap;
  final bool readOnly;
  
  final int? maxLength;           
  final bool showCounter;        
  final String? helperText;       
  final TextStyle? helperStyle;   
  final ValueChanged<String>? onChanged;
  
  final AutovalidateMode autovalidateMode;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.isRequired = false,
    this.showLabel = true,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.onTap,
    this.readOnly = false,
    this.maxLength,
    this.showCounter = true,
    this.helperText,
    this.helperStyle,
    this.onChanged,
    this.autovalidateMode = AutovalidateMode.onUserInteraction, 
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Label ─────────────────────────────────────────────
        if (showLabel) ...[
          CustomLabel(
            text: label,
            isRequired: isRequired,
          ),
          const SizedBox(height: 8),
        ],

        // ─── TextField ─────────────────────────────────────────
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLines: maxLines,
          minLines: minLines,
          enabled: enabled,
          onTap: onTap,
          readOnly: readOnly,
          maxLength: maxLength,
          onChanged: onChanged,
          autovalidateMode: autovalidateMode, 
          decoration: _buildDecoration(),
        ),
      ],
    );
  }

  // ─── Build Decoration ──────────────────────────────────────
  InputDecoration _buildDecoration() {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFFBDBDBD),
        fontSize: 13,
      ),
      prefixIcon: Icon(
        prefixIcon,
        color: AppColors.primaryBlue,
        size: 20,
      ),
      suffixIcon: suffixIcon,
      border: _outlineBorder(AppColors.borderGrey),
      enabledBorder: _outlineBorder(const Color(0xffC2DCFF)),
      focusedBorder: _outlineBorder(AppColors.primaryBlue),
      errorBorder: _outlineBorder(Colors.red),
      focusedErrorBorder: _outlineBorder(Colors.red),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 12,
      ),
      filled: true,
      fillColor: enabled ? Colors.white : Colors.grey.shade50,
      
      counterText: showCounter ? null : '',
      helperText: helperText,               
      helperStyle: helperStyle ?? const TextStyle(
        fontSize: 11,
        color: AppColors.textGrey,
      ),
      
      errorMaxLines: 2,
    );
  }

  // ─── Outline Border ────────────────────────────────────────
  OutlineInputBorder _outlineBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: color,
        width: 1.2,
      ),
    );
  }
}