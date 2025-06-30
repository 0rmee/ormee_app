import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

class OrmeeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool isLecture;
  final bool isImage;
  final bool isDetail;
  final bool isPosting;
  final VoidCallback? postAction;

  const OrmeeAppBar({
    Key? key,
    this.title,
    required this.isLecture,
    required this.isImage,
    required this.isDetail,
    required this.isPosting,
    this.postAction,
  }) : super(key: key);

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
      title: isDetail ? null : Headline1SemiBold18(text: title!),
      centerTitle: true,
      actions: isDetail || isImage
          ? []
          : isLecture
          ? [
              Container(
                margin: const EdgeInsets.only(right: 24),
                child: IconButton(
                  onPressed: () {},
                  // TODO: 추후 memo open, close 상태관리 추가
                  icon: SvgPicture.asset('assets/icons/memo_open.svg'),
                  color: OrmeeColor.gray[90],
                ),
              ),
            ]
          : isPosting
          ? [
              Container(
                padding: EdgeInsets.only(right: 24),
                child: InkWell(
                  onTap: () => postAction,
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

  @override
  Size get preferredSize => Size.fromHeight(52.0);
}
