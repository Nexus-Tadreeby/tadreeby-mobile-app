import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

enum StepStatus {
  done, 
  active, 
  inactive,
}

class RegistrationProgress extends StatelessWidget {
  final int currentStep; // 1, 2, أو 3

  const RegistrationProgress({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildStep(
          number: 1,
          label: 'Basic Info',
          status: _getStepStatus(1),
        ),
        _buildConnector(isActive: currentStep > 1),
        _buildStep(
          number: 2,
          label: 'Academic',
          status: _getStepStatus(2),
        ),
        _buildConnector(isActive: currentStep > 2),
        _buildStep(
          number: 3,
          label: 'Verification',
          status: _getStepStatus(3),
        ),
      ],
    );
  }

  StepStatus _getStepStatus(int stepNumber) {
    if (stepNumber < currentStep) {
      return StepStatus.done; 
    } else if (stepNumber == currentStep) {
      return StepStatus.active; 
    } else {
      return StepStatus.inactive;
    }
  }

  Widget _buildStep({
    required int number,
    required String label,
    required StepStatus status,
  }) {
    Widget icon;
    Color labelColor;

    switch (status) {
      case StepStatus.done:
        icon = Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            color: AppColors.successGreen,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 18),
        );
        labelColor = AppColors.successGreen;
        break;

      case StepStatus.active:
        icon = Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            color: AppColors.primaryBlue,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        );
        labelColor = AppColors.primaryBlue;
        break;

      case StepStatus.inactive:
        icon = Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.borderGrey, width: 1.5),
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: const TextStyle(
                color: AppColors.textGrey,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        );
        labelColor = AppColors.textGrey;
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: labelColor,
            fontWeight: status == StepStatus.inactive
                ? FontWeight.normal
                : FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildConnector({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        color: isActive ? AppColors.successGreen : AppColors.borderGrey,
      ),
    );
  }
}