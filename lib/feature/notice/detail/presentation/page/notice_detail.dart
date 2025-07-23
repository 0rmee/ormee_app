import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ormee_app/feature/notice/detail/bloc/notice_detail_bloc.dart';
import 'package:ormee_app/feature/notice/detail/bloc/notice_detail_event.dart';
import 'package:ormee_app/feature/notice/detail/bloc/notice_detail_state.dart';
import 'package:ormee_app/feature/notice/detail/data/remote_datasource.dart';
import 'package:ormee_app/feature/notice/detail/data/repository.dart';
import 'package:ormee_app/feature/notice/detail/presentation/widgets/attachments_section.dart';
import 'package:ormee_app/shared/widgets/images_section.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';
import 'package:ormee_app/shared/widgets/bottomsheet_icon.dart';
import 'package:ormee_app/shared/widgets/html_text.dart';
import 'package:ormee_app/shared/widgets/profile.dart';
import 'package:ormee_app/shared/widgets/toast.dart';

class NoticeDetailScreen extends StatelessWidget {
  final int noticeId;

  const NoticeDetailScreen({super.key, required this.noticeId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NoticeDetailBloc(
        NoticeDetailRepository(NoticeDetailRemoteDataSource())
      )..add(FetchNoticeDetail(noticeId)),
      child: BlocConsumer<NoticeDetailBloc, NoticeDetailState>(
        listener: (context, state) {
          if (state is NoticeDetailError) {
            OrmeeToast.show(context, state.message);
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is NoticeDetailLoaded) {
            final notice = state.notice;
            return Scaffold(
              appBar: OrmeeAppBar(
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
                        text: notice.title,
                        color: OrmeeColor.gray[800],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Profile(
                                  profileImageUrl: notice.author.image,
                                  size1: 18,
                                ),
                                SizedBox(width: 8),
                                Label1Semibold14(
                                  text: notice.author.name,
                                  color: OrmeeColor.gray[90],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Caption1Regular11(
                                  text: DateFormat(
                                    'MM/dd',
                                  ).format(notice.postDate),
                                  color: OrmeeColor.gray[50],
                                ),
                                SizedBox(width: 4),
                                Caption1Regular11(
                                  text: DateFormat(
                                    'HH:mm',
                                  ).format(notice.postDate),
                                  color: OrmeeColor.gray[50],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      notice.attachmentFiles.isEmpty
                          ? Divider(
                              height: 16,
                              thickness: 1,
                              color: OrmeeColor.gray[20],
                            )
                          : AttachmentsSection(
                              attachmentFiles: notice.attachmentFiles,
                            ),
                      notice.imageUrls.isEmpty
                          ? SizedBox()
                          : ImagesSection(imageUrls: notice.imageUrls),
                      SizedBox(height: 16),
                      HtmlTextWidget(text: notice.description),
                    ],
                  ),
                ),
              ),
              bottomSheet: OrmeeIconBottomSheet(
                text: "공감하기",
                icon: notice.isLiked
                    ? 'assets/icons/favorite_fill.svg'
                    : 'assets/icons/favorite.svg',
                isLike: true,
                ontTap: () {
                  context.read<NoticeDetailBloc>().add(
                    ToggleLike(noticeId: noticeId, isLiked: notice.isLiked),
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
