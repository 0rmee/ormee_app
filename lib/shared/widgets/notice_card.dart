import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ormee_app/shared/widgets/teacher_badge2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/teacher_badge.dart';

class NoticeCard extends StatefulWidget {
  final int noticeId;
  final String notice;
  final String teacher;
  final String date;
  final VoidCallback? onTap;
  final bool isPinned;

  const NoticeCard({
    super.key,
    required this.noticeId,
    required this.date,
    required this.notice,
    required this.teacher,
    this.onTap,
    required this.isPinned,
  });

  @override
  State<NoticeCard> createState() => _NoticeCardState();
}

class _NoticeCardState extends State<NoticeCard> {
  bool _isRead = false; // 기본값을 false로 설정

  @override
  void initState() {
    super.initState();
    _loadReadStatus();
  }

  Future<void> _loadReadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool readStatus;

    if (widget.isPinned) {
      // 고정 공지는 항상 읽음 상태로 표시
      readStatus = true;
    } else {
      // 일반 공지는 SharedPreferences에서 읽음 상태 확인
      readStatus = prefs.getBool('notice_read_${widget.noticeId}') ?? false;
    }

    if (mounted) {
      setState(() {
        _isRead = readStatus;
      });
    }
  }

  // SharedPreferences에 읽음 상태 저장
  Future<void> _markAsRead() async {
    if (!_isRead) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notice_read_${widget.noticeId}', true);
      if (mounted) {
        setState(() {
          _isRead = true;
        });
      }
    }
  }

  void _handleTap() {
    _markAsRead();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _handleTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    !widget.isPinned
                        ? SizedBox()
                        : Container(
                            padding: EdgeInsets.only(right: 8),
                            child: SvgPicture.asset('assets/icons/pin.svg'),
                          ),
                    Headline2SemiBold16(text: widget.notice),
                    _isRead
                        ? SizedBox()
                        : Container(
                            padding: EdgeInsets.only(left: 6),
                            child: SvgPicture.asset("assets/icons/ellipse.svg"),
                          ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TeacherBadge2(widget.teacher),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      height: 12,
                      width: 1,
                      color: OrmeeColor.gray[20],
                    ),
                    Label2Regular12(
                      text: widget.date,
                      color: OrmeeColor.gray[40],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
