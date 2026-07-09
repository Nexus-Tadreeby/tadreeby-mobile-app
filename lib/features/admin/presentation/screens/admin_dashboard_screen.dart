import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tadreeby/core/di/injection.dart';
import 'package:tadreeby/core/theme/app_colors.dart';
import '../cubits/dashboard_cubit.dart';
import '../widgets/admin_bottom_nav_bar.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DashboardCubit>()..loadDashboardData(),
      child: const _AdminDashboardContent(),
    );
  }
}

class _AdminDashboardContent extends StatelessWidget {
  const _AdminDashboardContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Admin Dashboard',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_none_outlined,
                    color: AppColors.textDark,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notifications coming soon!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: const Text(
                      '3',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DashboardError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DashboardCubit>().loadDashboardData();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is DashboardLoaded) {
            return _buildContent(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: const AdminBottomNavBar(
        currentIndex: 0,
      ),
    );
  }

  Widget _buildContent(BuildContext context, DashboardLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Welcome Card ──────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryBlue,
                  AppColors.primaryBlue.withOpacity(0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '👋 Welcome back, Admin!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage universities, companies, users, and internships from here.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ─── Overview ──────────────────────────────────────────
          const Text(
            'Overview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              _buildOverviewCard(
                title: 'Universities',
                value: state.universitiesCount.toString(),
                trend: state.universitiesTrend,
                icon: Icons.account_balance,
                color: Colors.blue,
                onTap: () => context.go('/admin/universities'),
              ),
              const SizedBox(width: 12),
              _buildOverviewCard(
                title: 'Companies',
                value: state.companiesCount.toString(),
                trend: state.companiesTrend,
                icon: Icons.business,
                color: Colors.orange,
                onTap: () => context.go('/admin/companies'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildOverviewCard(
                title: 'Users',
                value: state.usersCount.toString(),
                trend: state.usersTrend,
                icon: Icons.people,
                color: Colors.green,
                onTap: () => context.go('/admin/users')
              ),
              const SizedBox(width: 12),
              _buildOverviewCard(
                title: 'Internships',
                value: '0',
                trend: '0%',
                icon: Icons.work,
                color: Colors.purple,
                 onTap: () => context.go('/admin/internships'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ─── Quick Actions ─────────────────────────────────────
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildActionCard(
                context,
                title: 'Universities',
                subtitle: 'Manage universities',
                icon: Icons.school,
                color: Colors.blue,
                onTap: () => context.go('/admin/universities'),
              ),
              const SizedBox(width: 12),
              _buildActionCard(
                context,
                title: 'Users',
                subtitle: 'Manage users',
                icon: Icons.people,
                color: Colors.orange,
                onTap: () => context.go('/admin/users'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildActionCard(
                context,
                title: 'Companies',
                subtitle: 'Manage companies',
                icon: Icons.business,
                color: Colors.green,
                onTap: () => context.go('/admin/companies'),
              ),
              const SizedBox(width: 12),
              _buildActionCard(
                context,
                title: 'Reports',
                subtitle: 'View reports & analytics',
                icon: Icons.bar_chart,
                color: Colors.purple,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Reports coming soon!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ─── Recent Activity (Static) ──────────────────────────
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.borderGrey.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                _buildActivityItem(
                  icon: Icons.account_balance,
                  color: Colors.orange,
                  title: 'New university "Al-Quds University" added',
                  subtitle: '2 hours ago',
                ),
                Divider(
                  height: 1,
                  color: AppColors.borderGrey.withOpacity(0.5),
                ),
                _buildActivityItem(
                  icon: Icons.business,
                  color: Colors.purple,
                  title: 'New company "Tech Solutions" registered',
                  subtitle: '5 hours ago',
                ),
                Divider(
                  height: 1,
                  color: AppColors.borderGrey.withOpacity(0.5),
                ),
                _buildActivityItem(
                  icon: Icons.person_add_alt_1,
                  color: Colors.blue,
                  title: 'New user "Omar Hassan" added',
                  subtitle: '1 day ago',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
Widget _buildOverviewCard({
  required String title,
  required String value,
  required String trend,
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
}) {
  final isPositive = trend.startsWith('+');
  final trendColor = isPositive ? Colors.green : Colors.red;

  return Expanded(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // ✅ توسيط عمودي
          children: [
            // ─── icon ──────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 10),

            // ─── number and title ───────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center, // ✅ توسيط عمودي
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),

            // ─── trend ──────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 12,
                  color: trendColor,
                ),
                const SizedBox(width: 2),
                Text(
                  trend,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: trendColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.borderGrey.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textGrey,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Go',
                    style: TextStyle(
                      fontSize: 12,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 14,
                    color: color,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.grey.shade400,
            size: 20,
          ),
        ],
      ),
    );
  }
}