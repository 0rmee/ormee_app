import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

/* 사용 예시
return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // 탭바 위에 올릴 내용들
              SliverToBoxAdapter(child: Container()),
              // 탭바
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0,
                pinned: true,
                floating: false,
                toolbarHeight: 0,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48.0),
                  child: OrmeeTabBar(
                    tabs: [
                      OrmeeTab(text: '공지', notificationCount: 3),
                      OrmeeTab(text: '숙제', notificationCount: null),
                      OrmeeTab(text: '퀴즈', notificationCount: 1),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: const TabBarView(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(children: [Text("내용")]),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(children: [Text("내용")]),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(children: [Text("내용")]),
              ),
            ],
          ),
        ),
      ),
    );
*/

class OrmeeTab {
  final String text;
  final int? notificationCount;

  const OrmeeTab({required this.text, this.notificationCount});
}

class OrmeeTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<OrmeeTab> tabs;
  final TabController? controller;

  const OrmeeTabBar({super.key, required this.tabs, this.controller});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
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
  }

  Widget _buildTab(OrmeeTab tab) {
    return Tab(
      child: Builder(
        builder: (context) {
          final TabController? tabController = DefaultTabController.of(context);
          final int currentIndex = tabs.indexOf(tab);

          return AnimatedBuilder(
            animation:
                tabController?.animation ?? const AlwaysStoppedAnimation(0),
            builder: (context, child) {
              final bool isSelected = tabController?.index == currentIndex;
              final bool hasNotification =
                  tab.notificationCount != null && tab.notificationCount! > 0;

              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isSelected
                      ? Headline2SemiBold16(
                          text: tab.text,
                          color: OrmeeColor.purple[50],
                        )
                      : Headline2Regular16(
                          text: tab.text,
                          color: OrmeeColor.gray[60],
                        ),
                  if (hasNotification) ...[
                    const SizedBox(width: 8),
                    isSelected
                        ? Headline2SemiBold16(
                            text: '${tab.notificationCount}',
                            color: OrmeeColor.purple[35],
                          )
                        : Headline2Regular16(
                            text: '${tab.notificationCount}',
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

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final OrmeeTabBar tabBar;

  StickyTabBarDelegate({required this.tabBar});

  @override
  double get minExtent => 48.0; // 고정된 높이 사용

  @override
  double get maxExtent => 48.0; // 고정된 높이 사용

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(height: 48.0, color: Colors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate != this;
  }

  @override
  OverScrollHeaderStretchConfiguration? get stretchConfiguration => null;

  @override
  PersistentHeaderShowOnScreenConfiguration? get showOnScreenConfiguration =>
      null;

  @override
  FloatingHeaderSnapConfiguration? get snapConfiguration => null;
}
