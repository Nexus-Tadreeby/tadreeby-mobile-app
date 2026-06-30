import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tadreeby/features/auth/presentation/cubit/register_data_cubit.dart';
import 'package:tadreeby/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:tadreeby/features/auth/presentation/widgets/registration_header.dart';
import '../../../../core/theme/app_colors.dart';

// ─── Main Screen ───────────────────────────────────────────────────
class RegisterStep1Screen extends StatefulWidget {
  const RegisterStep1Screen({super.key});

  @override
  State<RegisterStep1Screen> createState() => _RegisterStep1ScreenState();
}

class _RegisterStep1ScreenState extends State<RegisterStep1Screen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;
  bool _hasNoSpaces = true;
  bool _hasLowercase = false;

  bool get _isPasswordValid {
    return _hasMinLength &&
        _hasUppercase &&
        _hasLowercase &&
        _hasNumber &&
        _hasSpecialChar &&
        _hasNoSpaces;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nationalIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _validatePassword(String password) {
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasNumber = password.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      _hasNoSpaces = !password.contains(' ');
      _hasLowercase = password.contains(RegExp(r'[a-z]'));
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<RegisterDataCubit>();
      final data = cubit.allData;

      if (data.isNotEmpty) {
        _firstNameController.text = data['firstName'] ?? '';
        _lastNameController.text = data['lastName'] ?? '';
        _nationalIdController.text = data['nationalId'] ?? '';
        _emailController.text = data['email'] ?? '';
        _passwordController.text = data['password'] ?? '';
        _confirmPasswordController.text = data['password'] ?? '';
        _phoneController.text = data['phone'] ?? '';

        _validatePassword(data['password'] ?? '');
        setState(() {});
      }
    });
  }

  void _goToStep2() {
    if (_formKey.currentState!.validate()) {
      if (!_isPasswordValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please meet all password requirements'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return; 
      }

      context.read<RegisterDataCubit>().saveStep1Data(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        nationalId: _nationalIdController.text,
        email: _emailController.text,
        password: _passwordController.text,
        phone: _phoneController.text,
      );

      context.push('/register/step2');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryBlue, size: 25),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Student Registration',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),

              const RegistrationHeader(
                currentStep: 1,
                stepTitle: 'Basic Information',
                stepDescription: 'Please fill in your basic information\nto create your account.',
              ),

              const SizedBox(height: 20),

              // ─── First Name + Last Name (Row) ───────────────────
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
  
    label: 'First Name',
    hint: 'Enter your first name',
    prefixIcon: Icons.person_outline,
    controller: _firstNameController,
    isRequired: true,
    maxLength: 25,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'First name is required';
      }
      if (value.length < 2) {
        return 'First name must be at least 2 characters';
      }
      if (value.length > 25) {
        return 'First name cannot exceed 25 characters';
      }
      if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
        return 'Name must contain only letters and spaces';
      }
      return null;
    },
  ),
),
 const SizedBox(width: 9),
Expanded(
  child: CustomTextField(
    label: 'Last Name',
    hint: 'Enter your last name',
    prefixIcon: Icons.person_outline,
    controller: _lastNameController,
    isRequired: true,
    maxLength: 25,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Last name is required';
      }
      if (value.length < 2) {
        return 'Last name must be at least 2 characters';
      }
      if (value.length > 25) {
        return 'Last name cannot exceed 25 characters';
      }
      if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
        return 'Name must contain only letters and spaces';
      }
      return null;
    },
  ),
),
                ],
              ),
              const SizedBox(height: 14),

              // ─── National ID ────────────────────────────────────
              CustomTextField(
                label: 'National ID',
                hint: 'Enter your national ID number',
                prefixIcon: Icons.credit_card_outlined,
                controller: _nationalIdController,
                keyboardType: TextInputType.number,
                isRequired: true,
                maxLength: 9,
                showCounter: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your national ID';
                  }
                  if (value.length != 9) {
                    return 'National ID must be exactly 9 digits';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'National ID must contain only numbers';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // ─── Email ──────────────────────────────────────────
              CustomTextField(
                label: 'Email',
                hint: 'Enter your email address',
                prefixIcon: Icons.email_outlined,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                isRequired: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please enter your email';
                  if (!RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // ─── Phone ──────────────────────────────────────────
              CustomTextField(
                label: 'Phone Number',
                hint: 'Enter your phone number (e.g. 0591234567)',
                prefixIcon: Icons.phone_outlined,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                isRequired: true,
                maxLength: 10,
                showCounter: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  if (value.length != 10) {
                    return 'Phone number must be exactly 10 digits';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Phone number must contain only numbers';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // ─── Password ───────────────────────────────────────
              CustomTextField(
                label: 'Password',
                hint: 'Create a password',
                prefixIcon: Icons.lock_outline,
                controller: _passwordController,
                obscureText: _obscurePassword,
                isRequired: true,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.primaryBlue,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                onChanged: _validatePassword,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please create a password';
                  if (v.length < 8) return 'Password must be at least 8 characters';
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // ─── Confirm Password ───────────────────────────────
              CustomTextField(
                label: 'Confirm Password',
                hint: 'Confirm your password',
                prefixIcon: Icons.lock_outline,
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                isRequired: true,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.primaryBlue,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please confirm your password';
                  if (v != _passwordController.text) return 'Passwords do not match';
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // ─── Password Requirements Box ──────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primaryBlue, width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.lock, color: AppColors.primaryBlue, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Password must contain:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildRequirementItem('At least 8 characters', _hasMinLength),
                    _buildRequirementItem('One uppercase letter (A-Z)', _hasUppercase),
                    _buildRequirementItem('One lowercase letter (a-z)', _hasLowercase),
                    _buildRequirementItem('One number (0-9)', _hasNumber),
                    _buildRequirementItem('One special character', _hasSpecialChar),
                    _buildRequirementItem('No spaces', _hasNoSpaces),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ─── Next Step Button ───────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _goToStep2,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Next Step',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────────
  Widget _buildRequirementItem(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.cancel_outlined,
            color: isValid ? Colors.green : Colors.red,
            size: 17,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isValid ? AppColors.textDark : AppColors.textGrey,
              fontWeight: isValid ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}