import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

class OrmeeNavigationBar extends StatefulWidget {
  final Widget child;
  final int notificationCount; // TODO: 알림 개수 컨트롤러 연결

  const OrmeeNavigationBar({
    super.key,
    required this.child,
    this.notificationCount = 100,
  });

  @override
  State<OrmeeNavigationBar> createState() => _OrmeeNavigationBarState();
}

class _OrmeeNavigationBarState extends State<OrmeeNavigationBar> {
  final List<String> _routes = [
    '/home',
    '/lecture',
    '/notification',
    '/mypage',
  ];

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return _routes.indexWhere((r) => location.startsWith(r));
  }

  void _onItemTapped(int index) {
    context.go(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // 안드로이드용
        statusBarBrightness: Brightness.light, // iOS용
      ),
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: SafeArea(
          child: _buildBottomNavigationBar(selectedIndex),
        ),
        extendBody: true,
      ),
    );
  }

  Widget _buildBottomNavigationBar(int selectedIndex) {
    return Container(
      decoration: BoxDecoration(
        color: OrmeeColor.white,
        border: Border(top: BorderSide(color: OrmeeColor.gray[10]!, width: 1)),
      ),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, 'home.svg', '홈', selectedIndex),
          _buildNavItem(1, 'lecture.svg', '강의실', selectedIndex),
          _buildNavItem(2, 'notification.svg', '알림', selectedIndex),
          _buildNavItem(3, 'mypage.svg', '마이페이지', selectedIndex),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    String iconName,
    String label,
    int selectedIndex,
  ) {
    final isSelected = index == selectedIndex;
    final color = isSelected ? OrmeeColor.purple[50] : OrmeeColor.gray[40];
    final isNotification = index == 2;

    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Container(
        width: 70,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 알림 탭일 때 + 알림 탭 선택하지 않았을 때 배지 표시
            if (isNotification && widget.notificationCount > 0 && !isSelected)
              Stack(
                clipBehavior: Clip.none,
                children: [
                  SvgPicture.asset(
                    'assets/icons/$iconName',
                    color: color,
                    width: 24,
                    height: 24,
                  ),
                  Positioned(
                    left: 15,
                    top: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: OrmeeColor.purple[50],
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Text(
                        widget.notificationCount > 99
                            ? '99+'
                            : widget.notificationCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              )
            else
              SvgPicture.asset(
                'assets/icons/$iconName',
                color: color,
                width: 24,
                height: 24,
              ),
            const SizedBox(height: 4),
            Label2Regular12(text: label, color: color),
          ],
        ),
      ),
    );
  }
}
