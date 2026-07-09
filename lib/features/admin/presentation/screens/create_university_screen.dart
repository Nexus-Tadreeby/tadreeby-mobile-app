import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../features/auth/presentation/widgets/custom_text_field.dart';
import '../cubits/create_university_cubit.dart';

class CreateUniversityScreen extends StatefulWidget {
  const CreateUniversityScreen({super.key});

  @override
  State<CreateUniversityScreen> createState() => _CreateUniversityScreenState();
}

class _CreateUniversityScreenState extends State<CreateUniversityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _shortCodeController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _logoPath;
  final bool _isUploading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _shortCodeController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }


Future<void> _pickLogo() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      setState(() {
        _logoPath = result.files.single.path;
      });
      // Save logo file in cubit
      context.read<CreateUniversityCubit>().setLogoFile(file);
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to pick logo. Please try again.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

void _submit() {
  if (_formKey.currentState!.validate()) {
    final cubit = context.read<CreateUniversityCubit>();
    cubit.createUniversity(
      name: _nameController.text.trim(),
      shortCode: _shortCodeController.text.trim().toUpperCase(),
      email: _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : null,
      phone: _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
      location: _locationController.text.trim().isNotEmpty ? _locationController.text.trim() : null,
      description: _descriptionController.text.trim().isNotEmpty ? _descriptionController.text.trim() : null,
    );
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
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Add University',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<CreateUniversityCubit, CreateUniversityState>(
        listener: (context, state) {
          if (state is CreateUniversitySuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
            context.read<CreateUniversityCubit>().reset();
            context.pop();
          } else if (state is CreateUniversityError) {
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
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Title ──────────────────────────────────────────
                  const Text(
                    'Create a new university',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ─── Name ───────────────────────────────────────────
                  CustomTextField(
                    label: 'University Name',
                    hint: 'Enter university name',
                    prefixIcon: Icons.school_outlined,
                    controller: _nameController,
                    isRequired: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter university name';
                      }
                      if (value.length < 3) {
                        return 'Name must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ─── Short Code ─────────────────────────────────────
                  CustomTextField(
                    label: 'Short Code',
                    hint: 'Enter short code (e.g., IUG)',
                    prefixIcon: Icons.code_outlined,
                    controller: _shortCodeController,
                    isRequired: true,
                    maxLength: 10,
                    showCounter: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a short code';
                      }
                      if (value.length < 2) {
                        return 'Short code must be at least 2 characters';
                      }
                      if (!RegExp(r'^[A-Za-z0-9]+$').hasMatch(value)) {
                        return 'Only letters and numbers allowed';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ─── Email ──────────────────────────────────────────
                  CustomTextField(
                    label: 'Email',
                    hint: 'Enter email address',
                    prefixIcon: Icons.email_outlined,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    isRequired: false,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (!RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ─── Phone ──────────────────────────────────────────
                  CustomTextField(
                    label: 'Phone',
                    hint: 'Enter phone number',
                    prefixIcon: Icons.phone_outlined,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    isRequired: false,
                    maxLength: 15,
                    showCounter: false,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (!RegExp(r'^[0-9+\-()\s]+$').hasMatch(value)) {
                          return 'Please enter a valid phone number';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ─── Location ───────────────────────────────────────
                  CustomTextField(
                    label: 'Location',
                    hint: 'Enter location',
                    prefixIcon: Icons.location_on_outlined,
                    controller: _locationController,
                    isRequired: false,
                  ),
                  const SizedBox(height: 16),

                  // ─── Description ────────────────────────────────────
                  CustomTextField(
                    label: 'Description',
                    hint: 'Enter description',
                    prefixIcon: Icons.description_outlined,
                    controller: _descriptionController,
                    isRequired: false,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),

                  // ─── Logo Upload ────────────────────────────────────
                  const Text(
                    'Logo (Optional)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickLogo,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: AppColors.uploadBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.borderGrey,
                          width: 1.5,
                        ),
                      ),
                      child: _logoPath != null
                          ? Column(
                              children: [
                                Image.file(
                                  File(_logoPath!),
                                  height: 80,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Tap to change logo',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                              ],
                            )
                          : const Column(
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  size: 48,
                                  color: AppColors.primaryBlue,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Upload University Logo',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'JPG, PNG or GIF (Max. 5MB)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ─── Buttons ────────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: OutlinedButton(
                            onPressed: state is CreateUniversityLoading
                                ? null
                                : () => context.pop(),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.borderGrey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: state is CreateUniversityLoading
                                ? null
                                : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryOrange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: state is CreateUniversityLoading
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
                                    'Create University',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}