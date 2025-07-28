import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/homework/create/data/model.dart';

class HomeworkCreateRemoteDataSource {
  final http.Client client;

  HomeworkCreateRemoteDataSource(this.client);

  final Dio _dio = ApiClient.instance.dio;

  Future<void> postHomework(int homeworkId, HomeworkRequest request) async {
    final response = await _dio.post(
      '/students/homeworks/$homeworkId',
      data: request,
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('숙제 등록 실패: ${response.data}');
    }
  }
}
