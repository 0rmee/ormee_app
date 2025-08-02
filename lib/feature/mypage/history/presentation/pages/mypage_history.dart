import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:ormee_app/feature/lecture/home/presentation/widgets/lecture_card.dart';
import 'package:ormee_app/feature/lecture/home/presentation/widgets/lecture_home_empty.dart';
import 'package:ormee_app/feature/mypage/history/bloc/history_bloc.dart';
import 'package:ormee_app/feature/mypage/history/bloc/history_event.dart';
import 'package:ormee_app/feature/mypage/history/bloc/history_state.dart';
import 'package:ormee_app/feature/mypage/history/data/model.dart';
import 'package:ormee_app/feature/mypage/history/data/remote_datasource.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';
import 'package:ormee_app/shared/widgets/tab.dart';

class MypageHistory extends StatelessWidget {
  const MypageHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LectureHistoryBloc(LectureHistoryRemoteDataSource(http.Client()))
            ..add(LoadLectureHistory()),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: OrmeeAppBar(
            title: '수강내역',
            isLecture: false,
            isImage: false,
            isDetail: false,
            isPosting: false,
          ),
          body: Column(
            children: [
              OrmeeTabBar(
                tabs: [
                  OrmeeTab(text: '진행 중인 강의'),
                  OrmeeTab(text: '이전 강의'),
                ],
              ),
              Expanded(
                child: BlocBuilder<LectureHistoryBloc, LectureHistoryState>(
                  builder: (context, state) {
                    if (state is LectureHistoryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is LectureHistoryError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.message,
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<LectureHistoryBloc>().add(
                                  LoadLectureHistory(),
                                );
                              },
                              child: const Text('다시 시도'),
                            ),
                          ],
                        ),
                      );
                    } else if (state is LectureHistoryLoaded) {
                      return TabBarView(
                        children: [
                          // 진행 중인 강의
                          _buildLectureList(
                            context,
                            state.openLectures,
                            context.read<LectureHistoryBloc>(),
                            '진행 중인 강의가 없어요.',
                          ),
                          // 이전 강의
                          _buildLectureList(
                            context,
                            state.closedLectures,
                            context.read<LectureHistoryBloc>(),
                            '이전 강의가 없어요.',
                          ),
                        ],
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLectureList(
    BuildContext context,
    List<LectureHistory> lectures,
    LectureHistoryBloc bloc,
    String text,
  ) {
    if (lectures.isEmpty) {
      return SafeArea(child: LectureHomeEmpty(text: text));
    }

    return SafeArea(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: lectures.length,
        itemBuilder: (context, index) {
          final lecture = lectures[index];
          return LectureCard(
            id: lecture.id,
            title: lecture.title,
            teacherNames: [
              lecture.name ?? '오르미',
              if (lecture.coTeachers != null)
                ...lecture.coTeachers!.map((e) => e.name),
            ],
            teacherImages: [
              if (lecture.profileImage != null) lecture.profileImage!,
              if (lecture.coTeachers != null)
                ...lecture.coTeachers!.map((e) => e.image).whereType<String>(),
            ],
            startPeriod: _formatDate(lecture.startDate) ?? 'YYYY.MM.DD',
            endPeriod: _formatDate(lecture.dueDate) ?? 'YYYY.MM.DD',
            lectureId: lecture.id,
            bloc: bloc,
          );
        },
      ),
    );
  }

  String? _formatDate(String? dateString) {
    if (dateString == null) return null;

    try {
      final date = DateTime.parse(dateString);
      return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }
}
