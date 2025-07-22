import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ormee_app/core/constants/api.dart';

class ApiService {
  static const String _baseUrl = API.hostConnect;

  /// 아이디 중복 체크
  /// [id] : 체크할 아이디 문자열
  /// true: 중복됨 / false: 사용 가능
  static Future<bool> checkIdDuplication(String id) async {
    final url = Uri.parse('$_baseUrl/students/username');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': id}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // 서버에서 {"duplicated": true} 형태로 응답한다고 가정
      return data['data'] == true;
    } else if (response.statusCode == 409) {
      return false;
    } else {
      throw Exception(
        'Failed to check ID duplication. Code: ${response.statusCode}',
      );
    }
  }
}
