part of 'signup_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class FieldChanged extends SignUpEvent {
  final SignUpFieldType fieldType;
  final String value;

  const FieldChanged(this.fieldType, this.value);

  @override
  List<Object> get props => [fieldType, value];
}

class FieldValidated extends SignUpEvent {
  final SignUpFieldType fieldType;

  const FieldValidated(this.fieldType);

  @override
  List<Object> get props => [fieldType];
}

class SubmitSignUp extends SignUpEvent {
  const SubmitSignUp();
}

class ValidateFields extends SignUpEvent {
  const ValidateFields();
}

class CheckIdDuplication extends SignUpEvent {
  final String id;
  const CheckIdDuplication(this.id);

  @override
  List<Object> get props => [id];
}
