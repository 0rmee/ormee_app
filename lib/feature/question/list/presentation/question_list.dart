import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/feature/question/list/bloc/question_list_bloc.dart';
import 'package:ormee_app/feature/question/list/bloc/question_list_event.dart';
import 'package:ormee_app/feature/question/list/bloc/question_list_state.dart';
import 'package:ormee_app/feature/question/list/data/remote_datasource.dart';
import 'package:ormee_app/feature/question/list/data/repository.dart';
import 'package:ormee_app/feature/question/list/presentation/widgets/question_card.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';
import 'package:ormee_app/shared/widgets/fab.dart';
import 'package:ormee_app/shared/widgets/toast.dart';

class QuestionListScreen extends StatelessWidget {
  final int lectureId;

  const QuestionListScreen({super.key, required this.lectureId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuestionListBloc(
        QuestionListRepository(QuestionListRemoteDataSource()),
      )..add(FetchQuestionList(lectureId)),
      child: BlocConsumer<QuestionListBloc, QuestionListState>(
        listener: (context, state) {
          if (state is QuestionListError) {
            OrmeeToast.show(context, state.message);
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is QuestionListLoaded) {
            final questions = state.questions;
            return Scaffold(
              appBar: OrmeeAppBar(
                title: "질문",
                isLecture: false,
                isImage: false,
                isDetail: false,
                isPosting: false,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                child: ListView.separated(
                  itemCount: questions.length,
                  separatorBuilder: (context, index) =>
                      Divider(thickness: 1, color: OrmeeColor.gray[20]),
                  itemBuilder: (context, index) {
                    final question = questions[index];
                    return InkWell(
                      onTap: () {
                        question.isMine
                            ? context.push('') // 질문 상세 화면
                            : OrmeeToast.show(context, '이 글은 작성자만 볼 수 있어요.');
                      },
                      child: QuestionCard(question: question),
                    );
                  },
                ),
              ),
              floatingActionButton: Fab(
                action: () =>
                    context.push('/lecture/detail/$lectureId/question/create'),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
