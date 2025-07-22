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
  final void Function(int) onTap;

  const OrmeeTabBar2({
    super.key,
    required this.tabs,
    required this.currentIndex,
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
            tabs: tabs.map((tab) => _buildTab(tab)).toList(),
          );
        },
      ),
    );
  }

  Widget _buildTab(String tabText) {
    return Tab(
      child: Builder(
        builder: (context) {
          final TabController? tabController = DefaultTabController.of(context);
          final int currentTabIndex = tabs.indexOf(tabText);

          return AnimatedBuilder(
            animation:
                tabController?.animation ?? const AlwaysStoppedAnimation(0),
            builder: (context, child) {
              final bool isSelected = tabController?.index == currentTabIndex;

              return isSelected
                  ? Headline2SemiBold16(
                      text: tabText,
                      color: OrmeeColor.purple[50],
                    )
                  : Headline2Regular16(
                      text: tabText,
                      color: OrmeeColor.gray[60],
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
