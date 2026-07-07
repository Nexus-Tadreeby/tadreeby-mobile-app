import 'package:flutter/material.dart';
import 'package:tadreeby/core/theme/app_colors.dart';
import 'package:tadreeby/features/admin/presentation/widgets/university_stat_card.dart';
import '../../data/models/university_model.dart';

class UniversityCard extends StatelessWidget {
  final UniversityModel university;
  final VoidCallback? onTap;
  final VoidCallback? onToggleStatus;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const UniversityCard({
    super.key,
    required this.university,
    this.onTap,
    this.onToggleStatus,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = university.isActive;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
       child: Stack(
        children: [
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
                // ─── Logo ──────────────────────────────────────
                _buildLogo(),
                const SizedBox(width: 12),
                
                // ─── Name & Short Code ────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        university.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
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
                          color: AppColors.infoBackground,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          university.shortCode,
                          style: const TextStyle(
                            fontSize: 9,
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

 // ─── Location ──────────────────────────────────────
            if (university.location != null && university.location!.isNotEmpty) ...[
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
                      university.location!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ],

                    ],
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.only(top: 3 ),
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
                    color: AppColors.primaryBlue,
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
  ),],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', 
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),),
                         
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            // // ─── Location ──────────────────────────────────────
            // if (university.location != null && university.location!.isNotEmpty) ...[
            //   const SizedBox(height: 6),
            //   Row(
            //     children: [
            //       Icon(
            //         Icons.location_on_outlined,
            //         size: 14,
            //         color: AppColors.textGrey,
            //       ),
            //       const SizedBox(width: 4),
            //       Expanded(
            //         child: Text(
            //           university.location!,
            //           maxLines: 1,
            //           overflow: TextOverflow.ellipsis,
            //           style: const TextStyle(
            //             fontSize: 13,
            //             color: AppColors.textGrey,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ],

            // const SizedBox(height: 6),
            // Row(
            //   children: [
            //     // ✅ نقطة خضراء أو برتقالية
            //     Container(
            //       width: 8,
            //       height: 8,
            //       decoration: BoxDecoration(
            //         color: isActive ? Colors.green : Colors.orange,
            //         shape: BoxShape.circle,
            //       ),
            //     ),
            //     const SizedBox(width: 6),
            //     Text(
            //       isActive ? 'Active' : 'Inactive',
            //       style: TextStyle(
            //         fontSize: 13,
            //         fontWeight: FontWeight.w500,
            //         color: isActive ? Colors.green : Colors.orange,
            //       ),
            //     ),
            //   ],
            // ),

            // ─── Divider ──────────────────────────────────────
            const SizedBox(height: 12),
            Divider(
              color: Colors.grey.shade200,
              height: 1,
            ),
            const SizedBox(height: 12),

            // ─── Stats Row ──────────────────────────────────────
        if (university.count != null)
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      // ─── Students ──────────────────────────────────────────
      Expanded(
        child: UniversityStatItem(
          icon: Icons.school,
          label: 'Students',
          value: university.count!.students,
          iconColor: AppColors.primaryBlue,
        ),
      ),
      
      // ───  line  ──────────────────────────────────────
      Container(
        width: 1,
        height: 40,
              color: Colors.grey.shade200,
      ),
      
      // ─── Admins ────────────────────────────────────────────
      Expanded(
        child: UniversityStatItem(
          icon: Icons.person,
          label: 'Admins',
          value: university.count!.users,
          iconColor: AppColors.primaryBlue,
        ),
      ),
      
      // ───  line  ──────────────────────────────────────
      Container(
        width: 1,
        height: 40,
              color: Colors.grey.shade200,
      ),
      
      // ─── Supervisors ──────────────────────────────────────
      Expanded(
        child: UniversityStatItem(
          icon: Icons.supervisor_account,
          label: 'Supervisors',
          value: university.count!.supervisors,
          iconColor: AppColors.primaryBlue,
      ),
                      ),
                    ],
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
      child: university.logo != null && university.logo!.isNotEmpty
          ? Image.network(
              university.logo!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.account_balance_outlined,
                color: AppColors.primaryBlue,
                size: 30,
              ),
            )
          : const Icon(
              Icons.account_balance_outlined,
              color: AppColors.primaryBlue,
              size: 30,
            ),
    );
  }
}