abstract class LoginEvent {}

class IdChanged extends LoginEvent {
  final String id;
  IdChanged(this.id);
}

class PwChanged extends LoginEvent {
  final String pw;
  PwChanged(this.pw);
}

class LoginSubmitted extends LoginEvent {
  final String username;
  final String password;

  LoginSubmitted({required this.username, required this.password});
}
