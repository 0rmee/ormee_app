import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ormee_app/feature/home/data/models/lecture_card.dart';
import 'package:ormee_app/feature/lecture/detail/presentation/pages/lecture_detail.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/day_badge.dart';

class LectureCardSlider extends StatefulWidget {
  final List<LectureCard> lectures;

  const LectureCardSlider({super.key, required this.lectures});

  @override
  State<LectureCardSlider> createState() => _LectureCardSliderState();
}

class _LectureCardSliderState extends State<LectureCardSlider> {
  late PageController _pageController;
  int _currentPage = 0;

  String _formatTime(String timeStr) {
    try {
      final time = DateFormat.Hms().parse(timeStr); // "15:30:00"
      return DateFormat('HH:mm').format(time); // "15:30"
    } catch (e) {
      // 파싱 실패 시 원본 반환 (이미 HH:mm 형식일 수도 있음)
      return timeStr;
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.92, // 다음 카드 살짝 보이게
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.135,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.lectures.length,
            clipBehavior: Clip.none,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final lecture = widget.lectures[index];
              // _formatDate 함수 제거, 이미 포맷된 문자열 사용
              final startPeriod = lecture.startDate; // 이미 "yyyy.MM.dd" 형식
              final endPeriod = lecture.dueDate; // 이미 "yyyy.MM.dd" 형식
              final startTime = _formatTime(lecture.startTime);
              final endTime = _formatTime(lecture.endTime);

              final isLast = index == widget.lectures.length - 1;

              return GestureDetector(
                onTap: () => context.push('/lecture/detail/${lecture.id}'),
                child: Container(
                  margin: EdgeInsets.only(right: isLast ? 0 : 8),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Image.asset('assets/images/home_lecture.png'),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Label1Semibold14(text: lecture.title),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Wrap(
                                spacing: 2,
                                children: lecture.days
                                    .map((e) => DayBadge(text: dayToKorean(e)))
                                    .toList(),
                              ),

                              const SizedBox(width: 6),
                              Label2Regular12(
                                text: '$startTime - $endTime',
                                color: OrmeeColor.gray[60],
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Label2Regular12(
                            text: '$startPeriod - $endPeriod',
                            color: OrmeeColor.gray[50],
                          ),
                        ],
                      ),
                      Spacer(),
                      SvgPicture.asset('assets/icons/arrow_right.svg'),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),

        // 도트 인디케이터
        if (widget.lectures.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.lectures.length, (index) {
              final isActive = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: isActive ? OrmeeColor.gray[50] : OrmeeColor.gray[30],
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
      ],
    );
  }
}
