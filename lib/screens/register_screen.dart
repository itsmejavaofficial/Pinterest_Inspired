import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/glass_morphism.dart';
import '../services/local_auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isPasswordStrong = false;

  final LocalAuthService _auth = LocalAuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Password strength validation: at least 8 chars, uppercase, lowercase, digit, special character
  bool _validatePassword(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
    return true;
  }

  void _updatePasswordStrength(String value) {
    setState(() {
      _isPasswordStrong = _validatePassword(value);
    });
  }

  bool get _passwordsMatch =>
      _passwordController.text == _confirmPasswordController.text &&
          _confirmPasswordController.text.isNotEmpty;

  bool get _isFormValid =>
      _usernameController.text.trim().isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _isPasswordStrong &&
          _passwordsMatch;

  Future<void> _register() async {
    if (!_isFormValid) return;

    setState(() => _isLoading = true);
    try {
      await _auth.register(
        _usernameController.text.trim(),
        _passwordController.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful! Please log in.'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _goToLogin() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary),
          onPressed: _isLoading ? null : _goToLogin,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign up to get started',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                ),
                const SizedBox(height: 32),

                // Glass card form
                GlassMorphism(
                  blur: 34,
                  opacity: 0.15,
                  borderRadius: BorderRadius.circular(28),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Full name (optional)
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: const Icon(Icons.person_outline, color: AppColors.iconDefault),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: AppColors.surfaceVariant,
                        ),
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Username (required)
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username *',
                          prefixIcon: const Icon(Icons.person_outline, color: AppColors.iconDefault),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: AppColors.surfaceVariant,
                        ),
                        enabled: !_isLoading,
                        onChanged: (_) => setState(() {}), // to update form validity
                      ),
                      const SizedBox(height: 16),

                      // Password with visibility toggle
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password *',
                          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.iconDefault),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: AppColors.iconDefault,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: AppColors.surfaceVariant,
                        ),
                        obscureText: _obscurePassword,
                        enabled: !_isLoading,
                        onChanged: _updatePasswordStrength,
                      ),
                      const SizedBox(height: 8),

                      // Password strength hint
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          _isPasswordStrong
                              ? '✓ Strong password'
                              : 'Password must be at least 8 characters and include uppercase, lowercase, number, and special character (e.g., !@#\$%^&*)',
                          style: TextStyle(
                            fontSize: 12,
                            color: _isPasswordStrong ? Colors.green : Colors.redAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Confirm password with visibility toggle
                      TextField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password *',
                          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.iconDefault),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                              color: AppColors.iconDefault,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: AppColors.surfaceVariant,
                        ),
                        obscureText: _obscureConfirmPassword,
                        enabled: !_isLoading,
                        onChanged: (_) => setState(() {}), // to update match status
                      ),
                      const SizedBox(height: 8),

                      // Confirm password match hint
                      if (_confirmPasswordController.text.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            _passwordsMatch ? '✓ Passwords match' : '✗ Passwords do not match',
                            style: TextStyle(
                              fontSize: 12,
                              color: _passwordsMatch ? Colors.green : Colors.redAccent,
                            ),
                          ),
                        ),
                      const SizedBox(height: 28),

                      // Register button (disabled if form invalid)
                      _isLoading
                          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
                          : ElevatedButton(
                        onPressed: _isFormValid ? _register : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          disabledBackgroundColor: AppColors.textHint.withOpacity(0.4),
                          disabledForegroundColor: Colors.white54,
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Link back to login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    GestureDetector(
                      onTap: _isLoading ? null : _goToLogin,
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          color: _isLoading ? AppColors.textHint : AppColors.accent,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}