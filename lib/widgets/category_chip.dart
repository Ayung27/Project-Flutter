import 'package:flutter/material.dart';
import '../models/food_category.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Shortcut kategori (ikon dalam lingkaran + label) ala GoFood/Gojek.
/// Active state beranimasi, ada tap-scale feedback, dan cursor pointer di web.
class CategoryChip extends StatefulWidget {
  final FoodCategory category;
  final bool selected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    required this.selected,
    required this.onTap,
  });

  @override
  State<CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<CategoryChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.92 : 1,
          duration: const Duration(milliseconds: 110),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : AppColors.primarySoft,
                  shape: BoxShape.circle,
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  widget.category.icon,
                  color: selected ? Colors.white : AppColors.primary,
                  size: 26,
                ),
              ),
              const SizedBox(height: AppSpacing.xs + 2),
              SizedBox(
                width: 64,
                child: Text(
                  widget.category.label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                    color: selected ? AppColors.primary : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
