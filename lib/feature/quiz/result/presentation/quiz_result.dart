import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/quiz/bloc/quiz_bloc.dart';
import 'package:ormee_app/feature/quiz/bloc/quiz_event.dart';
import 'package:ormee_app/feature/quiz/bloc/quiz_state.dart';
import 'package:ormee_app/feature/quiz/detail/data/model.dart';
import 'package:ormee_app/feature/quiz/detail/data/repository.dart';
import 'package:ormee_app/feature/quiz/widgets/single_choice_answer.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';
import 'package:ormee_app/feature/quiz/widgets/essay_answer.dart';

class QuizResultScreen extends StatelessWidget {
  final int quizId;
  final String title;
  const QuizResultScreen({
    super.key,
    required this.quizId,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          QuizBloc(QuizRepository())..add(LoadQuizResult(quizId)),
      child: QuizResultView(title: title),
    );
  }
}

class QuizResultView extends StatelessWidget {
  final String title;
  const QuizResultView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: OrmeeColor.gray[20],
            appBar: OrmeeAppBar(
              isLecture: false,
              isImage: false,
              isDetail: false,
              isPosting: false,
              title: title,
            ),
            body: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, QuizState state) {
    if (state is QuizLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is QuizError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('오류가 발생했습니다: ${state.message}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('돌아가기'),
            ),
          ],
        ),
      );
    }

    if (state is QuizResultLoaded) {
      return _buildResultContent(context, state);
    }

    return const Center(child: Text('결과를 불러올 수 없습니다.'));
  }

  Widget _buildResultContent(BuildContext context, QuizResultLoaded state) {
    final result = state.result;
    final problems = result.problemDtos; // 문제 순서대로 유지

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 전체 결과 요약
          // _buildResultSummary(result),
          // const SizedBox(height: 24),

          // 모든 문제들을 순서대로
          ...problems.asMap().entries.map((entry) {
            final index = entry.key;
            final problem = entry.value;
            return _buildProblemCard(problem, index + 1);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildResultSummary(QuizResultData result) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.blue.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.quiz, size: 28, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                '퀴즈 결과',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildScoreItem('총 문제', '${result.totalProblems}개', Colors.grey),
              _buildScoreItem('정답', '${result.correct}개', Colors.green),
              _buildScoreItem('오답', '${result.incorrect}개', Colors.red),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '정답률: ${result.scorePercentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: result.scorePercentage >= 70
                    ? Colors.green
                    : Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '(${count}개)',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildProblemCard(ProblemResult problem, int questionNumber) {
    final isCorrect = problem.isCorrect ?? false;
    //final cardColor = isCorrect ? Colors.green : Colors.red;
    final backgroundColor = OrmeeColor.white;
    final borderColor = isCorrect ? OrmeeColor.white : Colors.red.shade200;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Label1Regular14(text: "$questionNumber. "),
              Label1Regular14(text: problem.content),
            ],
          ),
          // 문제 헤더
          // Row(
          //   children: [
          // Container(
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: 10,
          //     vertical: 6,
          //   ),
          //   decoration: BoxDecoration(
          //     color: Colors.blue.shade600,
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: Text(
          //     '문제 $questionNumber',
          //     style: const TextStyle(
          //       color: Colors.white,
          //       fontSize: 12,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
          // const SizedBox(width: 8),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          //   decoration: BoxDecoration(
          //     color: cardColor,
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: Text(
          //     isCorrect ? '정답' : '오답',
          //     style: const TextStyle(
          //       color: Colors.white,
          //       fontSize: 12,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
          // const SizedBox(width: 8),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          //   decoration: BoxDecoration(
          //     color: Colors.grey.shade200,
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: Text(
          //     problem.type.displayName,
          //     style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
          //   ),
          // ),
          // const Spacer(),
          // Icon(
          //   isCorrect ? Icons.check_circle : Icons.cancel,
          //   color: cardColor,
          //   size: 24,
          // ),
          //   ],
          // ),
          const SizedBox(height: 12),

          // 문제 내용
          // Text(
          //   problem.content,
          //   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          // ),
          // const SizedBox(height: 12),

          // 답안 표시 (기존 위젯 활용)
          if (problem.type == ProblemType.choice)
            OrmeeSingleChoiceAnswer(
              items: problem.items,
              submission: problem.submission ?? '',
              answer: problem.answer,
              isCorrect: isCorrect,
            )
          else if (problem.type == ProblemType.essay)
            EssayAnswer(
              answer: problem.answer,
              submission: problem.submission ?? '미제출',
              isCorrect: isCorrect,
            ),
        ],
      ),
    );
  }
}
