import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../constants/app_colors.dart';
import '../models/category_model.dart';
import '../models/pin_model.dart';
import '../widgets/animated_category_chip.dart';
import '../widgets/animated_pin_card.dart';
import '../widgets/animated_search_field.dart';
import '../widgets/glass_morphism.dart';

/// Responsive column count — mirrors Pinterest's behaviour:
///   < 600px  → 2 columns  (phone portrait)
///   < 900px  → 3 columns  (phone landscape / small tablet)
///   < 1200px → 4 columns  (tablet / small desktop)
///   < 1500px → 5 columns  (desktop)
///   < 1800px → 6 columns  (wide desktop)
///   ≥ 1800px → 7 columns  (ultra-wide)
int _columnCount(double width) {
  if (width < 600) return 2;
  if (width < 900) return 3;
  if (width < 1200) return 4;
  if (width < 1500) return 5;
  if (width < 1800) return 6;
  return 7;
}

/// Horizontal padding scales with screen width so cards never feel
/// edge-to-edge on very wide displays.
double _horizontalPadding(double width) {
  if (width < 600) return 12;
  if (width < 900) return 16;
  if (width < 1200) return 24;
  return 32;
}

class PinterestHomeTab extends StatefulWidget {
  const PinterestHomeTab({super.key});

  @override
  State<PinterestHomeTab> createState() => _PinterestHomeTabState();
}

class _PinterestHomeTabState extends State<PinterestHomeTab>
    with TickerProviderStateMixin {
  final List<PinModel> _allPins = PinModel.samplePins;
  final List<CategoryModel> _categories = CategoryModel.defaults;

  int _selectedCategory = 0;
  String _searchQuery = '';

  List<PinModel> get _displayedPins {
    if (_searchQuery.isEmpty) return _allPins;
    final q = _searchQuery.toLowerCase();
    return _allPins
        .where((p) =>
    p.title.toLowerCase().contains(q) ||
        p.tags.any((t) => t.toLowerCase().contains(q)))
        .toList();
  }

  void _onCategorySelected(int index) =>
      setState(() => _selectedCategory = index);

  void _onSearch(String query) => setState(() => _searchQuery = query);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final columns = _columnCount(screenWidth);
    final hPad = _horizontalPadding(screenWidth);

    // Gap between cards — slightly tighter on mobile, looser on desktop
    const double gap = 12;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: Column(children: [
              const SizedBox(height: 16),

              // ── Search bar ───────────────────────────────────────────
              GlassMorphism(
                blur: 34,
                opacity: 0.15,
                borderRadius: BorderRadius.circular(34),
                child: AnimatedSearchField(onSearch: _onSearch),
              ),

              const SizedBox(height: 14),

              // ── Category chips ────────────────────────────────────────
              SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: AnimatedCategoryChip(
                      icon: _categories[i].icon,
                      label: _categories[i].label,
                      selected: i == _selectedCategory,
                      index: i,
                      onSelected: (_) => _onCategorySelected(i),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ]),
          ),
        ),

        // ── Responsive masonry pin grid ────────────────────────────────
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: hPad),
          sliver: SliverMasonryGrid.count(
            crossAxisCount: columns,
            mainAxisSpacing: gap,
            crossAxisSpacing: gap,
            childCount: _displayedPins.length,
            itemBuilder: (_, i) => AnimatedPinCard(
              pin: _displayedPins[i],
              index: i,
              onTap: () {},
              onSave: (_) {},
              onLike: (_) {},
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 50)),
      ],
    );
  }
}