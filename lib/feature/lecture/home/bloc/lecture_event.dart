import 'package:equatable/equatable.dart';

abstract class LectureHomeEvent extends Equatable {
  const LectureHomeEvent();

  @override
  List<Object?> get props => [];
}

class FetchLectures extends LectureHomeEvent {}
