import 'package:equatable/equatable.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final bool isIdNotEmpty;
  final bool isPwNotEmpty;
  final LoginStatus status;
  final String? accessToken;
  final String? refreshToken;

  const LoginState({
    this.isIdNotEmpty = false,
    this.isPwNotEmpty = false,
    this.status = LoginStatus.initial,
    this.accessToken,
    this.refreshToken,
  });

  bool get isFormValid => isIdNotEmpty && isPwNotEmpty;

  LoginState copyWith({
    bool? isIdNotEmpty,
    bool? isPwNotEmpty,
    LoginStatus? status,
    String? accessToken,
    String? refreshToken,
  }) {
    return LoginState(
      isIdNotEmpty: isIdNotEmpty ?? this.isIdNotEmpty,
      isPwNotEmpty: isPwNotEmpty ?? this.isPwNotEmpty,
      status: status ?? this.status,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  @override
  List<Object?> get props => [
    isIdNotEmpty,
    isPwNotEmpty,
    status,
    accessToken,
    refreshToken,
  ];
}
