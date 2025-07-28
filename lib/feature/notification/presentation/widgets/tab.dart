import 'package:flutter/material.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

// 원본에서 사용하는 CustomLabelIndicator와 Painter 그대로 사용
class CustomLabelIndicator extends Decoration {
  final Color color;
  final BorderRadius borderRadius;
  final double height;

  const CustomLabelIndicator({
    required this.color,
    this.borderRadius = BorderRadius.zero,
    this.height = 3.0,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomLabelIndicatorPainter(
      color: color,
      borderRadius: borderRadius,
      height: height,
    );
  }
}

class _CustomLabelIndicatorPainter extends BoxPainter {
  final Color color;
  final BorderRadius borderRadius;
  final double height;

  _CustomLabelIndicatorPainter({
    required this.color,
    required this.borderRadius,
    required this.height,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final indicatorWidth = configuration.size?.width ?? 0;
    final indicatorOffsetY = configuration.size?.height ?? 0;

    final rect = Rect.fromLTWH(
      offset.dx,
      offset.dy + indicatorOffsetY - height,
      indicatorWidth,
      height,
    );

    final rrect = borderRadius.toRRect(rect);

    canvas.drawRRect(rrect, paint);
  }
}

class OrmeeTabBar2 extends StatelessWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final int currentIndex;
  final List<int> notifications; // 각 탭별 알림 개수 리스트
  final void Function(int) onTap;

  const OrmeeTabBar2({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.notifications, // 변경: 리스트로 받음
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      initialIndex: currentIndex,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context)!;

          // currentIndex가 변경되면 TabController도 업데이트
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (tabController.index != currentIndex) {
              tabController.animateTo(currentIndex);
            }
          });

          return TabBar(
            controller: tabController,
            onTap: onTap,
            padding: EdgeInsets.zero,
            dividerColor: OrmeeColor.gray[30],
            indicatorPadding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero,
            indicatorSize: TabBarIndicatorSize.label,
            overlayColor: MaterialStateProperty.all(Colors.white),
            labelColor: OrmeeColor.purple[50],
            unselectedLabelColor: OrmeeColor.gray[60],
            indicator: CustomLabelIndicator(
              color: OrmeeColor.purple[50]!,
              borderRadius: BorderRadius.circular(1),
            ),
            tabs: tabs.asMap().entries.map((entry) {
              int index = entry.key;
              String tab = entry.value;
              int notificationCount = index < notifications.length
                  ? notifications[index]
                  : 0;
              return _buildTab(tab, notificationCount, index);
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildTab(String tabText, int notificationCount, int tabIndex) {
    return Tab(
      child: Builder(
        builder: (context) {
          final TabController? tabController = DefaultTabController.of(context);

          return AnimatedBuilder(
            animation:
                tabController?.animation ?? const AlwaysStoppedAnimation(0),
            builder: (context, child) {
              final bool isSelected = tabController?.index == tabIndex;
              return isSelected
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Headline2SemiBold16(
                          text: tabText,
                          color: OrmeeColor.purple[50],
                        ),

                        if (notificationCount != 0) ...[
                          SizedBox(width: 8),
                          Headline2SemiBold16(
                            text: '$notificationCount',
                            color: OrmeeColor.purple[35],
                          ),
                        ],
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Headline2Regular16(
                          text: tabText,
                          color: OrmeeColor.gray[60],
                        ),
                        if (notificationCount != 0) ...[
                          SizedBox(width: 8),
                          Headline2Regular16(
                            text: '$notificationCount',
                            color: OrmeeColor.gray[50],
                          ),
                        ],
                      ],
                    );
            },
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48.0);
}
