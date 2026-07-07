import 'package:flutter/material.dart';
import 'package:tadreeby/core/theme/app_colors.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final ValueChanged<int> onPageSelected;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPrevious,
    required this.onNext,
    required this.onPageSelected,
  });

  // ─── بناء قائمة الأرقام المعروضة ──────────────────────
  List<dynamic> _buildPageItems() {
    const int maxVisible = 5;
    final List<dynamic> items = [];

    if (totalPages <= maxVisible) {
      for (int i = 1; i <= totalPages; i++) {
        items.add(i);
      }
      return items;
    }

    // نحدد نطاق الأرقام المعروضة
    int start = currentPage - 2;
    int end = currentPage + 2;

    // تصحيح البداية إذا كانت أقل من 1
    if (start < 1) {
      start = 1;
      end = maxVisible;
    }

    // تصحيح النهاية إذا تجاوزت totalPages
    if (end > totalPages) {
      end = totalPages;
      start = totalPages - maxVisible + 1;
      if (start < 1) start = 1;
    }

    // إضافة الأرقام من start إلى end
    for (int i = start; i <= end; i++) {
      items.add(i);
    }

    // إضافة "..." إذا كان هناك أرقام مخفية في البداية
    if (start > 1) {
      items.insert(0, '...');
      items.insert(0, 1);
    }

    // إضافة "..." إذا كان هناك أرقام مخفية في النهاية
    if (end < totalPages) {
      items.add('...');
      items.add(totalPages);
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    final items = _buildPageItems();
    final bool canGoPrevious = currentPage > 1;
    final bool canGoNext = currentPage < totalPages;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ─── زر السهم الأيسر ──────────────────────────────
          _ArrowButton(
            icon: Icons.chevron_left,
            enabled: canGoPrevious,
            onTap: canGoPrevious ? onPrevious : null,
          ),
          
          const SizedBox(width: 6),
          
          // ─── أرقام الصفحات ──────────────────────────────────
          ...items.map((item) {
            if (item == '...') {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  '...',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }

            final int page = item as int;
            final bool isSelected = page == currentPage;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: _PageNumberButton(
                page: page,
                isSelected: isSelected,
                onTap: () {
                  if (!isSelected) onPageSelected(page);
                },
              ),
            );
          }),
          
          const SizedBox(width: 6),
          
          // ─── زر السهم الأيمن ──────────────────────────────
          _ArrowButton(
            icon: Icons.chevron_right,
            enabled: canGoNext,
            onTap: canGoNext ? onNext : null,
          ),
        ],
      ),
    );
  }
}

// ─── زر رقم الصفحة ────────────────────────────────────────
class _PageNumberButton extends StatelessWidget {
  final int page;
  final bool isSelected;
  final VoidCallback onTap;

  const _PageNumberButton({
    required this.page,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.purple.withOpacity(0.12)
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.purple : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          '$page',
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppColors.purple : AppColors.textGrey,
          ),
        ),
      ),
    );
  }
}

// ─── زر السهم (يمين / يسار) ───────────────────────────────
class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  const _ArrowButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: enabled ? AppColors.purple : Colors.grey.shade300,
            width: enabled ? 1.5 : 1,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? AppColors.purple : Colors.grey.shade300,
        ),
      ),
    );
  }
}