import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/day_badge.dart';

class LectureCard {
  final String title;
  final List<String> days; // ["MON", "WED"]
  final String startTime; // "15:30:00"
  final String endTime; // "17:00:00"
  final String startDate; // "2025-06-03T00:00:00"
  final String dueDate; // "2026-08-29T23:59:59"

  LectureCard({
    required this.title,
    required this.days,
    required this.startTime,
    required this.endTime,
    required this.startDate,
    required this.dueDate,
  });
}

class LectureCardSlider extends StatefulWidget {
  final List<LectureCard> lectures;

  const LectureCardSlider({super.key, required this.lectures});

  @override
  State<LectureCardSlider> createState() => _LectureCardSliderState();
}

class _LectureCardSliderState extends State<LectureCardSlider> {
  late PageController _pageController;
  int _currentPage = 0;

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return DateFormat('yyyy.MM.dd').format(date);
  }

  String _formatTime(String timeStr) {
    final time = DateFormat.Hms().parse(timeStr); // "15:30:00"
    return DateFormat('HH:mm').format(time); // "15:30"
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
              final startPeriod = _formatDate(lecture.startDate);
              final endPeriod = _formatDate(lecture.dueDate);
              final startTime = _formatTime(lecture.startTime);
              final endTime = _formatTime(lecture.endTime);

              final isLast = index == widget.lectures.length - 1;

              return Container(
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
                              children: [
                                for (int i = 0; i < lecture.days.length; i++)
                                  DayBadge(text: lecture.days[i]),
                              ],
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
