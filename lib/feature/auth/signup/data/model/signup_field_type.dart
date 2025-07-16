enum SignUpFieldType {
  name,
  id,
  password,
  passwordConfirm,
  phone1,
  phone2,
  phone3,
  email,
  emailProvider,
}

extension SignUpFieldTypeExtension on SignUpFieldType {
  String get hintText {
    switch (this) {
      case SignUpFieldType.name:
        return "";
      case SignUpFieldType.id:
        return "";
      case SignUpFieldType.password:
        return "";
      case SignUpFieldType.passwordConfirm:
        return "";
      case SignUpFieldType.phone1:
        return "";
      case SignUpFieldType.phone2:
        return "";
      case SignUpFieldType.phone3:
        return "";
      case SignUpFieldType.email:
        return "";
      case SignUpFieldType.emailProvider:
        return "";
    }
  }

  String get apiKey {
    switch (this) {
      case SignUpFieldType.name:
        return "name";
      case SignUpFieldType.id:
        return "userId";
      case SignUpFieldType.password:
        return "password";
      case SignUpFieldType.passwordConfirm:
        return "passwordConfirm";
      case SignUpFieldType.phone1:
        return "phone1";
      case SignUpFieldType.phone2:
        return "phone2";
      case SignUpFieldType.phone3:
        return "phone3";
      case SignUpFieldType.email:
        return "email";
      case SignUpFieldType.emailProvider:
        return "emailProvider";
    }
  }

  bool get isPassword {
    return this == SignUpFieldType.password ||
        this == SignUpFieldType.passwordConfirm;
  }
}
