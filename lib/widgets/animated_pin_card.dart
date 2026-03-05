import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/pin_model.dart';
import 'glass_morphism.dart';

/// A Pinterest-style masonry card with save, like, hover, and shine effects.
/// Font sizes and avatar scale down automatically when the card is narrow
/// (many columns on a wide screen).
class AnimatedPinCard extends StatefulWidget {
  final PinModel pin;
  final int index;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onSave;
  final ValueChanged<bool>? onLike;

  const AnimatedPinCard({
    super.key,
    required this.pin,
    required this.index,
    this.onTap,
    this.onSave,
    this.onLike,
  });

  @override
  State<AnimatedPinCard> createState() => _AnimatedPinCardState();
}

class _AnimatedPinCardState extends State<AnimatedPinCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _hover = false;
  bool _saved = false;
  bool _liked = false;
  double _shine = -1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    Future.delayed(
      Duration(milliseconds: 200 + widget.index * 80),
          () { if (mounted) _controller.forward(); },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleSave() {
    setState(() => _saved = !_saved);
    widget.onSave?.call(_saved);
  }

  void _toggleLike() {
    setState(() => _liked = !_liked);
    widget.onLike?.call(_liked);
  }

  @override
  Widget build(BuildContext context) {
    // Derive card width from actual layout so we can scale text.
    final screenWidth = MediaQuery.of(context).size.width;
    // Compact mode when cards are narrow (5+ columns on wide screens)
    final bool compact = screenWidth > 1100;
    final double titleSize   = compact ? 12.0 : 14.5;
    final double metaSize    = compact ? 10.5 : 12.5;
    final double savesSize   = compact ? 10.0 : 12.0;
    final double avatarRadius = compact ? 10.0 : 13.0;
    final double iconSize    = compact ? 13.0 : 15.0;
    final double cardRadius  = compact ? 16.0 : 24.0;
    final double bookmarkSize = compact ? 18.0 : 22.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: FadeTransition(
        opacity: _controller,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.2),
            end: Offset.zero,
          ).animate(CurvedAnimation(
              parent: _controller, curve: Curves.easeOutQuint)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.identity()..scale(_hover ? 1.02 : 1.0),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(cardRadius),
              child: InkWell(
                onTap: widget.onTap,
                onTapDown: (_) => setState(() => _shine = 2),
                borderRadius: BorderRadius.circular(cardRadius),
                child: Stack(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Image ──────────────────────────────────────
                      Stack(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(cardRadius),
                          child: AspectRatio(
                            aspectRatio: widget.pin.aspectRatio,
                            child: Image.network(
                              widget.pin.imageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (_, child, progress) =>
                              progress == null
                                  ? child
                                  : Container(
                                  color: AppColors.surfaceVariant),
                            ),
                          ),
                        ),

                        // ── Bookmark ─────────────────────────────────
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GlassMorphism(
                            blur: 16,
                            opacity: 0.22,
                            borderRadius: BorderRadius.circular(14),
                            padding: const EdgeInsets.all(4),
                            child: GestureDetector(
                              onTap: _toggleSave,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 220),
                                child: Icon(
                                  _saved
                                      ? Icons.bookmark_rounded
                                      : Icons.bookmark_border_rounded,
                                  key: ValueKey(_saved),
                                  size: bookmarkSize,
                                  color: _saved
                                      ? AppColors.accent
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // ── More (hover) ──────────────────────────────
                        if (_hover)
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: GlassMorphism(
                              blur: 14,
                              opacity: 0.25,
                              borderRadius: BorderRadius.circular(12),
                              padding: const EdgeInsets.all(5),
                              child: const Icon(Icons.more_horiz_rounded,
                                  size: 16, color: Colors.white),
                            ),
                          ),

                        // ── Tags (hover) ──────────────────────────────
                        if (_hover)
                          Positioned(
                            bottom: 8,
                            left: 8,
                            child: Wrap(
                              spacing: 4,
                              children: widget.pin.tags
                                  .map((t) => GlassMorphism(
                                blur: 10,
                                opacity: 0.3,
                                borderRadius:
                                BorderRadius.circular(10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Text(t,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: compact ? 9.0 : 10.5,
                                      fontWeight: FontWeight.w600,
                                    )),
                              ))
                                  .toList(),
                            ),
                          ),
                      ]),

                      // ── Footer ────────────────────────────────────
                      const SizedBox(height: 8),
                      Text(
                        widget.pin.title,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(children: [
                        CircleAvatar(
                          radius: avatarRadius,
                          backgroundImage: const NetworkImage(
                              'https://picsum.photos/80/80?random=80'),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'user_${widget.pin.title.length % 1000}',
                            style: TextStyle(
                                fontSize: metaSize,
                                color: AppColors.textSecondary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: _toggleLike,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            transform: Matrix4.identity()
                              ..scale(_liked ? 1.25 : 1.0),
                            child: Icon(
                              _liked
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              size: iconSize,
                              color: _liked
                                  ? AppColors.accent
                                  : AppColors.iconDefault,
                            ),
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(widget.pin.saves,
                            style: TextStyle(
                                fontSize: savesSize,
                                color: AppColors.textSecondary)),
                      ]),
                      const SizedBox(height: 14),
                    ],
                  ),

                  // ── Shine overlay ───────────────────────────────────
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 680),
                    left: _shine * 120,
                    top: 0,
                    bottom: 0,
                    width: 100,
                    child: IgnorePointer(
                      child: Opacity(
                        opacity: _shine > 0 ? 0.4 : 0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.white.withOpacity(0),
                              Colors.white.withOpacity(0.45),
                              Colors.white.withOpacity(0),
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}