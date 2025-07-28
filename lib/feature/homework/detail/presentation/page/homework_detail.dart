import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ormee_app/feature/homework/detail/bloc/homework_detail_bloc.dart';
import 'package:ormee_app/feature/homework/detail/bloc/homework_detail_event.dart';
import 'package:ormee_app/feature/homework/detail/bloc/homework_detail_state.dart';
import 'package:ormee_app/feature/homework/detail/data/remote_datasource.dart';
import 'package:ormee_app/feature/homework/detail/data/repository.dart';
import 'package:ormee_app/shared/widgets/attachments_section.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';
import 'package:ormee_app/shared/widgets/bottomsheet.dart';
import 'package:ormee_app/shared/widgets/html_text.dart';
import 'package:ormee_app/shared/widgets/images_section.dart';
import 'package:ormee_app/shared/widgets/profile.dart';
import 'package:ormee_app/shared/widgets/toast.dart';

class HomeworkDetailScreen extends StatelessWidget {
  final int homeworkId;

  const HomeworkDetailScreen({super.key, required this.homeworkId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeworkDetailBloc(
        HomeworkDetailRepository(HomeworkDetailRemoteDataSource()),
      )..add(FetchHomeworkDetail(homeworkId)),
      child: BlocConsumer<HomeworkDetailBloc, HomeworkDetailState>(
        listener: (context, state) {
          if (state is HomeworkDetailError) {
            OrmeeToast.show(context, state.message);
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is HomeworkDetailLoaded) {
            final homework = state.homework;

            return Scaffold(
              appBar: OrmeeAppBar(
                isLecture: false,
                isImage: false,
                isDetail: true,
                isPosting: false,
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Heading2SemiBold20(
                            text: homework.title,
                            color: OrmeeColor.gray[800],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Profile(
                                    profileImageUrl: homework.author.image,
                                    size1: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Label1Semibold14(
                                    text: homework.author.name,
                                    color: OrmeeColor.gray[90],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Caption1Regular11(
                                    text: DateFormat('MM/dd').format(homework.openTime),
                                    color: OrmeeColor.gray[50],
                                  ),
                                  const SizedBox(width: 4),
                                  Caption1Regular11(
                                    text: DateFormat('HH:mm').format(homework.openTime),
                                    color: OrmeeColor.gray[50],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          homework.attachmentFiles.isEmpty
                              ? Divider(
                            height: 16,
                            thickness: 1,
                            color: OrmeeColor.gray[20],
                          )
                              : AttachmentsSection(
                            attachmentFiles: homework.attachmentFiles,
                          ),
                        ],
                      ),
                    ),

                    if (homework.imageUrls.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ImagesSection(imageUrls: homework.imageUrls),
                      ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 72),
                      child: HtmlTextWidget(text: homework.description),
                    ),
                  ],
                ),
              ),
              bottomSheet: Builder(
                builder: (context) {
                  final info = getBottomSheetInfo(
                    context: context,
                    openTime: homework.openTime,
                    dueTime: homework.dueTime,
                    isSubmitted: homework.isSubmitted,
                    feedbackCompleted: homework.feedbackCompleted,
                    homeworkId: homeworkId,
                    title: homework.title,
                  );

                  return OrmeeBottomSheet(
                    text: info.text,
                    isCheck: info.isCheck,
                    onTap: info.onTap,
                  );
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

typedef BottomSheetInfo = ({String text, bool isCheck, VoidCallback? onTap});

BottomSheetInfo getBottomSheetInfo({
  required BuildContext context,
  required DateTime openTime,
  required DateTime dueTime,
  required bool isSubmitted,
  required bool feedbackCompleted,
  required int homeworkId,
  required String title,
}) {
  final now = DateTime.now();

  if (now.isBefore(openTime)) {
    return (text: '제출하기', isCheck: false, onTap: null);
  }

  if (now.isAfter(dueTime) && !isSubmitted) {
    return (text: '미제출', isCheck: false, onTap: null);
  }

  if (isSubmitted) {
    if (feedbackCompleted) {
      return (
        text: '결과보기',
        isCheck: true,
        onTap: () {
          context.push('/homework/submission/detail/$homeworkId', extra: title);
        },
      );
    }
    return (text: '결과보기', isCheck: false, onTap: null);
  }

  return (
    text: '제출하기',
    isCheck: true,
    onTap: () {
      context.push('/lecture/detail/homework/$homeworkId/create', extra: title);
    },
  );
}
