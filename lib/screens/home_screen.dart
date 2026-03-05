import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'explore_tab.dart';
import 'profile_tab.dart';

/// Root scaffold that hosts the animated app-bar title and the two main tabs.
class HomeScreen extends StatelessWidget {
  final VoidCallback onLogout;

  const HomeScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child: Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const _AnimatedAppBarTitle(),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColors.border))),
            child: const TabBar(
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textHint,
              tabs: [
                Tab(text: 'Explore'),
                Tab(icon: Icon(Icons.person_outline_rounded)),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        children: [
          const PinterestHomeTab(),
          ProfileTab(onLogout: onLogout), // pass callback to profile
        ],
      ),
    ),
  );
}

// ── Private app-bar title ────────────────────────────────────────────────────

class _AnimatedAppBarTitle extends StatefulWidget {
  const _AnimatedAppBarTitle();

  @override
  State<_AnimatedAppBarTitle> createState() => _AnimatedAppBarTitleState();
}

class _AnimatedAppBarTitleState extends State<_AnimatedAppBarTitle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (_, __) => Transform.scale(
      scale: 1.0 +
          Tween(begin: 0.0, end: 0.05).animate(_controller).value,
      child: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
        ).createShader(bounds),
        child: RichText(
          text: const TextSpan(
            text: 'VISUAL',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: Colors.white,
            ),
            children: [TextSpan(text: ' KEL')],
          ),
        ),
      ),
    ),
  );
}