import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:ormee_app/feature/lecture/home/bloc/lecture_bloc.dart';
import 'package:ormee_app/feature/lecture/home/bloc/lecture_event.dart';
import 'package:ormee_app/feature/lecture/home/bloc/lecture_state.dart';
import 'package:ormee_app/feature/lecture/home/data/remote_datasource.dart';
import 'package:ormee_app/feature/lecture/home/data/repository.dart';
import 'package:ormee_app/feature/lecture/home/presentation/widgets/appbar.dart';
import 'package:ormee_app/feature/lecture/home/presentation/widgets/lecture_card.dart';
import 'package:ormee_app/feature/lecture/home/presentation/widgets/lecture_enter_dialog.dart';
import 'package:ormee_app/feature/lecture/home/presentation/widgets/lecture_home_empty.dart';

class LectureHome extends StatelessWidget {
  const LectureHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LectureHomeBloc(
        LectureHomeRepository(LectureHomeRemoteDataSource(http.Client())),
      )..add(FetchLectures()),
      child: BlocConsumer<LectureHomeBloc, LectureHomeState>(
        listener: (context, state) {
          if (state is LectureDialogReady) {
            showDialog(
              context: context,
              builder: (_) => BlocProvider.value(
                value: context.read<LectureHomeBloc>(),
                child: LectureEnterDialog(
                  lectureId: state.lecture.id,
                  lectureTitle: state.lecture.title,
                  teacherNames: [
                    state.lecture.name!,
                    ...state.lecture.coTeachers.map((e) => e.name),
                  ],
                  teacherImages: [
                    if (state.lecture.profileImage != null)
                      state.lecture.profileImage!,
                    ...state.lecture.coTeachers
                        .map((e) => e.image)
                        .whereType<String>(),
                  ],
                ),
              ),
            ).then((_) {
              context.read<LectureHomeBloc>().add(FetchLectures());
            });
          } else if (state is LectureHomeError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is LectureHomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LectureHomeLoaded) {
            final lectures = state.lectures;
            return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: LectureHomeAppBar(count: lectures.length),
              body: SafeArea(
                child: lectures.isEmpty
                    ? LectureHomeEmpty(
                        bloc: context.read<LectureHomeBloc>(),
                        qr: true,
                      )
                    : ListView.builder(
                        itemCount: lectures.length,
                        itemBuilder: (context, index) {
                          final lecture = lectures[index];
                          return LectureCard(
                            id: lecture.id,
                            title: lecture.title,
                            teacherNames: [
                              lecture.name ?? '오르미',
                              ...lecture.coTeachers.map((e) => e.name),
                            ],
                            teacherImages: [
                              if (lecture.profileImage != null)
                                lecture.profileImage!,
                              ...lecture.coTeachers
                                  .map((e) => e.image)
                                  .whereType<String>(),
                            ],
                            startPeriod: lecture.startDate ?? 'YYYY.MM.DD',
                            endPeriod: lecture.dueDate ?? 'YYYY.MM.DD',
                            lectureId: lecture.id,
                            bloc: context.read<LectureHomeBloc>(),
                          );
                        },
                      ),
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
