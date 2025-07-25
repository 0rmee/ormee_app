import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/button.dart';
import 'package:ormee_app/shared/widgets/textfield.dart';

class MemoDialog extends StatefulWidget {
  final VoidCallback? onClose;

  const MemoDialog({super.key, this.onClose});

  @override
  State<MemoDialog> createState() => _MemoDialogState();
}

class _MemoDialogState extends State<MemoDialog> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: OrmeeColor.white,
      surfaceTintColor: Colors.transparent,
      title: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Heading2SemiBold20(text: '쪽지', color: OrmeeColor.gray[90]),
          ),
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: widget.onClose ?? () => context.pop(),
              child: SvgPicture.asset("assets/icons/x.svg"),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/polygon.svg'),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: OrmeeColor.gray[20],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "틀린 문제를 제출하세요.틀린 문제를 제출하세요.틀린 문제를 제출하세요.틀린 문제를 제출하세요.",
                      style: TextStyle(
                        fontSize: 14,
                        color: OrmeeColor.gray[90],
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: OrmeeTextField(
                    hintText: "쉼표로 구분해 입력하세요. ex) 1, 7, 18",
                    controller: _controller,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (text) {},
                    focusNode: _focusNode,
                    maxLines: 5,
                  ),
                ),
                SizedBox(width: 12),
                OrmeeButton(trueAction: () {}, text: '제출', isTrue: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
