// lib/features/auth/presentation/cubit/register_data_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

// ─── State ──────────────────────────────────────────────
class RegisterDataState {
  final Map<String, dynamic> data;
  
  RegisterDataState({this.data = const {}});
  
  RegisterDataState copyWith({Map<String, dynamic>? data}) {
    return RegisterDataState(data: data ?? this.data);
  }
}

// ─── Cubit ────────────────────────────────────────────────
class RegisterDataCubit extends Cubit<RegisterDataState> {
  RegisterDataCubit() : super(RegisterDataState());

  void saveStep1Data({
    required String firstName,
    required String lastName,
    required String nationalId,
    required String email,
    required String password,
     required String  phone,
  }) {
    final newData = Map<String, dynamic>.from(state.data)
      ..['firstName'] = firstName
      ..['lastName'] = lastName
      ..['nationalId'] = nationalId
      ..['email'] = email
      ..['password'] = password
      ..['phone'] = phone;
    
    emit(state.copyWith(data: newData));
  }

  void saveStep2Data({
    required String studentNumber,
    required int universityId,
    required String universityName,
    required String major,
  }) {
    final newData = Map<String, dynamic>.from(state.data)
      ..['studentNumber'] = studentNumber
      ..['universityId'] = universityId
      ..['universityName'] = universityName
      ..['major'] = major;
    
    emit(state.copyWith(data: newData));
  }

  void saveStep3Data({
    required String verificationDocumentPath,
  }) {
    final newData = Map<String, dynamic>.from(state.data)
      ..['verificationDocumentPath'] = verificationDocumentPath;
    
    emit(state.copyWith(data: newData));
  }

  Map<String, dynamic> get allData => state.data;

  void clearData() {
    emit(RegisterDataState(data: {}));
  }
}