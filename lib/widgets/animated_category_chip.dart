import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'glass_morphism.dart';

/// A horizontally scrollable category chip with entrance animation
/// and hover / selection effects.
///
/// Supply [onSelected] to react when the chip is tapped.
class AnimatedCategoryChip extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final int index;
  final ValueChanged<bool>? onSelected;

  const AnimatedCategoryChip({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.index,
    this.onSelected,
  });

  @override
  State<AnimatedCategoryChip> createState() => _AnimatedCategoryChipState();
}

class _AnimatedCategoryChipState extends State<AnimatedCategoryChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _hover = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    Future.delayed(
      Duration(milliseconds: 100 + widget.index * 50),
          () {
        if (mounted) _controller.forward();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hover = true),
    onExit: (_) => setState(() => _hover = false),
    child: AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => Transform.scale(
        scale: _controller.value * (_hover ? 1.06 : 1.0),
        child: GlassMorphism(
          blur: widget.selected || _hover ? 24 : 0,
          opacity: widget.selected || _hover ? 0.18 : 0.0,
          borderRadius: BorderRadius.circular(22),
          child: FilterChip(
            avatar: Icon(
              widget.icon,
              size: 16,
              color:
              widget.selected ? Colors.white : AppColors.iconDefault,
            ),
            label: Text(
              widget.label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: widget.selected
                    ? FontWeight.w700
                    : FontWeight.w600,
                color:
                widget.selected ? Colors.white : AppColors.primary,
              ),
            ),
            selected: widget.selected,
            onSelected: widget.onSelected,
            backgroundColor: Colors.transparent,
            showCheckmark: false,
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 10),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(22)),
            ),
          ),
        ),
      ),
    ),
  );
}