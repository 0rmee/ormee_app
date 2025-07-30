import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/feature/search/presentation/widgets/history.dart';
import 'package:ormee_app/feature/search/presentation/widgets/notification_result.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/search_bar.dart';

class NotificationSearch extends StatelessWidget {
  NotificationSearch({super.key});

  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: OrmeeColor.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: null,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              onPressed: () => context.pop(),
              icon: SvgPicture.asset('assets/icons/chevron_left.svg'),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            Expanded(
              child: OrmeeSearchBar(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: (text) {
                  print('Search text changed: $text');
                },
                onSearch: () {
                  print('Search submitted: ${_controller.text}');
                },
              ),
            ),
            SizedBox(width: 20),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Headline2SemiBold16(text: '최근 검색어'),
                Label1Semibold14(text: '전체삭제', color: OrmeeColor.gray[60]),
              ],
            ),
            SizedBox(height: 18),
            // History(),
            NotificationResult(),
          ],
        ),
      ),
    );
  }
}
