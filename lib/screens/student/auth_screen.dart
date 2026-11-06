// Student Authentication Screen - Login with Role Selection
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../config/theme.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';
import '../../widgets/gradient_button.dart';

enum LoginRole { student, sagOfficer, admin }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  LoginRole _selectedRole = LoginRole.student;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  UserRole _getUserRole() {
    switch (_selectedRole) {
      case LoginRole.student:
        return UserRole.student;
      case LoginRole.sagOfficer:
        return UserRole.sagOfficer;
      case LoginRole.admin:
        return UserRole.admin;
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    final authService = context.read<AuthService>();
    await authService.loginAsRole(_getUserRole());
    
    setState(() => _isLoading = false);

    if (mounted) {
      _navigateBasedOnRole(authService);
    }
  }

  Future<void> _authenticateBiometric() async {
    setState(() => _isLoading = true);
    
    final authService = context.read<AuthService>();
    final success = await authService.authenticateWithBiometric();
    
    setState(() => _isLoading = false);

    if (success && mounted) {
      _navigateBasedOnRole(authService);
    }
  }

  void _navigateBasedOnRole(AuthService authService) {
    final user = authService.currentUser;
    if (user == null) return;

    switch (user.role) {
      case UserRole.student:
        Navigator.pushReplacementNamed(context, '/student/dashboard');
        break;
      case UserRole.sagOfficer:
        Navigator.pushReplacementNamed(context, '/sag/dashboard');
        break;
      case UserRole.admin:
        Navigator.pushReplacementNamed(context, '/admin/dashboard');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Blue Header Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 40,
              bottom: 40,
            ),
            decoration: const BoxDecoration(
              gradient: AppTheme.blueHeaderGradient,
            ),
            child: Column(
              children: [
                // Graduation Cap Icon
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.school_outlined,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Scholarship Portal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Government of India',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // White Content Section
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(AppColors.backgroundLight),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Login Type',
                          style: TextStyle(
                            color: Color(AppColors.textDark),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Role Selection Grid
                        _buildRoleSelectionGrid(),
                        const SizedBox(height: 24),
                        // Email/Mobile Field
                        _buildInputLabel('Email / Mobile Number'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _emailController,
                          hint: 'Enter mobile number',
                          prefixIcon: Icons.phone_android,
                        ),
                        const SizedBox(height: 16),
                        // Password Field
                        _buildInputLabel('Password'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _passwordController,
                          hint: 'Enter password',
                          prefixIcon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: const Color(AppColors.textMuted),
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(AppColors.primaryStart),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Face ID Login
                        Center(
                          child: TextButton.icon(
                            onPressed: _isLoading ? null : _authenticateBiometric,
                            icon: const Icon(
                              Icons.face,
                              color: Color(AppColors.primaryStart),
                            ),
                            label: const Text(
                              'Login with Face ID',
                              style: TextStyle(
                                color: Color(AppColors.primaryStart),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Register Link
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'New Student? ',
                                style: TextStyle(
                                  color: Color(AppColors.textMuted),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(context, '/student/register'),
                                child: const Text(
                                  'Register Here',
                                  style: TextStyle(
                                    color: Color(AppColors.primaryStart),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSelectionGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildRoleCard(LoginRole.student, Icons.school_outlined, 'Student')),
            const SizedBox(width: 12),
            Expanded(child: _buildRoleCard(LoginRole.sagOfficer, Icons.verified_user_outlined, 'SAG Officer')),
            const SizedBox(width: 12),
            Expanded(child: _buildRoleCard(LoginRole.admin, Icons.account_balance_outlined, 'Admin')),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleCard(LoginRole role, IconData icon, String label, {bool isFullWidth = false}) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(AppColors.primaryStart) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(AppColors.primaryStart) : const Color(AppColors.border),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? Colors.white : const Color(AppColors.textDark),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(AppColors.textDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(AppColors.textDark),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(AppColors.border)),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(
          color: Color(AppColors.textDark),
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(AppColors.textMuted),
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: const Color(AppColors.textMuted),
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }
}
