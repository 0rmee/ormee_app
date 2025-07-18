import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ormee_app/feature/question/create/data/model.dart';
import 'package:ormee_app/feature/question/create/data/remote_datasource.dart';

class QuestionRepository {
  final QuestionCreateRemoteDataSource remoteDataSource;

  QuestionRepository(this.remoteDataSource);

  Future<void> postQuestion(int lectureId, QuestionRequest request) async {
    return remoteDataSource.postQuestion(lectureId, request);
  }
}
