import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/app_colors.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/local_auth_service.dart';

void main() => runApp(const VisualKelApp());

class VisualKelApp extends StatelessWidget {
  const VisualKelApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Visual Kel',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      fontFamily: 'SF Pro Display',
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accent),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.surface,
      ),
    ),
    home: const AuthWrapper(),
  );
}

/// Decides whether to show login or main app based on local storage
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final LocalAuthService _auth = LocalAuthService();
  bool? _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final loggedIn = await _auth.isLoggedIn();
    setState(() {
      _isLoggedIn = loggedIn;
    });
  }

  void _handleLogout() {
    _auth.logout().then((_) {
      _checkLoginStatus(); // re-check after logout
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn == null) {
      // Still checking
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }
    if (_isLoggedIn == true) {
      return _AnimatedHomeScreen(onLogout: _handleLogout);
    } else {
      // Pass _checkLoginStatus as onLogin callback
      return LoginScreen(onLogin: _checkLoginStatus);
    }
  }
}

/// Original animated home screen – accepts logout callback
class _AnimatedHomeScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const _AnimatedHomeScreen({required this.onLogout});

  @override
  State<_AnimatedHomeScreen> createState() => _AnimatedHomeScreenState();
}

class _AnimatedHomeScreenState extends State<_AnimatedHomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    child: SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
          parent: _controller, curve: Curves.easeOutQuint)),
      child: HomeScreen(onLogout: widget.onLogout),
    ),
  );
}