import 'package:flutter/material.dart';
import 'package:tadreeby/core/theme/app_colors.dart';
import 'package:tadreeby/features/admin/presentation/widgets/build_stat.dart';
import '../../data/models/company_model.dart';

class CompanyCard extends StatelessWidget {
  final CompanyModel company;
  final VoidCallback? onTap;
  final VoidCallback? onToggleStatus;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const CompanyCard({
    super.key,
    required this.company,
    this.onTap,
    this.onToggleStatus,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = company.isActive;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          // ── card ──────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 3),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Top Row: Logo + Name + Menu ──────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLogo(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            company.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundOrange,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              company.shortCode,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.primaryOrange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ─── Status Badge ──────────────────────────────
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: isActive ? Colors.green : Colors.orange,
                            width: 1,
                          ),
                          color: isActive
                              ? Colors.green.withOpacity(0.08)
                              : Colors.orange.withOpacity(0.08),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: isActive ? Colors.green : Colors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isActive ? 'Active' : 'Inactive',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                color: isActive ? Colors.green : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // ─── Three Dots Menu ──────────────────────────
                    PopupMenuButton<String>(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      icon: Icon(
                        Icons.more_vert,
                        color: AppColors.primaryOrange,
                        size: 24,
                      ),
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            onEdit?.call();
                            break;
                          case 'toggle':
                            onToggleStatus?.call();
                            break;
                          case 'delete':
                            onDelete?.call();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined, size: 20, color: Colors.black),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'toggle',
                          child: Row(
                            children: [
                              Icon(
                                isActive ? Icons.pause_circle_outline : Icons.play_circle_outline,
                                size: 20,
                                color: isActive ? Colors.orange : Colors.green,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isActive ? 'Deactivate' : 'Activate',
                                style: TextStyle(
                                  color: isActive ? Colors.orange : Colors.green,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline, size: 20, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // ─── Location ──────────────────────────────────────
                if (company.location != null && company.location!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: AppColors.textGrey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          company.location!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                // ─── Divider ──────────────────────────────────────
                const SizedBox(height: 12),
                Divider(
                  color: Colors.grey.shade200,
                  height: 1,
                ),
                const SizedBox(height: 12),

                // ─── Stats Row with Dividers ──────────────────────
            if (company.count != null)
  Padding(
    padding: const EdgeInsets.symmetric(vertical: 4), // ✅ مسافة من الأعلى والأسفل
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // ─── Students ──────────────────────────────
        Expanded(
          child: buildStat(
            icon: Icons.school,
            label: 'Students',
            value: company.count!.students,
          ),
        ),
        
        // ─── خط فاصل ──────────────────────────────
        Container(
          width: 1,
          height: 40,
          color: Colors.grey.shade200,
        ),
        
        // ─── Admins ──────────────────────────────────
        Expanded(
          child: buildStat(
            icon: Icons.person,
            label: 'Admins',
            value: company.count!.users,
          ),
        ),
        
        // ─── خط فاصل ──────────────────────────────
        Container(
          width: 1,
          height: 40,
          color: Colors.grey.shade200,
        ),
        
        // ─── Trainers ──────────────────────────────
        Expanded(
          child: buildStat(
            icon: Icons.people,
            label: 'Trainers',
            value: company.count!.trainers,
          ),
        ),
      ],
    ),
  ),
              ],
            ),
          ),

        
          // ─── layer gray ──────────────────────────
          if (!isActive)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300.withOpacity(0.50),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─── Logo ────────────────────────────────────────────────────
  Widget _buildLogo() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.infoBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: company.logo != null && company.logo!.isNotEmpty
          ? Image.network(
              company.logo!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.business_outlined,
                color: AppColors.primaryOrange,
                size: 30,
              ),
            )
          : const Icon(
              Icons.business_outlined,
              color: AppColors.primaryOrange,
              size: 30,
            ),
    );
  }


}