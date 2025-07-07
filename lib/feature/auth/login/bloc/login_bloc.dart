import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

    const secureStorage = FlutterSecureStorage();

    try {
      final response = await http.post(
        Uri.parse('https://52.78.13.49.nip.io:8443/student/signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': event.username,
          'password': event.password,
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final accessToken = json['data']['accessToken'];
        final refreshToken = json['data']['refreshToken'];

        // 토큰 저장
        await secureStorage.write(key: 'accessToken', value: accessToken);
        await secureStorage.write(key: 'refreshToken', value: refreshToken);

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
