import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ormee_app/core/constants/api.dart';
import 'package:ormee_app/feature/auth/token/update.dart';
import 'package:ormee_app/feature/homework/create/data/model.dart';

class HomeworkCreateRemoteDataSource {
  final http.Client client;

  HomeworkCreateRemoteDataSource(this.client);

  Future<void> postHomework(int homeworkId, HomeworkRequest request) async {
    final accessToken = await AuthStorage.getAccessToken();
    final response = await client.post(
      Uri.parse('${API.hostConnect}/students/homeworks/$homeworkId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('숙제 등록 실패: ${response.body}');
    }
  }
}
