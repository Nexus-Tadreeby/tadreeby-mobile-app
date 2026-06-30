// lib/features/auth/presentation/screens/forgot_password/check_email_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tadreeby/core/theme/app_colors.dart';
import '../../cubit/forgot_password_cubit.dart';
import '../../cubit/forgot_password_state.dart';

class CheckEmailScreen extends StatefulWidget {
  const CheckEmailScreen({super.key});

  @override
  State<CheckEmailScreen> createState() => _CheckEmailScreenState();
}

class _CheckEmailScreenState extends State<CheckEmailScreen> {
  final _codeController = TextEditingController();
  final _focusNode = FocusNode();
  String? _email;
  bool _isLoading = false;
  bool _isCodeVerified = false;

  // ⏱️ Timer for resend
  int _resendSeconds = 60;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra;
    if (extra is String) {
      _email = extra;
    }
  }

  void _startTimer() {
    _resendSeconds = 60;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendSeconds > 0) {
          _resendSeconds--;
        } else {
          _canResend = true;
          _timer?.cancel();
        }
      });
    });
  }

  void _verifyCode() {
    final code = _codeController.text.trim();
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the 6-character verification code.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (_email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email not found. Please try again.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    context.read<ForgotPasswordCubit>().verifyCode(_email!, code);
  }

  void _resendCode() {
    if (_email != null && _canResend) {
      context.read<ForgotPasswordCubit>().sendVerificationCode(_email!);
      _startTimer();
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _focusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String displayEmail = _email ?? 'your email';
    if (_email != null && _email!.contains('@')) {
      final parts = _email!.split('@');
      final name = parts[0];
      final domain = parts[1];
      if (name.length > 3) {
        displayEmail =
            '${name.substring(0, 2)}*****@${domain.length > 3 ? domain.substring(0, 3) : domain}...';
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is VerifyResetCodeLoading) {
            setState(() => _isLoading = true);
          } else if (state is VerifyResetCodeSuccess) {
            setState(() {
              _isLoading = false;
              _isCodeVerified = true;
            });
            context.push(
              '/create-new-password',
              extra: state.response.resetToken,
            );
          } else if (state is VerifyResetCodeError) {
            setState(() => _isLoading = false);
            _codeController.clear();
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is ForgotPasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Verification code sent successfully!'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: GestureDetector(
              onTap: () {
                _focusNode.requestFocus();
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),

                    // ─── Illustration (paper plane) ───────────────
                    Center(
                      child: Image.asset(
                        'assets/images/check_email_illustration.png',
                        height: 150,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 150,
                          width: 150,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEEF4FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.email_outlined,
                            color: AppColors.primaryBlue,
                            size: 60,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ─── Title ──────────────────────────────────────
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                        children: [
                          TextSpan(text: 'Check Your '),
                          TextSpan(
                            text: 'Email',
                            style: TextStyle(color: AppColors.primaryBlue),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ─── Subtitle ──────────────────────────────────
                    const Text(
                      "We've sent a 6-character verification code to",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textGrey,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      displayEmail,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ─── 6 OTP Boxes ───────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (index) {
                        final char = _codeController.text.length > index
                            ? _codeController.text[index]
                            : '';
                        return Padding(
                          padding: EdgeInsets.only(right: index < 5 ? 12 : 0),
                          child: _buildCodeBox(char),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),

                    Offstage(
                      offstage: true, 
                      child: SizedBox(
                        height: 0,
                        width: 0,
                        child: TextFormField(
                          controller: _codeController,
                          maxLength: 6,
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          focusNode: _focusNode,
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            hintText: '',
                          ),
                          onChanged: (value) {
                            setState(() {});
                            if (value.length == 6) {
                              _verifyCode();
                            }
                          },
                        ),
                      ),
                    ),
                    
                    // ─── Info Card (grey box) ─────────────────────
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundBlue,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          // Timer row
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFDDE6F8),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.access_time_outlined,
                                    color: AppColors.primaryBlue,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      height: 1.4,
                                    ),
                                    children: [
                                      TextSpan(text: 'The code will expire in '),
                                      TextSpan(
                                        text: '15 minutes.',
                                        style: TextStyle(
                                          color: AppColors.primaryBlue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Divider
                          const Divider(
                            height: 1,
                            thickness: 0.5,
                            color: Color.fromARGB(255, 132, 124, 124),
                            indent: 16,
                            endIndent: 16,
                          ),

                          // Spam folder row
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFDDE6F8),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.shield_outlined,
                                    color: AppColors.primaryBlue,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      height: 1.4,
                                    ),
                                    children: [
                                      TextSpan(
                                          text: "Didn't receive the code?\nCheck your "),
                                      TextSpan(
                                        text: 'spam folder.',
                                        style: TextStyle(
                                          color: AppColors.primaryBlue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                   // ─── Resend Button ─────────────────────────────────────────────
SizedBox(
  width: double.infinity,
  height: 52,
  child: OutlinedButton(
    onPressed: _canResend ? _resendCode : null,
    style: OutlinedButton.styleFrom(
      backgroundColor: Colors.white,
      side: BorderSide(
        color: _canResend 
            ? AppColors.primaryBlue  
            : Colors.grey.shade300,  
        width: 1.5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 0,
    ),
    child: Text(
      _canResend
          ? 'Resend Code'
          : 'Resend Code (${_resendSeconds.toString().padLeft(2, '0')}:00)',
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: _canResend
            ? AppColors.primaryBlue 
            : Colors.grey.shade400,    
      ),
    ),
  ),
),
                    const SizedBox(height: 16),

                    // ─── Next Button ──────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading || _codeController.text.length != 6
                            ? null
                            : _verifyCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                          disabledBackgroundColor: Colors.grey.shade300,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Next',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ─── Back to Login ────────────────────────────
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

  Widget _buildCodeBox(String char) {
    final bool filled = char.isNotEmpty;
    return Container(
      width: 48,
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: filled ? AppColors.primaryBlue : const Color(0xFFE0E0E0),
          width: filled ? 2 : 1.2,
        ),
        boxShadow: filled
            ? [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          char,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: filled ? AppColors.textDark : Colors.transparent,
          ),
        ),
      ),
    );
  }
}