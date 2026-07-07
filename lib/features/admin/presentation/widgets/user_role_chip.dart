import 'package:flutter/material.dart';
import 'package:tadreeby/core/theme/app_colors.dart';

class UserRoleChip extends StatelessWidget {
  final String role;
  final bool isSelected;
  final VoidCallback onTap;

  const UserRoleChip({
    super.key,
    required this.role,
    required this.isSelected,
    required this.onTap,
  });

  Color _getRoleColor(String role) {
    switch (role) {
      case 'SUPER_ADMIN':
        return Colors.red;
      case 'UNIVERSITY_ADMIN':
        return Colors.blue;
      case 'COMPANY_ADMIN':
        return Colors.orange;
      case 'UNIVERSITY_SUPERVISOR':
        return Colors.purple;
      case 'COMPANY_TRAINER':
        return Colors.green;
      case 'STUDENT':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String _getRoleDisplay(String role) {
    switch (role) {
      case 'SUPER_ADMIN':
        return 'Super Admin';
      case 'UNIVERSITY_ADMIN':
        return 'Uni Admin';
      case 'COMPANY_ADMIN':
        return 'Company Admin';
      case 'UNIVERSITY_SUPERVISOR':
        return 'Supervisor';
      case 'COMPANY_TRAINER':
        return 'Trainer';
      case 'STUDENT':
        return 'Student';
      default:
        return role;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getRoleColor(role);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Text(
          _getRoleDisplay(role),
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}