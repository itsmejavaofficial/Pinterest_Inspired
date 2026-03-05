import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Search bar with:
/// - Filter button (always visible on the right)
/// - Clear (✕) button that appears instantly when the field has text,
///   and deletes everything in one tap.
class AnimatedSearchField extends StatefulWidget {
  final ValueChanged<String>? onSearch;
  final VoidCallback? onFilterTap;

  const AnimatedSearchField({super.key, this.onSearch, this.onFilterTap});

  @override
  State<AnimatedSearchField> createState() => _AnimatedSearchFieldState();
}

class _AnimatedSearchFieldState extends State<AnimatedSearchField>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final AnimationController _clearAnim;
  bool _isFocused = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode()
      ..addListener(() => setState(() => _isFocused = _focusNode.hasFocus));
    _clearAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _controller.addListener(() {
      final hasText = _controller.text.isNotEmpty;
      if (hasText != _hasText) {
        setState(() => _hasText = hasText);
        hasText ? _clearAnim.forward() : _clearAnim.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _clearAnim.dispose();
    super.dispose();
  }

  void _clearText() {
    _controller.clear();
    widget.onSearch?.call('');
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) => TextField(
    controller: _controller,
    focusNode: _focusNode,
    onChanged: widget.onSearch,
    style: const TextStyle(color: AppColors.primary),
    decoration: InputDecoration(
      hintText: 'Search...',
      hintStyle: TextStyle(
        color: AppColors.textHint.withOpacity(0.9),
        fontSize: 15,
      ),

      // ── Search icon ─────────────────────────────────────────────
      prefixIcon: const Icon(
        Icons.search_rounded,
        color: AppColors.iconDefault,
        size: 22,
      ),

      // ── Clear + Filter buttons ──────────────────────────────────
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Clear button — fades + slides in when field has text
          FadeTransition(
            opacity: _clearAnim,
            child: ScaleTransition(
              scale: _clearAnim,
              child: _hasText
                  ? GestureDetector(
                onTap: _clearText,
                child: Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.textHint.withOpacity(0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: AppColors.iconDefault,
                  ),
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ),

          // Filter button — always visible
          Padding(
            padding:
            const EdgeInsets.only(right: 10, top: 8, bottom: 8),
            child: GestureDetector(
              onTap: widget.onFilterTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: _isFocused
                      ? AppColors.accent
                      : AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: (_isFocused
                          ? AppColors.accent
                          : AppColors.primary)
                          .withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),

      border: InputBorder.none,
      contentPadding:
      const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
    ),
  );
}