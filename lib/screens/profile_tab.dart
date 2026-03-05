import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/user_profile.dart';
import '../widgets/animated_board_grid.dart';
import '../widgets/glass_morphism.dart';

double _hPad(double w) {
  if (w < 600) return 16;
  if (w < 900) return 24;
  if (w < 1200) return 40;
  return 56;
}

class ProfileTab extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback onLogout;

  const ProfileTab({super.key, this.profile = UserProfile.demo, required this.onLogout});

  static const double _avatarRadius = 55.0;
  static const double _avatarOverlap = 55.0;
  static const double _maxContentWidth = 1080.0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final hPad = _hPad(screenWidth);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            color: AppColors.surface,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: Column(
                  children: [
                    // ── Cover + Avatar Stack ──────────────────────────
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // ── [BACK] Cover photo — constrained width ────
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child: SizedBox(
                            height: 240,
                            width: double.infinity,
                            child: Image.network(
                              profile.coverUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (_, child, progress) =>
                              progress == null
                                  ? child
                                  : Container(
                                  color: AppColors.surfaceVariant),
                            ),
                          ),
                        ),

                        // ── Gradient overlay ──────────────────────────
                        Positioned(
                          left: 0, right: 0, top: 0,
                          height: 240,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient: AppColors.headerGradient),
                            ),
                          ),
                        ),

                        // ── Settings menu (Popup) ─────────────────────
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: PopupMenuButton<String>(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: AppColors.surface,
                              elevation: 4,
                              onSelected: (value) async {
                                if (value == 'logout') {
                                  final shouldLogout = await showDialog<bool>(
                                    context: context,
                                    barrierColor: AppColors.shadow.withOpacity(0.45),
                                    builder: (ctx) => const _LogoutDialog(),
                                  );
                                  if (shouldLogout == true) {
                                    onLogout();
                                  }
                                }
                              },
                              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'logout',
                                  child: Row(
                                    children: [
                                      Icon(Icons.logout_rounded, color: AppColors.accent, size: 20),
                                      SizedBox(width: 8),
                                      Text('Logout'),
                                    ],
                                  ),
                                ),
                              ],
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.settings_outlined, color: AppColors.primary),
                              ),
                            ),
                          ),
                        ),

                        // ── [FRONT] Avatar ────────────────────────────
                        Positioned(
                          bottom: -_avatarOverlap,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.surface, width: 4),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                    AppColors.shadow.withOpacity(0.28),
                                    blurRadius: 20,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  profile.avatarUrl,
                                  width: _avatarRadius * 2,
                                  height: _avatarRadius * 2,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (_, child, progress) =>
                                  progress == null
                                      ? child
                                      : Container(
                                    width: _avatarRadius * 2,
                                    height: _avatarRadius * 2,
                                    color:
                                    AppColors.surfaceVariant,
                                    child: const Center(
                                      child:
                                      CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.accent,
                                      ),
                                    ),
                                  ),
                                  errorBuilder: (_, __, ___) => Container(
                                    width: _avatarRadius * 2,
                                    height: _avatarRadius * 2,
                                    color: AppColors.surfaceVariant,
                                    child: const Icon(Icons.person_rounded,
                                        size: 52,
                                        color: AppColors.textHint),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // ── Profile info ──────────────────────────────────
                    const SizedBox(height: _avatarOverlap + 16),

                    // ── Display name ──────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(profile.displayName,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            )),
                        if (profile.isVerified) ...[
                          const SizedBox(width: 6),
                          const CircleAvatar(
                            radius: 8,
                            backgroundColor: AppColors.accent,
                            child: Icon(Icons.check,
                                size: 14, color: Colors.white),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),

                    Text(profile.username,
                        style: TextStyle(
                            color: AppColors.textHint, fontSize: 15)),
                    const SizedBox(height: 8),

                    Text(profile.bio,
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 14)),
                    const SizedBox(height: 28),

                    // ── Stats ─────────────────────────────────────────
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hPad),
                      child: GlassMorphism(
                        blur: 40,
                        opacity: 0.14,
                        borderRadius: BorderRadius.circular(32),
                        padding: const EdgeInsets.symmetric(vertical: 22),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _StatItem(profile.postCount, 'Posts'),
                            const VerticalDivider(
                                color: Colors.white24,
                                thickness: 1,
                                width: 1),
                            _StatItem(profile.followerCount, 'Followers'),
                            const VerticalDivider(
                                color: Colors.white24,
                                thickness: 1,
                                width: 1),
                            _StatItem(profile.followingCount, 'Following'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── Buttons ───────────────────────────────────────
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hPad),
                      child: Row(children: [
                        Expanded(
                          child: GlassMorphism(
                            blur: 22,
                            opacity: 0.16,
                            borderRadius: BorderRadius.circular(22),
                            child: OutlinedButton(
                              onPressed: () {},
                              child: const Text('Edit Profile'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: GlassMorphism(
                            blur: 22,
                            opacity: 0.16,
                            borderRadius: BorderRadius.circular(22),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent),
                              child: const Text('Share Profile'),
                            ),
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 36),

                    // ── My Boards header (no logout button) ───────────
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hPad),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('My Boards',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              )),
                          _ViewAllButton(onTap: () {}),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Board grid ────────────────────────────────────
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hPad),
                      child: AnimatedBoardGrid(onBoardTap: (_) {}),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem(this.value, this.label);

  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
        )),
    const SizedBox(height: 4),
    Text(label,
        style: const TextStyle(
            color: AppColors.textSecondary, fontSize: 12.5)),
  ]);
}

class _ViewAllButton extends StatelessWidget {
  final VoidCallback? onTap;
  const _ViewAllButton({this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(children: [
        Icon(Icons.grid_view_rounded,
            size: 16, color: AppColors.textSecondary),
        SizedBox(width: 4),
        Text('View All',
            style:
            TextStyle(fontSize: 13, color: AppColors.textSecondary)),
      ]),
    ),
  );
}

// ── Themed logout confirmation dialog ─────────────────────────────────────────
// Matches the app's glassmorphism style — no plain system AlertDialog.
class _LogoutDialog extends StatelessWidget {
  const _LogoutDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Transparent so the GlassMorphism container provides the surface.
      backgroundColor: Colors.transparent,
      elevation: 0,
      // Large inset on mobile keeps it away from edges;
      // ConstrainedBox below caps the width on web/desktop.
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        // 400 px max — feels like a dialog, not a full-width banner.
        // On phones narrower than 400 px it fills the available inset width.
        constraints: const BoxConstraints(maxWidth: 400),
        child: GlassMorphism(
          blur: 40,
          opacity: 0.18,
          borderRadius: BorderRadius.circular(28),
          padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Warning icon ──────────────────────────────────────────
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.accent,
                  size: 28,
                ),
              ),
              const SizedBox(height: 20),

              // ── Title ─────────────────────────────────────────────────
              const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 10),

              // ── Body text ─────────────────────────────────────────────
              Text(
                'Are you sure you want to log out of your account?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.5,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // ── Buttons ───────────────────────────────────────────────
              Row(
                children: [
                  // Cancel — outlined style, stays in app
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(
                          color: AppColors.border,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Log out — filled accent, destructive action
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: AppColors.accent.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Log Out',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ), // ConstrainedBox
    );
  }
}