import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../constants/app_colors.dart';

/// Responsive column count for the board grid — matches explore tab breakpoints.
int _boardColumnCount(double width) {
  if (width < 600) return 3;
  if (width < 900) return 4;
  if (width < 1200) return 5;
  if (width < 1500) return 6;
  if (width < 1800) return 7;
  return 8;
}

/// A responsive masonry grid of board thumbnails shown on the Profile tab.
/// Column count grows automatically with screen width — same as Pinterest boards.
///
/// [boardImageUrls] can be supplied to replace the default picsum images.
/// [onBoardTap] is called with the tapped board index.
class AnimatedBoardGrid extends StatefulWidget {
  final List<String>? boardImageUrls;
  final ValueChanged<int>? onBoardTap;

  const AnimatedBoardGrid({
    super.key,
    this.boardImageUrls,
    this.onBoardTap,
  });

  @override
  State<AnimatedBoardGrid> createState() => _AnimatedBoardGridState();
}

class _AnimatedBoardGridState extends State<AnimatedBoardGrid>
    with TickerProviderStateMixin {
  // Varying heights give the masonry a natural, staggered feel
  static const _heights = [140.0, 180.0, 120.0, 160.0, 200.0, 130.0];
  final List<int> _hovered = [];

  String _imageUrl(int index) =>
      widget.boardImageUrls != null && index < widget.boardImageUrls!.length
          ? widget.boardImageUrls![index]
          : 'https://picsum.photos/240/320?random=${500 + index}';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final columns = _boardColumnCount(screenWidth);
    // Tighter gap on mobile, slightly more breathing room on desktop
    final double gap = screenWidth < 600 ? 8 : 10;

    return MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: columns,
      mainAxisSpacing: gap,
      crossAxisSpacing: gap,
      itemCount: 24, // more items so grid fills wide screens nicely
      itemBuilder: (_, i) => MouseRegion(
        onEnter: (_) => setState(() => _hovered.add(i)),
        onExit: (_) => setState(() => _hovered.remove(i)),
        child: GestureDetector(
          onTap: () => widget.onBoardTap?.call(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.identity()
              ..scale(_hovered.contains(i) ? 1.04 : 1.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withOpacity(
                      _hovered.contains(i) ? 0.14 : 0.04),
                  blurRadius: _hovered.contains(i) ? 14 : 6,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                // Scale heights down proportionally on wider screens
                // so individual board cards don't look too tall
                height: _heights[i % _heights.length] *
                    (screenWidth > 1200 ? 0.75 : 1.0),
                child: Image.network(
                  _imageUrl(i),
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, progress) => progress == null
                      ? child
                      : Container(color: AppColors.surfaceVariant),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}