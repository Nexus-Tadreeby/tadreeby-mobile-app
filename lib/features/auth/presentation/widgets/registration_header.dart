import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'registration_progress.dart';

class RegistrationHeader extends StatelessWidget {
  final int currentStep;
  final String stepTitle;
  final String stepDescription;

  const RegistrationHeader({
    super.key,
    required this.currentStep,
    required this.stepTitle,
    required this.stepDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Step Label ──────────────────────────────────────────
        Align(
          alignment: Alignment.center,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Step $currentStep of 3',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' – $stepTitle',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // ─── Description ──────────────────────────────────────────
        Align(
          alignment: Alignment.center,
          child: Text(
            stepDescription,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textGrey,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 17),

        // ─── Progress Steps ──────────────────────────────────────
        RegistrationProgress(currentStep: currentStep),
        const SizedBox(height: 24),
      ],
    );
  }
}