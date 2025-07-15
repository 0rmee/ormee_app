import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:ormee_app/feature/lecture/home/bloc/lecture_bloc.dart';
import 'package:ormee_app/feature/lecture/home/bloc/lecture_event.dart';
import 'package:ormee_app/feature/lecture/home/bloc/lecture_state.dart';
import 'package:ormee_app/feature/lecture/home/data/datasources/remote_datasource.dart';
import 'package:ormee_app/feature/lecture/home/data/repositories/repository.dart';
import 'package:ormee_app/feature/lecture/home/presentation/widgets/appbar.dart';
import 'package:ormee_app/feature/lecture/home/presentation/widgets/lecture_home_empty.dart';

class LectureHome extends StatelessWidget {
  const LectureHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LectureHomeBloc(
        LectureRepository(LectureRemoteDataSource(http.Client())),
      )..add(FetchLectures()),
      child: BlocBuilder<LectureHomeBloc, LectureHomeState>(
        builder: (context, state) {
          if (state is LectureHomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LectureHomeLoaded) {
            final lectures = state.lectures;
            return Scaffold(
              appBar: LectureHomeAppBar(count: lectures.length),
              body: lectures.isEmpty
                  ? LectureHomeEmpty()
                  : ListView.builder(
                      itemCount: lectures.length,
                      itemBuilder: (context, index) {
                        final lecture = lectures[index];
                        return ListTile(title: Text(lecture.title));
                      },
                    ),
            );
          } else if (state is LectureHomeError) {
            return Center(child: Text('에러: ${state.message}'));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
