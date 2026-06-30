import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tadreeby/core/theme/app_colors.dart';
import 'package:tadreeby/features/auth/presentation/widgets/custom_text_field.dart';
import '../../cubit/forgot_password_cubit.dart';
import '../../cubit/forgot_password_state.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendVerificationCode() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      context.read<ForgotPasswordCubit>().sendVerificationCode(email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordLoading) {
            setState(() => _isLoading = true);
          } else if (state is ForgotPasswordSuccess) {
            setState(() => _isLoading = false);
            context.push(
              '/check-email',
              extra: _emailController.text.trim(),
            );
          } else if (state is ForgotPasswordError) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80),

                    // ─── Title ──────────────────────────────────
                    const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ─── Subtitle ──────────────────────────────
                    const Text(
                      'Enter your registered email address \n and we\'ll send you a 6-character \n verification code to reset your password.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textGrey,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // ─── Illustration ──────────────────────────
                    Center(
                      child: Image.asset(
                        'assets/images/forgot_password_illustration.png',
                        height: 200,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                          height: 180,
                          width: 200,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF4FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.lock_reset_outlined,
                            size: 80,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                   // ─── Email Field ────────────────────────────
CustomTextField(
  label: 'Email Address',
  hint: 'Enter your email',
  prefixIcon: Icons.email_outlined,
  controller: _emailController,
  keyboardType: TextInputType.emailAddress,
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
                    const SizedBox(height: 12),

                    // ─── Info Box ──────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF4FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppColors.primaryBlue,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              "We'll send a 6-character verification code to this email address.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // ─── Send Code Button ──────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _sendVerificationCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
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
                                'Send Code',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ─── Back to Login ──────────────────────────
                    GestureDetector(
                      onTap: () => context.go('/login'),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.primaryBlue,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Back to Login',
                            style: TextStyle(
                              color: AppColors.primaryBlue,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}