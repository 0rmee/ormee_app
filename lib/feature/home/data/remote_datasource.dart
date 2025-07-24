import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ormee_app/core/constants/api.dart';
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/auth/token/update.dart';
import 'package:ormee_app/feature/home/data/models/homework_card.dart';
import 'package:ormee_app/feature/home/data/models/lecture_card.dart';
import 'package:ormee_app/feature/home/data/models/quiz_card.dart';

class HomeRemoteDataSource {
  final http.Client client;

  HomeRemoteDataSource(this.client);

  // 강의 목록
  Future<List<LectureCard>> fetchLectures() async {
    final response = await ApiClient.instance.dio.get('/students/lectures');

    if (response.statusCode == 200) {
      final List data = response.data['data'];
      return data.map((e) => LectureCard.fromJson(e)).toList();
    } else {
      throw Exception('강의 목록을 불러오지 못했습니다.');
    }
  }

  // 퀴즈 목록
  Future<List<QuizCard>> fetchQuizzes() async {
    final response = await ApiClient.instance.dio.get(
      ('/students/home/quizzes'),
    );

    if (response.statusCode == 200) {
      final List data = response.data['data'];
      return data.map((e) => QuizCard.fromJson(e)).toList();
    } else {
      throw Exception('퀴즈 목록을 불러오지 못했습니다.');
    }
  }

  // 숙제 목록
  Future<List<HomeworkCard>> fetchHomeworks() async {
    final response = await ApiClient.instance.dio.get(
      '/students/home/homeworks',
    );

    if (response.statusCode == 200) {
      final List data = response.data['data'];
      return data.map((e) => HomeworkCard.fromJson(e)).toList();
    } else {
      throw Exception('숙제 목록을 불러오지 못했습니다. Status: ${response.statusCode}');
    }
  }
}
