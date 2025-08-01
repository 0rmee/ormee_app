import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/feature/mypage/list/bloc/mypage_list_bloc.dart';
import 'package:ormee_app/feature/mypage/list/bloc/mypage_list_event.dart';
import 'package:ormee_app/feature/mypage/list/bloc/mypage_list_state.dart';
import 'package:ormee_app/feature/mypage/list/data/repository.dart';
import 'package:ormee_app/feature/mypage/list/data/remote_datasource.dart';
import 'package:ormee_app/feature/mypage/list/presentation/widgets/appbar.dart';
import 'package:ormee_app/feature/mypage/list/presentation/widgets/mypage_card.dart';
import 'package:ormee_app/feature/mypage/list/presentation/widgets/profile_card.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/toast.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyPageListBloc(
        MyPageProfileRepository(MyPageProfileRemoteDatasource()),
      )..add(FetchMyPageList()),
      child: BlocConsumer<MyPageListBloc, MyPageListState>(
        listener: (context, state) {
          if (state is MyPageListError) {
            OrmeeToast.show(context, state.message);
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is MyPageListLoaded) {
            final name = state.name;
            return Scaffold(
              appBar: MyPageAppBar(title: '마이페이지'),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    ProfileCard(name: name),
                    SizedBox(height: 10),
                    MyPageCard(
                      icon: 'assets/icons/list.svg',
                      title: '수강내역',
                      onTap: () {
                        // 수강내역 페이지
                      },
                    ),
                    MyPageCard(
                      icon: 'assets/icons/notification_empty.svg',
                      title: '알림설정',
                      onTap: () {
                        // 알림 설정 화면 라우팅
                      },
                    ),
                    Divider(
                      height: 16,
                      thickness: 1,
                      color: OrmeeColor.gray[20],
                    ),
                    // MyPageCard(
                    //   icon: 'assets/icons/help.svg',
                    //   title: 'FAQ',
                    //   onTap: () {
                    //     // FAQ 화면 라우팅
                    //   },
                    // ),
                    MyPageCard(
                      icon: 'assets/icons/hand.svg',
                      title: '이용약관',
                      onTap: () {
                        // 이용약관 화면 라우탱
                      },
                    ),
                    MyPageCard(
                      icon: 'assets/icons/verified.svg',
                      title: '개인정보처리방침',
                      onTap: () {
                        // 개인정보처리방침 라우팅
                      },
                    ),
                    MyPageCard(
                      icon: 'assets/icons/info.svg',
                      title: '버전',
                      onTap: () {
                        // 버전 상세
                      },
                    ),
                    Divider(
                      height: 16,
                      thickness: 1,
                      color: OrmeeColor.gray[20],
                    ),
                    MyPageCard(
                      icon: 'assets/icons/logout.svg',
                      title: '로그아웃',
                      onTap: () {
                        // 로그아
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
