import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadreeby/core/utils/secure_storage_service.dart';
import 'package:tadreeby/features/auth/data/models/login_response_model.dart';
import 'package:tadreeby/features/auth/presentation/cubit/register_data_cubit.dart';
import 'package:tadreeby/features/auth/presentation/widgets/dashed_border_painter.dart';
import 'package:tadreeby/features/auth/presentation/widgets/registration_header.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/register_request_model.dart';
import '../cubit/register_cubit.dart';

// ─── Main Screen ───────────────────────────────────────────────────
class RegisterStep3Screen extends StatefulWidget {
  const RegisterStep3Screen({super.key});

  @override
  State<RegisterStep3Screen> createState() => _RegisterStep3ScreenState();
}

class _RegisterStep3ScreenState extends State<RegisterStep3Screen> {
  String? _selectedFilePath;
  String? _fileName;
  bool _isUploading = false;
  
  static const int maxFileSizeInMB = 10;
  static const int maxFileSizeInBytes = maxFileSizeInMB * 700 * 700; // 10 MB

  // ─── Lifecycle ──────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<RegisterDataCubit>();
      final data = cubit.allData;
      
      if (data.isNotEmpty) {
        final filePath = data['verificationDocumentPath'];
        if (filePath != null && filePath.isNotEmpty) {
          setState(() {
            _selectedFilePath = filePath;
            _fileName = filePath.split('/').last;
          });
        }
      }
    });
  }

  // ─── Validators ──────────────────────────────────────────────────
  String? _validateAllData(Map<String, dynamic> data) {
    if (data['firstName'] == null || data['firstName'].toString().isEmpty) {
      return 'First name is required';
    }

    if (data['lastName'] == null || data['lastName'].toString().isEmpty) {
      return 'Last name is required';
    }

    final nationalId = data['nationalId']?.toString() ?? '';
    if (nationalId.isEmpty) {
      return 'National ID is required';
    }
    if (nationalId.length != 9) {
      return 'National ID must be exactly 9 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(nationalId)) {
      return 'National ID must contain only numbers';
    }

    final email = data['email']?.toString() ?? '';
    if (email.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    final password = data['password']?.toString() ?? '';
    if (password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    final phone = data['phone']?.toString() ?? '';
    if (phone.isEmpty) {
      return 'Phone number is required';
    }
    if (phone.length != 10) {
      return 'Phone number must be exactly 10 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
      return 'Phone number must contain only numbers';
    }

    final studentNumber = data['studentNumber'];
    if (studentNumber == null) {
      return 'Student number is required';
    }
    
    if (studentNumber is! num) {
      return 'Invalid student number format';
    }
    
    if (studentNumber < 0) {
      return 'Student number cannot be negative';
    }
    
    final studentNumberStr = studentNumber.toString();
    if (studentNumberStr.length < 7 || studentNumberStr.length > 15) {
      return 'Student number must be between 7 and 15 digits';
    }
    
    final universityId = data['universityId'];
    if (universityId == null || universityId == 0) {
      return 'University selection is required';
    }

    final major = data['major']?.toString() ?? '';
    if (major.isEmpty) {
      return 'Major/Specialization is required';
    }

    if (_selectedFilePath == null || _selectedFilePath!.isEmpty) {
      return 'Verification document is required';
    }

    return null;
  }

  // ─── File Pickers ───────────────────────────────────────────────
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf'],
      );
      
      if (result != null) {
        final file = result.files.single;
        final path = file.path;
        final name = file.name;
        final sizeInBytes = file.size;
        
        print('📁 File size: ${(sizeInBytes / 700).toStringAsFixed(1)} KB');
        
        if (sizeInBytes > maxFileSizeInBytes) {
          final sizeInMB = (sizeInBytes / (700 * 700)).toStringAsFixed(1);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '❌ File size ($sizeInMB MB) exceeds the maximum limit of $maxFileSizeInMB MB.',
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 4),
            ),
          );
          return;
        }
        
        if (path != null && (name.endsWith('.jpg') || name.endsWith('.png') || name.endsWith('.jpeg'))) {
          final compressedPath = await _compressImage(path);
          if (compressedPath != null) {
            final compressedFile = File(compressedPath);
            final compressedSize = await compressedFile.length();
            print('✅ Compressed: ${(sizeInBytes / 700).toStringAsFixed(1)} KB → ${(compressedSize / 700).toStringAsFixed(1)} KB');
            
            setState(() {
              _selectedFilePath = compressedPath;
              _fileName = 'compressed_$name';
            });
            context.read<RegisterDataCubit>().saveStep3Data(
              verificationDocumentPath: compressedPath,
            );
            return;
          }
        }
        
        setState(() {
          _selectedFilePath = path;
          _fileName = name;
        });

        if (path != null) {
          context.read<RegisterDataCubit>().saveStep3Data(
            verificationDocumentPath: path,
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to pick file. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String?> _compressImage(String path) async {
    try {
      final File file = File(path);
      final bytes = await file.readAsBytes();
      final image = await decodeImageFromList(bytes);
      
      int width = image.width;
      int height = image.height;
      const maxDimension = 800;
      
      if (width > maxDimension || height > maxDimension) {
        if (width > height) {
          height = (height * maxDimension / width).round();
          width = maxDimension;
        } else {
          width = (width * maxDimension / height).round();
          height = maxDimension;
        }
      }
      
      final compressedBytes = await _compressImageBytes(bytes, width, height);
      
      final String compressedPath = '${path}_compressed.jpg';
      final File compressedFile = File(compressedPath);
      await compressedFile.writeAsBytes(compressedBytes);
      
      return compressedPath;
    } catch (e) {
      print('❌ Compression failed: $e');
      return path; 
    }
  }

  Future<Uint8List> _compressImageBytes(Uint8List bytes, int width, int height) async {
    final codec = await ui.instantiateImageCodec(bytes, targetWidth: width, targetHeight: height);
    final frame = await codec.getNextFrame();
    final image = frame.image;
    
    final byteData = await image.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );
    return byteData!.buffer.asUint8List();
  }

  Future<void> _takePhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 25,
      );

      if (image != null) {
        final fileSize = await image.length();
        print('📸 Image size: ${(fileSize / 700).toStringAsFixed(1)} KB');
        
        if (fileSize > maxFileSizeInBytes) {
          final sizeInMB = (fileSize / (700 * 700)).toStringAsFixed(1);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '❌ Image size ($sizeInMB MB) exceeds the maximum limit of $maxFileSizeInMB MB.',
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 4),
            ),
          );
          return;
        }
        
        final compressedPath = await _compressImage(image.path);
        if (compressedPath != null) {
          setState(() {
            _selectedFilePath = compressedPath;
            _fileName = 'compressed_${image.name}';
          });
          context.read<RegisterDataCubit>().saveStep3Data(
            verificationDocumentPath: compressedPath,
          );
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo captured and compressed successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          return;
        }
        
        setState(() {
          _selectedFilePath = image.path;
          _fileName = image.name;
        });

        context.read<RegisterDataCubit>().saveStep3Data(
          verificationDocumentPath: image.path,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo captured successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to capture photo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ─── Submit Registration ────────────────────────────────────────
  void _submitRegistration() {
    final allData = context.read<RegisterDataCubit>().allData;
    
    final validationError = _validateAllData(allData);
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ $validationError'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }
    
    final num studentNumber = allData['studentNumber'] as num;

    final registerRequest = RegisterRequestModel(
      firstName: allData['firstName'] ?? '',
      lastName: allData['lastName'] ?? '',
      personalID: int.tryParse(allData['nationalId']?.toString() ?? '0') ?? 0,
      studentNumber: studentNumber,  
      phone: allData['phone'] ?? '',
      email: allData['email'] ?? '',
      password: allData['password'] ?? '',
      confirmPassword: allData['password'] ?? '',
      universityId: allData['universityId'] ?? 0,
      major: allData['major'] ?? '',
      verificationDocumentPath: _selectedFilePath!,
    );
    
    registerRequest.printData();
    
    context.read<RegisterCubit>().register(registerRequest);
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  // ─── Handle Success ─────────────────────────────────────────────
  void _handleRegisterSuccess(BuildContext context, LoginResponseModel response) {
    final storage = SecureStorageService();
    storage.saveAccessToken(response.accessToken);
    storage.saveRefreshToken(response.refreshToken);

    context.read<RegisterDataCubit>().clearData();

    final user = response.user;
    if (user.role == 'STUDENT' && user.studentProfile != null) {
      final status = user.studentProfile!.approvalStatus;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            status == 'PENDING'
                ? 'Account created! Waiting for approval.'
                : 'Registration successful!',
          ),
          backgroundColor: status == 'PENDING' ? Colors.orange : Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      if (status == 'PENDING') {
        context.go('/pending-status');
      } else if (status == 'ACTIVE') {
        context.go('/student/dashboard');
      } else {
        context.go('/dashboard');
      }
    } else {
      context.go('/dashboard');
    }
  }

  // ─── Build ──────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryBlue, size: 25),
          onPressed: _goBack,
        ),
        title: const Text(
          'Student Registration',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterLoading) {
            setState(() {
              _isUploading = true;
            });
          } else if (state is RegisterSuccess) {
            setState(() {
              _isUploading = false;
            });
            _handleRegisterSuccess(context, state.response);
          } else if (state is RegisterError) {
            setState(() {
              _isUploading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Registration failed: ${state.message}'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      const RegistrationHeader(
                        currentStep: 3,
                        stepTitle: 'Verification',
                        stepDescription: 'Upload proof of your university enrollment.',
                      ),
                      const SizedBox(height: 5),

                      // ─── Verification Requirements ─────────
                      const Text(
                        'Verification Requirements',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildBulletItem('Full Student Name'),
                      _buildBulletItem('University Name'),
                      _buildBulletItem('Student Number'),
                      _buildBulletItem('Technical Specialization'),
                      const SizedBox(height: 14),

                      const Text(
                        'Accepted Documents',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildBulletItem('University Student Card'),
                      _buildBulletItem('Screenshot from Student Portal'),
                      const SizedBox(height: 20),

                      // ─── Upload Area ────────────────────────
                      GestureDetector(
                        onTap: _pickFile,
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 32),
                              decoration: BoxDecoration(
                                color: AppColors.uploadBg,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: _selectedFilePath != null
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.check_circle,
                                          color: AppColors.successGreen,
                                          size: 48,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          _fileName ?? 'File selected',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textDark,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          'Tap to change file',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textGrey,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        _buildUploadIcon(),
                                        const SizedBox(height: 12),
                                        const Text(
                                          'Upload University Card',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryBlue,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          'JPG, PNG or PDF (Max. 10MB)',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                            Positioned.fill(
                              child: IgnorePointer(
                                child: CustomPaint(
                                  painter: DashedBorderPainter(
                                    color: _selectedFilePath != null
                                        ? AppColors.successGreen
                                        : AppColors.primaryBlue,
                                    strokeWidth: 1.5,
                                    dashLength: 8,
                                    dashSpace: 6,
                                    radius: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // ─── OR Divider ─────────────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: AppColors.borderGrey,
                              thickness: 1,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'or',
                              style: TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: AppColors.borderGrey,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // ─── Take Photo Row ─────────────────────────────
                      GestureDetector(
                        onTap: _takePhoto,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: AppColors.borderGrey, width: 1.2),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.uploadBg,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: AppColors.primaryBlue,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Take Photo',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Use your camera to take a photo',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // ─── Note Box ───────────────────────────────────
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundOrange,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.borderOrange,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: AppColors.textOrange,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: RichText(
                                textAlign: TextAlign.start,
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          'Note : Make sure the document is clear and all information is visible.',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textOrange,
                                        fontWeight: FontWeight.bold,
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
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

              // ─── Bottom Buttons (Fixed) ─────────────────────────────
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    // Back
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton(
                          onPressed: _goBack,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textDark,
                            side: const BorderSide(
                                color: AppColors.primaryBlue, width: 1.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 6),
                              Text(
                                'Back',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.primaryBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Submit
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isUploading ? null : _submitRegistration,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryOrange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: _isUploading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Submit Application',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ─── UI Helpers ──────────────────────────────────────────────────
  Widget _buildUploadIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.uploadBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Image.asset(
        'assets/icons/uploadfile.png',
        width: 60,
        height: 60,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_upload_outlined,
                color: AppColors.primaryBlue,
                size: 40,
              ),
              const SizedBox(height: 4),
              const Icon(
                Icons.card_membership_outlined,
                color: AppColors.primaryBlue,
                size: 20,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: AppColors.primaryBlue,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}