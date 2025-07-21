part of 'signup_bloc.dart';

class SignUpState extends Equatable {
  final Map<SignUpFieldType, String> fieldValues;
  final Map<SignUpFieldType, bool> isFieldNotEmpty;
  final Map<SignUpFieldType, ValidationResult> validationResults;
  final bool isValid;
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const SignUpState({
    required this.fieldValues,
    required this.isFieldNotEmpty,
    required this.validationResults,
    this.isValid = false,
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  factory SignUpState.initial() {
    final Map<SignUpFieldType, String> initialValues = {};
    final Map<SignUpFieldType, bool> initialNotEmpty = {};
    final Map<SignUpFieldType, ValidationResult> initialValidation = {};

    for (SignUpFieldType type in SignUpFieldType.values) {
      initialValues[type] = '';
      initialNotEmpty[type] = false;

      // ID와 PW 필드에만 초기 안내 문구 설정
      if (type == SignUpFieldType.id) {
        initialValidation[type] = ValidationResult.idInitial;
      } else if (type == SignUpFieldType.password) {
        initialValidation[type] = ValidationResult.pwInitial;
      } else {
        initialValidation[type] = ValidationResult.initial;
      }
    }

    return SignUpState(
      fieldValues: initialValues,
      isFieldNotEmpty: initialNotEmpty,
      validationResults: initialValidation,
    );
  }

  SignUpState copyWith({
    Map<SignUpFieldType, String>? fieldValues,
    Map<SignUpFieldType, bool>? isFieldNotEmpty,
    Map<SignUpFieldType, ValidationResult>? validationResults,
    bool? isValid,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return SignUpState(
      fieldValues: fieldValues ?? this.fieldValues,
      isFieldNotEmpty: isFieldNotEmpty ?? this.isFieldNotEmpty,
      validationResults: validationResults ?? this.validationResults,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [
    fieldValues,
    isFieldNotEmpty,
    validationResults,
    isValid,
    isLoading,
    errorMessage,
    isSuccess,
  ];
}
