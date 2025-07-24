import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ormee_app/feature/homework/detail/submission/detail/bloc/homework_submission_detail_bloc.dart';
import 'package:ormee_app/feature/homework/detail/submission/detail/bloc/homework_submission_detail_event.dart';
import 'package:ormee_app/feature/homework/detail/submission/detail/bloc/homework_submission_detail_state.dart';
import 'package:ormee_app/feature/homework/detail/submission/detail/data/remote_datasource.dart';
import 'package:ormee_app/feature/homework/detail/submission/detail/data/repository.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';
import 'package:ormee_app/shared/widgets/bottomsheet_icon.dart';
import 'package:ormee_app/shared/widgets/html_text.dart';
import 'package:ormee_app/shared/widgets/images_section.dart';
import 'package:ormee_app/shared/widgets/toast.dart';

class HomeworkSubmissionDetailScreen extends StatelessWidget {
  final int homeworkId;
  final String homeworkTitle;

  const HomeworkSubmissionDetailScreen({
    super.key,
    required this.homeworkId,
    required this.homeworkTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeworkSubmissionDetailBloc(
        HomeworkSubmissionDetailRepository(
          HomeworkSubmissionDetailRemoteDataSource(),
        ),
      )..add(FetchHomeworkSubmissionDetail(homeworkId)),
      child:
          BlocConsumer<
            HomeworkSubmissionDetailBloc,
            HomeworkSubmissionDetailState
          >(
            listener: (context, state) {
              if (state is HomeworkSubmissionDetailError) {
                OrmeeToast.show(context, state.message);
                context.pop();
              }
            },
            builder: (context, state) {
              if (state is HomeworkSubmissionDetailLoaded) {
                final submission = state.submission;
                return Scaffold(
                  appBar: OrmeeAppBar(
                    title: "숙제",
                    isLecture: false,
                    isImage: false,
                    isDetail: true,
                    isPosting: false,
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 12, 20, 72),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Heading2SemiBold20(
                            text: homeworkTitle,
                            color: OrmeeColor.gray[800],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Label1Semibold14(
                                  text: submission.name,
                                  color: OrmeeColor.gray[90],
                                ),
                                Caption1Regular11(
                                  text: DateFormat(
                                    'yy.MM.dd',
                                  ).format(submission.createdAt),
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
                          HtmlTextWidget(text: submission.content),
                          submission.filePaths.isEmpty
                              ? SizedBox()
                              : ImagesSection(imageUrls: submission.filePaths),
                        ],
                      ),
                    ),
                  ),
                  bottomSheet: OrmeeIconBottomSheet(
                    text: '피드백 확인',
                    icon: 'assets/icons/chat_bubble.svg',
                    isLike: false,
                    ontTap: () {
                      context.push('/'); // 피드백 상세로
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
}
