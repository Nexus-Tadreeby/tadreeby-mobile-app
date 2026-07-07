import 'package:flutter/material.dart';

class UserStatusChip extends StatelessWidget {
  final bool isActive;

  const UserStatusChip({
    super.key,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = isActive ? const Color(0xFF2E7D32) : const Color(0xFFE68A00);
    final Color bgColor = isActive
        ? const Color(0xFF2E7D32).withOpacity(0.12)
        : const Color(0xFFE68A00).withOpacity(0.12);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
           border: Border.all(
          color: color, 
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            isActive ? 'Active' : 'Inactive',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}