import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ormee_app/feature/home/data/models/homework_card.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/state_badge.dart';

class HomeworkCardSlider extends StatefulWidget {
  final List<HomeworkCard> homeworks;

  const HomeworkCardSlider({super.key, required this.homeworks});

  @override
  State<HomeworkCardSlider> createState() => _HomeworkCardSliderState();
}

class _HomeworkCardSliderState extends State<HomeworkCardSlider> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.12,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.homeworks.length,
        padding: EdgeInsets.only(left: 20),
        itemBuilder: (context, index) {
          final homework = widget.homeworks[index];
          final isLast = index == widget.homeworks.length - 1;

          return GestureDetector(
            onTap: () => context.push('/homework/detail/${homework.id}'),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.44,
              margin: EdgeInsets.only(right: isLast ? 20 : 8),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Label2Semibold12(
                    text: homework.lectureTitle ?? '',
                    color: OrmeeColor.gray[50],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 2),
                  Label1Semibold14(
                    text: homework.homeworkTitle,
                    color: OrmeeColor.gray[90],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Spacer(),
                  StateBadge(
                    text: () {
                      try {
                        final dueDate = DateFormat(
                          'yyyy.MM.dd HH:mm',
                        ).parseStrict(homework.homeworkDueTime.trim());

                        final now = DateTime.now();
                        final difference = dueDate.difference(now).inDays;

                        // 음수일 경우 D+ 처리
                        final ddayText = difference < 0
                            ? 'D+${-difference}'
                            : 'D-${difference}';
                        return ddayText;
                      } catch (e) {
                        print('날짜 파싱 에러: ${homework.homeworkDueTime}, $e');
                        return 'D-?';
                      }
                    }(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
