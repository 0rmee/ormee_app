import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_tooltip/simple_tooltip.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

class OrmeeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final bool isLecture;
  final bool isImage;
  final bool isDetail;
  final bool isPosting;
  final VoidCallback? postAction;
  final bool? memoState;

  const OrmeeAppBar({
    Key? key,
    this.title,
    required this.isLecture,
    required this.isImage,
    required this.isDetail,
    required this.isPosting,
    this.postAction,
    this.memoState,
  }) : super(key: key);

  @override
  State<OrmeeAppBar> createState() => _OrmeeAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(52.0);
}

class _OrmeeAppBarState extends State<OrmeeAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: OrmeeColor.white,
      backgroundColor: OrmeeColor.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: SvgPicture.asset('assets/icons/chevron_left.svg'),
        color: OrmeeColor.gray[800],
      ),
      title: widget.isDetail ? null : Headline1SemiBold18(text: widget.title!),
      centerTitle: true,
      actions: widget.isDetail || widget.isImage
          ? []
          : widget.isLecture
          ? [
              Container(
                margin: const EdgeInsets.only(right: 20),
                child: SimpleTooltip(
                  tooltipTap: () {
                    print("Memo tooltip tapped");
                  },
                  animationDuration: Duration(milliseconds: 300),
                  show: widget.memoState!,
                  backgroundColor: OrmeeColor.gray[90]!.withValues(alpha: 0.7),
                  borderRadius: 10,
                  borderWidth: 0,
                  tooltipDirection: TooltipDirection.down,
                  targetCenter: Offset(57, 0),
                  ballonPadding: EdgeInsets.all(0),
                  minimumOutSidePadding: 8,
                  arrowLength: 5,
                  arrowBaseWidth: 9,
                  arrowTipDistance: 0,
                  maxWidth: 84,
                  minWidth: 84,
                  minHeight: 27,
                  hideOnTooltipTap: true,
                  customShadows: [],
                  child: GestureDetector(
                    onTap: () {
                      // TODO: 추후 memo open, close 상태관리 추가
                    },
                    child: Row(
                      children: [
                        SizedBox(width: 30),
                        SvgPicture.asset(
                          widget.memoState!
                              ? 'assets/icons/memo_open.svg'
                              : 'assets/icons/memo_close.svg',
                          color: OrmeeColor.gray[90],
                        ),
                      ],
                    ),
                  ),
                  content: DefaultTextStyle(
                    style: TextStyle(),
                    child: Label2Semibold12(
                      text: "쪽지 제출하기",
                      color: OrmeeColor.white,
                    ),
                  ),
                ),
              ),
            ]
          : widget.isPosting
          ? [
              Container(
                padding: EdgeInsets.only(right: 24),
                child: InkWell(
                  onTap: widget.postAction,
                  child: Body2RegularNormal14(
                    text: '완료',
                    color: OrmeeColor.gray[60],
                  ),
                ),
              ),
            ]
          : [],
    );
  }
}
