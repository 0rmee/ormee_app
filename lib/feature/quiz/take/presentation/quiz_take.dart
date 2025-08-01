import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/core/events/quiz_events.dart';
import 'package:ormee_app/feature/quiz/detail/data/model.dart';
import 'package:ormee_app/feature/quiz/take/presentation/controller.dart';
import 'package:ormee_app/feature/quiz/widgets/OrmeeTextField2.dart';
import 'package:ormee_app/feature/quiz/widgets/single_choice.dart';
import 'package:ormee_app/feature/quiz/widgets/submit_confirm_dialog.dart';
import 'package:ormee_app/feature/quiz/widgets/time_over_dialog.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/appbar.dart' show OrmeeAppBar;

class Quiz extends StatelessWidget {
  final QuizController controller = Get.put(QuizController());

  final int quizId;
  final String quizTitle;

  Quiz({super.key, required this.quizId, required this.quizTitle});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchQuiz(quizId).then((_) {
        // 퀴즈 데이터가 로드된 후 답안 초기화 (기존 방식과 동일)
        if (controller.problems.isNotEmpty) {
          // 모든 문제에 대해 빈 답안으로 초기화
          for (var problem in controller.problems) {
            controller.saveAnswer(problem.id, "");
          }
        }
        // 타이머는 fetchQuiz 내부에서 자동으로 시작
      });
    });

    return Scaffold(
      backgroundColor: OrmeeColor.white,
      appBar: OrmeeAppBar(
        title: quizTitle,
        isLecture: false,
        isImage: false,
        isDetail: false,
        isPosting: false,
      ),
      body: Stack(
        children: [
          // 메인 컨텐츠 - 로딩/에러 상태만 Obx로 감시
          Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            if (controller.error.value != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('오류: ${controller.error.value}'),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => controller.fetchQuiz(quizId),
                      child: Text('다시 시도'),
                    ),
                  ],
                ),
              );
            }

            if (controller.problems.isEmpty) {
              return Center(child: Text('퀴즈 정보가 없습니다.'));
            }

            return SingleChildScrollView(child: buildQuizContent());
          }),

          // 타이머 - 별도 Obx로 분리
          buildTimerWidget(),

          // 시간 종료 다이얼로그 - 별도 Obx로 분리
          buildTimeUpDialog(context),
        ],
      ),
      bottomSheet: buildSubmitButton(context),
    );
  }

  Widget buildQuizContent() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      margin: EdgeInsets.only(bottom: 89.5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.problems.length,
            itemBuilder: (context, index) {
              final problem = controller.problems[index];

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: OrmeeColor.gray[20]!),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Label1Regular14(text: problem.content),
                    SizedBox(height: 15),

                    // 문제 타입에 따른 답안 입력 위젯
                    if (problem.type == ProblemType.choice) // 선택형 퀴즈
                      OrmeeSingleChoiceList(
                        items: problem.items
                            .where((item) => item.isNotEmpty)
                            .toList(),
                        selectedIndex: _getSelectedChoiceIndex(problem),
                        onSelectionChanged: (selectedIndex) {
                          // 선택된 항목을 저장
                          controller.saveAnswer(
                            problem.id,
                            problem.items[selectedIndex],
                          );
                        },
                      )
                    else if (problem.type == ProblemType.essay) // 에세이형 퀴즈
                      // 기존 방식 적용: 빈 컨트롤러로 시작
                      OrmeeTextField2(
                        hintText: '답을 입력해주세요.',
                        controller: TextEditingController(), // 빈 컨트롤러
                        textInputAction: TextInputAction.done,
                        onSelectionUnfocused: (value) {
                          // 포커스 해제시에만 저장 (기존 방식)
                          controller.saveAnswer(problem.id, value);
                        },
                      ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 13);
            },
          ),
        ],
      ),
    );
  }

  Widget buildTimerWidget() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 73,
      child: Obx(() {
        if (controller.remainingTime.value.isEmpty) {
          return SizedBox.shrink();
        }

        return Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Color(0x8019191D),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Body1RegularReading16(
              text: controller.remainingTime.value,
              color: OrmeeColor.white,
            ),
          ),
        );
      }),
    );
  }

  Widget buildTimeUpDialog(BuildContext context) {
    return Obx(() {
      if (controller.isTimeUp.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleTimeUp(context);
        });
      }
      return SizedBox.shrink();
    });
  }

  Future<void> _handleTimeUp(BuildContext context) async {
    FocusScope.of(context).unfocus();
    await controller.submitQuiz(quizId);

    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => customDialog(context),
      );
    }
  }

  Widget buildSubmitButton(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: () async {
          await _handleSubmitQuiz(context);
        },
        child: Container(
          width: double.maxFinite,
          color: OrmeeColor.white,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 48,
            decoration: BoxDecoration(
              color: controller.isLoading.value
                  ? OrmeeColor.gray[30]
                  : OrmeeColor.purple[40],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: controller.isLoading.value
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: OrmeeColor.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Body1RegularNormal16(text: "제출하기", color: OrmeeColor.white),
            ),
          ),
        ),
      );
    });
  }

  // 선택형 문제의 현재 선택된 인덱스 반환
  int? _getSelectedChoiceIndex(Problem problem) {
    final answer = controller.getAnswer(problem.id);
    if (answer == null || answer.isEmpty) return null;
    return int.tryParse(answer);
  }

  // 퀴즈 제출 처리
  Future<void> _handleSubmitQuiz(BuildContext context) async {
    if (controller.isLoading.value) return;

    // 모든 문제가 답변되었는지 확인
    // final unansweredProblems = controller.problems.where((problem) {
    //   final answer = controller.getAnswer(problem.id);
    //   return answer == null || answer.isEmpty;
    // }).toList();

    // if (unansweredProblems.isNotEmpty) {
    //   Get.snackbar(
    //     '알림',
    //     '모든 문제에 응답해주세요.',
    //     snackPosition: SnackPosition.BOTTOM,
    //     duration: const Duration(seconds: 2),
    //   );
    //   return;
    // }

    try {
      // 제출 확인 다이얼로그 표시
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => SubmitConfirmDialog(
          onConfirm: () async {
            Navigator.of(context).pop(true); // true를 반환하여 확인됨을 알림
            await controller.submitQuiz(quizId);
          },
        ),
      );

      // 클래스 코드 페이지로 돌아가기
      if (confirmed == true) {
        // Navigator.of(context).popUntil((route) {
        //   return route.settings.name?.startsWith('/quiz/detail/${quizId}') ??
        //       false;
        // });
        GoRouter.of(context).routerDelegate.navigatorKey.currentState?.popUntil(
          (route) => route.settings.name == '/quiz/detail/$quizId',
        );
        GlobalEventBus().fire(QuizDetailRefreshEvent(quizId));
      }
    } catch (e) {
      // 에러는 controller에서 이미 처리되므로 여기서는 추가 처리 불필요
    }
  }

  Widget customDialog(BuildContext context) {
    return TimeOverDialog(
      onConfirm: () async {
        GoRouter.of(context).routerDelegate.navigatorKey.currentState?.popUntil(
          (route) => route.settings.name == '/quiz/detail/$quizId',
        );
        GlobalEventBus().fire(QuizDetailRefreshEvent(quizId));
      },
    );
  }
}
