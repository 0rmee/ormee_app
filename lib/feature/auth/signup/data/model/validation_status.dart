enum ValidationStatus {
  initial, // 초기 상태 (메시지 없음)
  valid, // 유효한 상태
  invalid, // 유효하지 않은 상태
  checking, // API 호출 중 (전화번호, 이메일)
  checked,
}

class ValidationResult {
  final ValidationStatus status;
  final String message;

  const ValidationResult({required this.status, required this.message});

  static const ValidationResult initial = ValidationResult(
    status: ValidationStatus.initial,
    message: '',
  );

  static const ValidationResult idInitial = ValidationResult(
    status: ValidationStatus.initial,
    message: '영문, 숫자, 일부 특수문자(_) 포함 4~15자',
  );
  static const ValidationResult pwInitial = ValidationResult(
    status: ValidationStatus.initial,
    message: '영문, 숫자, 특수문자 2종 이상 포함 8~16자',
  );

  static const ValidationResult checking = ValidationResult(
    status: ValidationStatus.checking,
    message: '',
  );

  // 에러 메시지들
  static const ValidationResult nameError = ValidationResult(
    status: ValidationStatus.invalid,
    message: '영문, 특수문자, 숫자 입력 불가',
  );

  static const ValidationResult idError = ValidationResult(
    status: ValidationStatus.invalid,
    message: '영문, 숫자, 일부 특수문자(_) 포함 4~15자',
  );

  static const ValidationResult passwordError = ValidationResult(
    status: ValidationStatus.invalid,
    message: '영문, 숫자, 특수문자 2종 이상 포함 8~16자',
  );

  static const ValidationResult passwordConfirmError = ValidationResult(
    status: ValidationStatus.invalid,
    message: '비밀번호가 일치하지 않아요.',
  );

  static const ValidationResult phoneError = ValidationResult(
    status: ValidationStatus.invalid,
    message: '이미 등록된 연락처예요.',
  );

  static const ValidationResult emailError = ValidationResult(
    status: ValidationStatus.invalid,
    message: '이미 등록된 이메일이에요.',
  );

  // 성공 메시지들
  static const ValidationResult nameValid = ValidationResult(
    status: ValidationStatus.valid,
    message: '',
  );

  static const ValidationResult idValid = ValidationResult(
    status: ValidationStatus.valid,
    message: '영문, 숫자, 일부 특수문자(_) 포함 4~15자',
  );

  static const ValidationResult passwordValid = ValidationResult(
    status: ValidationStatus.valid,
    message: '사용 가능한 비밀번호예요.',
  );

  static const ValidationResult passwordConfirmValid = ValidationResult(
    status: ValidationStatus.valid,
    message: '비밀번호 일치',
  );

  static const ValidationResult phoneValid = ValidationResult(
    status: ValidationStatus.valid,
    message: '',
  );

  static const ValidationResult emailValid = ValidationResult(
    status: ValidationStatus.valid,
    message: '사용 가능한 이메일이에요.',
  );
}
