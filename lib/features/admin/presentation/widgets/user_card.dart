import 'package:flutter/material.dart';
import 'package:tadreeby/core/theme/app_colors.dart';
import '../../data/models/user_model.dart';
import 'user_status_chip.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onTap;
  final VoidCallback? onMoreTap;

  const UserCard({
    super.key,
    required this.user,
    this.onTap,
    this.onMoreTap,
  });

  Color _getRoleColor(String role) {
    switch (role) {
      case 'SUPER_ADMIN':
        return Colors.blue;
      case 'UNIVERSITY_ADMIN':
        return Colors.purple;
      case 'COMPANY_ADMIN':
        return Colors.green;
      case 'UNIVERSITY_SUPERVISOR':
        return Colors.indigo;
      case 'COMPANY_TRAINER':
        return Colors.orange;
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
        return 'University Admin';
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

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'SUPER_ADMIN':
        return Icons.check_circle;
      default:
        return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleColor = _getRoleColor(user.role);
    final roleIcon = _getRoleIcon(user.role);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ─── User column (Avatar + Name + Email) ──────────────
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: roleColor.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        user.initials,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: roleColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          user.fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // ─── Role column ────────────────────────────────────
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Icon(roleIcon, size: 14, color: roleColor),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _getRoleDisplay(user.role),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // ─── Status column ──────────────────────────────────
            Expanded(
              flex: 2,
              child: UserStatusChip(isActive: user.isActive),
            ),

            // ─── More menu ──────────────────────────────────────
            SizedBox(
              width: 32,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.more_vert,
                  size: 18,
                  color: Colors.grey.shade500,
                ),
                onPressed: onMoreTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}