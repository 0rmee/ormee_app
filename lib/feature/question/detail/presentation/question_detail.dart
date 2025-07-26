import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ormee_app/feature/question/detail/bloc/question_detail_bloc.dart';
import 'package:ormee_app/feature/question/detail/bloc/question_detail_event.dart';
import 'package:ormee_app/feature/question/detail/bloc/question_detail_state.dart';
import 'package:ormee_app/feature/question/detail/data/remote_datasource.dart';
import 'package:ormee_app/feature/question/detail/data/repository.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';
import 'package:ormee_app/shared/widgets/bottomsheet_icon.dart';
import 'package:ormee_app/shared/widgets/html_text.dart';
import 'package:ormee_app/shared/widgets/images_section.dart';
import 'package:ormee_app/shared/widgets/toast.dart';

class QuestionDetailScreen extends StatelessWidget {
  final int questionId;

  const QuestionDetailScreen({super.key, required this.questionId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuestionDetailBloc(
        QuestionDetailRepository(QuestionDetailRemoteDataSource()),
      )..add(FetchQuestionDetail(questionId)),
      child: BlocConsumer<QuestionDetailBloc, QuestionDetailState>(
        listener: (context, state) {
          if (state is QuestionDetailError) {
            OrmeeToast.show(context, state.message);
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is QuestionDetailLoaded) {
            final question = state.question;
            return Scaffold(
              appBar: OrmeeAppBar(
                title: '질문',
                isLecture: false,
                isImage: false,
                isDetail: false,
                isPosting: false,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 12, 20, 72),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Heading2SemiBold20(
                        text: question.title,
                        color: OrmeeColor.gray[800],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Label1Semibold14(
                              text: question.isMine
                                  ? question.author
                                  : _maskAuthorName(question.author),
                              color: OrmeeColor.gray[90],
                            ),
                            Caption1Regular11(
                              text: DateFormat(
                                'yy.MM.dd',
                              ).format(question.createdAt),
                              color: OrmeeColor.gray[50],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 16,
                        thickness: 1,
                        color: OrmeeColor.gray[20],
                      ),
                      SizedBox(height: 16),
                      HtmlTextWidget(text: question.content),
                      question.filePaths.isEmpty
                          ? SizedBox()
                          : Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: ImagesSection(
                                imageUrls: question.filePaths,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              bottomSheet: OrmeeIconBottomSheet(
                text: "답변 확인",
                icon: 'assets/icons/chat_bubble.svg',
                isLike: false,
                ontTap: () {
                  context.push('/'); // 답변 상세
                },
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

  String _maskAuthorName(String name) {
    if (name.length < 2) return name;
    return '${name[0]}*${name.substring(2)}';
  }

}
