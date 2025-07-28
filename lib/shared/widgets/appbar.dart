import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/feature/memo/presentation/widgets/memo_dialog.dart';
import 'package:ormee_app/shared/widgets/toast.dart';
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
  final int? memoId;
  final int? lectureId;

  const OrmeeAppBar({
    Key? key,
    this.title,
    required this.isLecture,
    required this.isImage,
    required this.isDetail,
    required this.isPosting,
    this.postAction,
    this.memoState,
    this.memoId,
    this.lectureId,
  }) : super(key: key);

  @override
  State<OrmeeAppBar> createState() => _OrmeeAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(52.0);
}

class _OrmeeAppBarState extends State<OrmeeAppBar> {
  late bool _currentMemoState;

  @override
  void initState() {
    super.initState();
    _currentMemoState = widget.memoState ?? false;
  }

  @override
  void didUpdateWidget(OrmeeAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.memoState != null && widget.memoState != _currentMemoState) {
      _currentMemoState = widget.memoState!;
    }
  }

  void _onMemoSubmitted() {
    setState(() {
      _currentMemoState = false;
    });
  }

  void _showMemoDialog(BuildContext context) {
    if (widget.memoId == null) {
      OrmeeToast.show(context, '쪽지 정보를 불러올 수 없습니다.');
      return;
    }

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Material(
        color: OrmeeColor.gray[90]!.withValues(alpha: 0.6),
        child: Center(
          child: MemoDialog(
            memoId: widget.memoId!,
            onClose: () {
              entry.remove();
            },
            onSubmitted: () {
              entry.remove();
              _onMemoSubmitted();
            },
          ),
        ),
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(entry);
  }

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
                  show: _currentMemoState,
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
                  hideOnTooltipTap: false,
                  customShadows: [],
                  content: DefaultTextStyle(
                    style: TextStyle(),
                    child: Label2Semibold12(
                      text: "쪽지 제출하기",
                      color: OrmeeColor.white,
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 30),
                      GestureDetector(
                        onTap: () {
                          if (_currentMemoState == true) {
                            _showMemoDialog(context);
                          } else if (_currentMemoState == false) {
                            context.push(
                              '/lecture/detail/${widget.lectureId}/memo',
                            );
                          }
                        },
                        child: SvgPicture.asset(
                          _currentMemoState
                              ? 'assets/icons/memo_open.svg'
                              : 'assets/icons/memo_close.svg',
                          color: OrmeeColor.gray[90],
                        ),
                      ),
                    ],
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
