// lib/features/admin/presentation/widgets/admin_bottom_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tadreeby/core/theme/app_colors.dart';

class AdminBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const AdminBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  static const List<_NavItem> _items = [
    _NavItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      color: AppColors.primaryBlue,
      route: '/admin/dashboard',
      
    ),
    _NavItem(
      icon: Icons.account_balance_outlined,
      activeIcon: Icons.account_balance,
      color: AppColors.primaryBlue,
      route: '/admin/universities',
    ),
    _NavItem(
      icon: Icons.apartment_outlined,
      activeIcon: Icons.apartment,
      color: AppColors.primaryOrange,
      route: '/admin/companies',
    ),
    _NavItem(
      icon: Icons.people_outline,
      activeIcon: Icons.people,
      color: AppColors.purple,
      route: '/admin/users',
    ),
    _NavItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      color: AppColors.primaryBlue,
      route: '/admin/settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isSelected = index == currentIndex;

              return InkWell(
                onTap: () {
                  if (!isSelected) {
                    context.go(item.route);
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? item.activeIcon : item.icon,
                        color: isSelected ? item.color : AppColors.textGrey,
                        size: 26,
                      ),
                      const SizedBox(height: 2),
                      // Text(
                      //   item.label,
                      //   style: TextStyle(
                      //     fontSize: 10,
                      //     fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      //     color: isSelected ? item.color : AppColors.textGrey,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
final Color color;
  final String route;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.color,
    required this.route,
  });
}