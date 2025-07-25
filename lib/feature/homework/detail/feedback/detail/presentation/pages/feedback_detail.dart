import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/feature/homework/detail/feedback/detail/bloc/feedback_detail_bloc.dart';
import 'package:ormee_app/feature/homework/detail/feedback/detail/bloc/feedback_detail_event.dart';
import 'package:ormee_app/feature/homework/detail/feedback/detail/bloc/feedback_detail_state.dart';
import 'package:ormee_app/feature/homework/detail/feedback/detail/data/remote_repository.dart';
import 'package:ormee_app/feature/homework/detail/feedback/detail/data/repository.dart';
import 'package:ormee_app/feature/homework/detail/feedback/detail/presentation/widgets/feedback_card.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';
import 'package:ormee_app/shared/widgets/toast.dart';

class FeedbackDetailScreen extends StatelessWidget {
  final int submissionId;

  const FeedbackDetailScreen({
    super.key,
    required this.submissionId  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FeedbackDetailBloc(
        FeedbackDetailRepository(
          FeedbackDetailRemoteDataSource(),
        ),
      )..add(FetchFeedbackDetail(submissionId)),
      child:
      BlocConsumer<
          FeedbackDetailBloc,
          FeedbackDetailState
      >(
        listener: (context, state) {
          if (state is FeedbackDetailError) {
            OrmeeToast.show(context, state.message);
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is FeedbackDetailLoaded) {
            final feedbacks = state.feedbacks;
            return Scaffold(
              appBar: OrmeeAppBar(
                title: "피드백 확인",
                isLecture: false,
                isImage: false,
                isDetail: false,
                isPosting: false,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: ListView.separated(
                  itemCount: feedbacks.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 40,
                    thickness: 1,
                    color: OrmeeColor.gray[20],
                  ),
                  itemBuilder: (context, index) {
                    final feedback = feedbacks[index];
                    return FeedbackCard(feedback: feedback);
                  },
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