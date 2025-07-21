import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/core/constants/api.dart';
import 'package:ormee_app/feature/auth/token/update.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'package:http/http.dart' as http;

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<IdChanged>((event, emit) {
      emit(state.copyWith(isIdNotEmpty: event.id.isNotEmpty));
    });
    on<PwChanged>((event, emit) {
      emit(state.copyWith(isPwNotEmpty: event.pw.isNotEmpty));
    });
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      final response = await http.post(
        Uri.parse('${API.hostConnect}/students/signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': event.username,
          'password': event.password,
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print(json); // 개발할 때 토큰 확인용. 추후 삭제하기
        final accessToken = json['data']['accessToken'];
        final refreshToken = json['data']['refreshToken'];

        // 토큰 저장
        await AuthStorage.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );

        emit(
          state.copyWith(
            status: LoginStatus.success,
            accessToken: accessToken,
            refreshToken: refreshToken,
          ),
        );
      } else {
        emit(state.copyWith(status: LoginStatus.failure));
      }
    } catch (_) {
      emit(state.copyWith(status: LoginStatus.failure));
    }
  }
}
