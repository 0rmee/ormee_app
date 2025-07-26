import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ormee_app/feature/question/detail/answer/bloc/answer_detail_bloc.dart';
import 'package:ormee_app/feature/question/detail/answer/bloc/answer_detail_event.dart';
import 'package:ormee_app/feature/question/detail/answer/bloc/answer_detail_state.dart';
import 'package:ormee_app/feature/question/detail/answer/data/remote_datasource.dart';
import 'package:ormee_app/feature/question/detail/answer/data/repository.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';
import 'package:ormee_app/shared/widgets/html_text.dart';
import 'package:ormee_app/shared/widgets/images_section.dart';
import 'package:ormee_app/shared/widgets/profile.dart';
import 'package:ormee_app/shared/widgets/toast.dart';

class AnswerDetailScreen extends StatelessWidget {
  final int questionId;

  const AnswerDetailScreen({super.key, required this.questionId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AnswerDetailBloc(
        AnswerDetailRepository(AnswerDetailRemoteDataSource()),
      )..add(FetchAnswerDetail(questionId)),
      child: BlocConsumer<AnswerDetailBloc, AnswerDetailState>(
        listener: (context, state) {
          if (state is AnswerDetailError) {
            OrmeeToast.show(context, state.message);
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is AnswerDetailLoaded) {
            final answer = state.answer;
            return Scaffold(
              appBar: OrmeeAppBar(
                title: '답변 확인',
                isLecture: false,
                isImage: false,
                isDetail: false,
                isPosting: false,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Profile(
                                profileImageUrl: answer.author.image,
                                size1: 18,
                              ),
                              SizedBox(width: 8),
                              Label1Semibold14(
                                text: answer.author.name,
                                color: OrmeeColor.gray[90],
                              ),
                            ],
                          ),
                          Caption1Regular11(
                            text: DateFormat(
                              'yy.MM.dd',
                            ).format(answer.createdAt),
                            color: OrmeeColor.gray[50],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      HtmlTextWidget(text: answer.content),
                      answer.filePaths.isEmpty
                          ? SizedBox()
                          : Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: ImagesSection(imageUrls: answer.filePaths),
                            ),
                    ],
                  ),
                ),
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
