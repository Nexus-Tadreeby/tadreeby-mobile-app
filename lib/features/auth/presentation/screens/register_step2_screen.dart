import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tadreeby/features/auth/presentation/cubit/register_data_cubit.dart';
import 'package:tadreeby/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:tadreeby/features/auth/presentation/widgets/registration_header.dart';
import '../../../../core/theme/app_colors.dart';

// ─── Main Screen ───────────────────────────────────────────────────
class RegisterStep2Screen extends StatefulWidget {
  const RegisterStep2Screen({super.key});

  @override
  State<RegisterStep2Screen> createState() => _RegisterStep2ScreenState();
}

class _RegisterStep2ScreenState extends State<RegisterStep2Screen> {
  final _formKey = GlobalKey<FormState>();
  final _studentNumberController = TextEditingController();

  String? _selectedUniversity;
  String? _selectedMajor;

  Map<String, dynamic>? _step1Data;

  final Map<String, List<String>> _existingStudentNumbers = {
    'Islamic University of Gaza': ['20210001', '20210002', '20210003'],
    'Al-Azhar University': ['20220001', '20220002'],
    'University of Palestine': ['20230001', '20230002', '20230003', '20230004'],
    'Al-Aqsa University': ['20210001', '20210002'],
    'Gaza University': ['20240001', '20240002'],
  };

  final List<String> _universities = [
    'Islamic University of Gaza',
    'Al-Azhar University',
    'University of Palestine',
    'Al-Aqsa University',
    'Gaza University',
  ];

  final List<String> _majors = [
    'Computer Science',
    'Information Technology',
    'Software Engineering',
    'Data Science',
    'Artificial Intelligence',
    'Computer Engineering',
    'Electrical Engineering',
    'Civil Engineering',
    'Business Administration',
    'Accounting',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routerState = GoRouterState.of(context);
    _step1Data = routerState.extra as Map<String, dynamic>?;

    if (_step1Data != null) {
      print('📝 Data from Step 1: $_step1Data');
    } else {
      print('⚠️ No data received from Step 1');
    }
  }

  @override
  void dispose() {
    _studentNumberController.dispose();
    super.dispose();
  }

  String? _validateStudentNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your student number';
  }

  final trimmedValue = value.trim();
  
  if (!RegExp(r'^[0-9]+$').hasMatch(trimmedValue)) {
    return 'Student number must contain only numbers';
  }

  if (trimmedValue.length < 7 || trimmedValue.length > 15) {
    return 'Student number must be between 7 and 15 digits';
  }

  if (_selectedUniversity == null || _selectedUniversity!.isEmpty) {
    return 'Please select a university first';
  }

  final existingNumbers = _existingStudentNumbers[_selectedUniversity] ?? [];
  if (existingNumbers.contains(trimmedValue)) {
    return 'This student number already exists in $_selectedUniversity';
  }

  return null;
}
  int _getUniversityId(String universityName) {
    final map = {
      'Islamic University of Gaza': 1,
      'Al-Azhar University': 2,
      'University of Palestine': 3,
      'Al-Aqsa University': 4,
      'Gaza University': 5,
    };
    return map[universityName] ?? 0;
  }


   @override
void initState() {
  super.initState();
  
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final cubit = context.read<RegisterDataCubit>();
    final data = cubit.allData;
    
    if (data.isNotEmpty) {
        final studentNumber = data['studentNumber'];
      if (studentNumber != null) {
        _studentNumberController.text = studentNumber.toString();
      }
      _selectedUniversity = data['universityName'];
      _selectedMajor = data['major'];
      setState(() {});
    }
  });
}

void _goToStep3() {
  if (_formKey.currentState!.validate()) {
    final studentNumberValue = _studentNumberController.text.trim();
    
        num studentNumber;
    try {
      studentNumber = num.parse(studentNumberValue);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid student number format. Please enter a valid number.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    
    context.read<RegisterDataCubit>().saveStep2Data(
      studentNumber: studentNumber,  
      universityId: _getUniversityId(_selectedUniversity ?? ''),
      universityName: _selectedUniversity ?? '',
      major: _selectedMajor ?? '',
    );
    
    context.push('/register/step3');
  }
}

  void _goBack() {
    Navigator.of(context).pop();
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),

                    const RegistrationHeader(
                      currentStep: 2,
                      stepTitle: 'Academic Information',
                      stepDescription: 'Please fill in your academic information\nto continue your registration.',
                    ),
                    const SizedBox(height: 38),

                    // ─── Student Number ───────────────────────────
                    CustomTextField(
                      label: 'Student Number',
                      hint: 'Enter your student number (7-15 digits)',
                      prefixIcon: Icons.person_outline,
                      controller: _studentNumberController,
                      keyboardType: TextInputType.number,
                      maxLength: 15,
                      showCounter: false, 
                      helperText: 'Must be 7-15 digits and unique within the university',
                      helperStyle: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textGrey,
                      ),
                      isRequired: true,
                      validator: _validateStudentNumber,
                      onChanged: (value) {
                        if (_selectedUniversity != null) {
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 40),

                    // ─── University ───────────────────────────────
                    const Text(
                      'University',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedUniversity,
                      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textGrey),
                      decoration: InputDecoration(
                        hintText: 'Select your university',
                        hintStyle: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 13),
                        prefixIcon: const Icon(Icons.school_outlined, color: AppColors.primaryBlue, size: 20),
                        border: _outlineBorder(AppColors.borderGrey),
                        enabledBorder: _outlineBorder(const Color(0xffC2DCFF)),
                        focusedBorder: _outlineBorder(AppColors.primaryBlue),
                        errorBorder: _outlineBorder(Colors.red),
                        focusedErrorBorder: _outlineBorder(Colors.red),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: _universities.map((university) {
                        return DropdownMenuItem<String>(
                          value: university,
                          child: Text(
                            university,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedUniversity = value);
                      },
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Please select your university';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),

                    // ─── Technical Specialization ─────────────────
                    const Text(
                      'Technical Specialization',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedMajor,
                      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textGrey),
                      decoration: InputDecoration(
                        hintText: 'Select your technical specialization',
                        hintStyle: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 13),
                        prefixIcon: const Icon(Icons.computer_outlined, color: AppColors.primaryBlue, size: 20),
                        border: _outlineBorder(AppColors.borderGrey),
                        enabledBorder: _outlineBorder(const Color(0xffC2DCFF)),
                        focusedBorder: _outlineBorder(AppColors.primaryBlue),
                        errorBorder: _outlineBorder(Colors.red),
                        focusedErrorBorder: _outlineBorder(Colors.red),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: _majors.map((major) {
                        return DropdownMenuItem<String>(
                          value: major,
                          child: Text(
                            major,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedMajor = value);
                      },
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Please select your specialization';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                  
                

                    // ─── Note Box ─────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color:AppColors.backgroundBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppColors.primaryBlue,
                            size:20 ,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: RichText(
                              textAlign: TextAlign.start,
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        'Note : Make sure all information is accurate.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textDark,
                                      fontWeight: FontWeight.bold,
                                      height: 1.5,
                                      
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "\nYou won't be able to change it later.",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textDark,
                                      fontWeight: FontWeight.normal,
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
          ),

          // ─── Bottom Buttons (fixed) ───────────────────────────
          Container(
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                // Back Button
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
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryBlue,
                              
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Next Step Button
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _goToStep3,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────────
  OutlineInputBorder _outlineBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: 1.2),
    );
  }
}
