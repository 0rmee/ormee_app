import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/quiz/bloc/quiz_bloc.dart';
import 'package:ormee_app/feature/quiz/bloc/quiz_event.dart';
import 'package:ormee_app/feature/quiz/bloc/quiz_state.dart';
import 'package:ormee_app/feature/quiz/detail/data/model.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';
import 'package:ormee_app/shared/widgets/button.dart';
import 'package:ormee_app/shared/widgets/label.dart';
import 'package:ormee_app/shared/widgets/profile.dart';
import 'package:ormee_app/feature/quiz/detail/data/repository.dart';

class QuizDetailScreen extends StatelessWidget {
  final int quizId;
  const QuizDetailScreen({super.key, required this.quizId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizBloc(QuizRepository())..add(LoadQuiz(quizId)),
      child: QuizDetailView(quizId: quizId),
    );
  }
}

class QuizDetailView extends StatelessWidget {
  final int quizId;
  const QuizDetailView({super.key, required this.quizId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: OrmeeAppBar(
          isLecture: false,
          isImage: false,
          isDetail: true,
          isPosting: false,
          title: "퀴즈",
        ),
        body: BlocConsumer<QuizBloc, QuizState>(
          listener: (context, state) {
            if (state is QuizError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is QuizLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is QuizLoaded) {
              return _buildQuizContent(context, state);
            }

            if (state is QuizError) {
              return _buildErrorContent(context, state);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildQuizContent(BuildContext context, QuizLoaded state) {
    final detail = state.detail;
    final take = state.take;
    final status = state.status;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 퀴즈 제목
          Heading2SemiBold20(text: detail.title),
          const SizedBox(height: 16),

          // 제한시간 정보
          Row(
            children: [
              Label(
                color: status == QuizStatus.notStarted ? "orange" : "gray",
                text: "제한시간",
                width: 58,
              ),
              const SizedBox(width: 10),
              Label1Regular14(
                text: QuizUtils.formatTimeLimit(detail.timeLimit),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 기한 정보
          Row(
            children: [
              Label(
                color: status == QuizStatus.notStarted ? "orange" : "gray",
                text: "기한",
                width: 58,
              ),
              const SizedBox(width: 10),
              Label1Regular14(text: _formatDateTime(detail.openDateTime)),
              const SizedBox(width: 2),
              const Label1Regular14(text: "-"),
              const SizedBox(width: 2),
              Label1Regular14(text: _formatDateTime(detail.dueDateTime)),
            ],
          ),

          // 퀴즈 상태 표시
          const SizedBox(height: 12),

          // _buildStatusChip(state.status),
          const SizedBox(height: 20),
          Divider(thickness: 1, color: OrmeeColor.gray[20]),
          const SizedBox(height: 20),

          // 작성자 정보
          Row(
            children: [
              Profile(
                profileImageUrl: detail.author.image.isEmpty
                    ? null
                    : detail.author.image,
                size1: 18,
              ),
              const SizedBox(width: 8),
              Label1Semibold14(
                text: detail.author.name,
                color: OrmeeColor.gray[90],
              ),
              const SizedBox(width: 2),
              const Label1Regular14(text: "선생님"),
              const Spacer(),
              Caption1Regular11(
                text: DateFormat('MM/dd').format(detail.openDateTime),
                color: OrmeeColor.gray[50],
              ),
              const SizedBox(width: 4),
              Caption1Regular11(
                text: DateFormat('HH:mm').format(detail.openDateTime),
                color: OrmeeColor.gray[50],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 퀴즈 설명
          Container(
            padding: const EdgeInsets.only(left: 26),
            child: Label1Regular14(text: detail.description),
          ),

          const SizedBox(height: 24),

          // 퀴즈 정보 요약
          _buildQuizSummary(take),

          const Spacer(),

          // 액션 버튼
          _buildActionButtons(
            context,
            state,
            _createDDay(detail.openDateTime, detail.dueDateTime),
            quizId,
            detail.title,
          ),
        ],
      ),
    );
  }

  // Widget _buildStatusChip(QuizStatus status) {
  //   Color backgroundColor;
  //   Color textColor;
  //   String text;

  //   switch (status) {
  //     case QuizStatus.notStarted:
  //       backgroundColor = OrmeeColor.gray[20] ?? Colors.grey[200]!;
  //       textColor = OrmeeColor.gray[70] ?? Colors.grey[700]!;
  //       text = "시작 전";
  //       break;
  //     case QuizStatus.inProgress:
  //       backgroundColor = Colors.blue[100]!;
  //       textColor = Colors.blue[700]!;
  //       text = "진행 중";
  //       break;
  //     case QuizStatus.submitted:
  //       backgroundColor = Colors.green[100]!;
  //       textColor = Colors.green[700]!;
  //       text = "제출 완료";
  //       break;
  //     case QuizStatus.expired:
  //       backgroundColor = Colors.red[100]!;
  //       textColor = Colors.red[700]!;
  //       text = "기간 만료";
  //       break;
  //   }
  //
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //     decoration: BoxDecoration(
  //       color: backgroundColor,
  //       borderRadius: BorderRadius.circular(4),
  //     ),
  //     child: Text(
  //       text,
  //       style: TextStyle(
  //         color: textColor,
  //         fontSize: 12,
  //         fontWeight: FontWeight.w500,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildQuizSummary(QuizTake take) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: OrmeeColor.gray[10],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Label1Semibold14(text: "퀴즈 정보"),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Label1Regular14(text: "총 문제 수"),
              Label1Semibold14(text: "${take.totalProblems}문제"),
            ],
          ),
          const SizedBox(height: 8),
          if (take.choiceProblems > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Label1Regular14(text: "객관식"),
                Label1Regular14(text: "${take.choiceProblems}문제"),
              ],
            ),
            const SizedBox(height: 4),
          ],
          if (take.essayProblems > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Label1Regular14(text: "주관식"),
                Label1Regular14(text: "${take.essayProblems}문제"),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    QuizLoaded state,
    dday,
    quizId,
    title,
  ) {
    return Column(
      children: [
        if (state.status == QuizStatus.inProgress) ...[
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OrmeeButton(
              text: '퀴즈 응시하기',
              isTrue: true,
              trueAction: () async {
                final success = await ApiClient.instance.reissueToken();
                if (success) {
                  context.push('/quiz/take/$quizId?title=$title');
                } else {
                  // 재발급 실패 처리 (예: 에러 메시지, 로그아웃 등)
                  print('토큰 재발급 실패!');
                }
              },
              dday: dday,
            ),
            // ElevatedButton(
            //   onPressed: () => _navigateToQuizTake(context, state),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.blue[600],
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //   ),
            //   child: const Text(
            //     "퀴즈 시작하기",
            //     style: TextStyle(
            //       color: Colors.white,
            //       fontSize: 16,
            //       fontWeight: FontWeight.w600,
            //     ),
            //   ),
            // ),
          ),
        ],

        if (state.status == QuizStatus.submitted) ...[
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OrmeeButton(
              text: '정답 확인하기',
              isTrue: true,
              trueAction: () {
                print("title: $title");
                context.push('/quiz/result/$quizId?title=$title');
              },
            ),
            // ElevatedButton(
            //   onPressed: () => _navigateToQuizResult(context, state),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.green[600],
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //   ),
            //   child: const Text(
            //     "정답 확인하기",
            //     style: TextStyle(
            //       color: Colors.white,
            //       fontSize: 16,
            //       fontWeight: FontWeight.w600,
            //     ),
            //   ),
            // ),
          ),
        ],

        if (state.status == QuizStatus.notStarted) ...[
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "퀴즈 시작까지 ${QuizUtils.formatRemainingTime(state.detail.openDateTime.difference(DateTime.now()))}",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],

        if (state.status == QuizStatus.expired) ...[
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () =>
                  context.push('/quiz/result/$quizId?title=$title'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[30],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "응시하지 않은 퀴즈예요",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildErrorContent(BuildContext context, QuizError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          const SizedBox(height: 16),
          Text(
            state.message,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // 퀴즈 다시 로드
              final quizId = ModalRoute.of(context)?.settings.arguments as int?;
              if (quizId != null) {
                context.read<QuizBloc>().add(LoadQuiz(quizId));
              }
            },
            child: const Text("다시 시도"),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy.MM.dd (E)', 'ko_KR').format(dateTime);
  }

  String _createDDay(DateTime startDate, DateTime endDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);

    if (today.isBefore(start)) {
      // 시작 전
      final diff = start.difference(today).inDays;
      return 'D-$diff';
    } else if (!today.isAfter(end)) {
      // 시작일 이상, 마감일 이하 (포함)
      return 'D-day';
    } else {
      // 마감일 이후
      final diff = today.difference(end).inDays;
      return 'D+${diff}';
    }
  }

  void _navigateToQuizTake(BuildContext context, QuizLoaded state) {
    // QuizTake 화면으로 이동
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => QuizTakeScreen(
    //       quizId: state.quizResponse.data.problems.first.id, // 실제 퀴즈 ID 사용
    //       quizBloc: context.read<QuizBloc>(),
    //     ),
    //   ),
    // );
    print("Navigate to Quiz Take");
  }

  void _navigateToQuizResult(BuildContext context, QuizLoaded state) {
    // QuizResult 화면으로 이동
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => QuizResultScreen(
    //       quizId: state.quizResponse.data.problems.first.id, // 실제 퀴즈 ID 사용
    //     ),
    //   ),
    // );
    print("Navigate to Quiz Result");
  }
}
