import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tadreeby/features/auth/presentation/widgets/custom_text_field.dart';

import '../../../../core/theme/app_colors.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';

// ============================================================
// LOGIN SCREEN
// ============================================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      context.read<LoginCubit>().login(email, password);
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              _handleLoginSuccess(context, state);
            } else if (state is LoginError) {
              _showErrorSnackBar(context, state.message);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80),

                    // ───  Tadreeby ───────────────────────────────────
                    Center(
                      child: _TadreebyLogo(),
                    ),
                    const SizedBox(height: 20),

                    // ─── Welcome Back ────────────────────────────────────
                    const Center(
                      child: Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Center(
                      child: Text(
                        'Login to access your account',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),

                    // ─── Email Address label + Forgot Password ───────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Email Address',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textDark,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.push('/forgot-password');
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                     // ─── Email Field ─────────────────────────────────────
                    CustomTextField(
                      label: '', 
                      hint: 'Enter your email',
                      prefixIcon: Icons.email_outlined,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      showLabel: false,
                      isRequired: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 19),

                    // ─── Password label ──────────────────────────────────
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),

                // ─── Password Field ──────────────────────────────────
                    CustomTextField(
                      label: '', 
                      hint: 'Enter your password',
                      prefixIcon: Icons.lock_outline,
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      showLabel: false,
                      isRequired: true,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.primaryBlue,
                          size: 22,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // ─── Remember Me ─────────────────────────────────────
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                            activeColor: AppColors.primaryBlue,
                            side: const BorderSide(
                              color: AppColors.primaryBlue,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Remember me',
                          style: TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ─── Login Button ────────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: state is LoginLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          elevation: 0,
                        ),
                        child: state is LoginLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // ─── Student Registration Card ────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xffC2DCFF),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.infoBackground,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.school,
                              color: AppColors.primaryBlue,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Student Registration',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  "Don't have a student account?",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                GestureDetector(
                                  onTap: () {
                                    context.push('/register/step1');
                                  },
                                  child: const Text(
                                    'Create Account',
                                    style: TextStyle(
                                      color: AppColors.primaryBlue,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ─── Universities and Companies Card ─────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC2DCFF),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.borderGrey,
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.account_balance,
                              color: Color.fromARGB(255, 3, 112, 236),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Universities and Companies',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Universities and companies must be registered through Tadreeby administration.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textGrey,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ─── helpers ─────────────────────────────────────────────
  void _handleLoginSuccess(BuildContext context, LoginSuccess state) {
    final user = state.user;
    final role = user.role;

    if (role == 'STUDENT' && user.studentProfile != null) {
      final status = user.studentProfile!.approvalStatus;

      if (status == 'PENDING') {
        context.go('/pending-status');
        return;
      } else if (status == 'REJECTED') {
        context.go('/rejected-status');
        return;
      }
    }

    switch (role) {
      case 'STUDENT':
        context.go('/student/dashboard');
        break;
      case 'SUPER_ADMIN':  
        context.go('/admin/dashboard');
        break;
      case 'UNIVERSITY_ADMIN':  
        context.go('/admin/dashboard');
        break;
      case 'COMPANY':
        context.go('/company/dashboard');
        break;
      case 'UNIVERSITY':
        context.go('/university/dashboard');
        break;
      default:
        context.go('/dashboard');
    }
  }




  void _showErrorSnackBar(BuildContext context, String message) {
  String displayMessage = message;
  
  if (message.contains('Invalid credentials')) {
    displayMessage = '❌ Invalid email or password. Please try again.';
  } else if (message.contains('PENDING')) {
    displayMessage = '⏳ Your account is pending approval.';
  } else if (message.contains('REJECTED')) {
    displayMessage = '❌ Your account has been rejected.';
  }
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(child: Text(displayMessage)),
        ],
      ),
      backgroundColor: Colors.red.shade700,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 4),
    ),
  );
}
}

// ============================================================
// TADREEBY LOGO
// ============================================================
class _TadreebyLogo extends StatelessWidget {
  const _TadreebyLogo();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/Asset1.png',
      width: 150,
      fit: BoxFit.contain,
    );
  }
}