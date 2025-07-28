import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:ormee_app/feature/home/bloc/home_bloc.dart';
import 'package:ormee_app/feature/home/bloc/home_event.dart';
import 'package:ormee_app/feature/home/bloc/home_state.dart';
import 'package:ormee_app/feature/home/data/remote_datasource.dart';
import 'package:ormee_app/feature/home/data/repository.dart';
import 'package:ormee_app/feature/home/presentation/widgets/banner.dart';
import 'package:ormee_app/feature/home/presentation/widgets/homework_list.dart';
import 'package:ormee_app/feature/home/presentation/widgets/lecture_list.dart';
import 'package:ormee_app/feature/home/presentation/widgets/quiz_list.dart';
import 'package:ormee_app/feature/lecture/home/bloc/lecture_bloc.dart';
import 'package:ormee_app/feature/lecture/home/bloc/lecture_event.dart';
import 'package:ormee_app/feature/lecture/home/data/remote_datasource.dart';
import 'package:ormee_app/feature/lecture/home/data/repository.dart';
import 'package:ormee_app/feature/lecture/home/presentation/widgets/lecture_home_empty.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

// Wrapper 위젯으로 Provider 설정을 분리
class HomeScreenWrapper extends StatelessWidget {
  const HomeScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) =>
              HomeBloc(HomeRepository(HomeRemoteDataSource(http.Client()))),
        ),
        BlocProvider<LectureHomeBloc>(
          create: (context) => LectureHomeBloc(
            LectureHomeRepository(LectureHomeRemoteDataSource(http.Client())),
          )..add(FetchLectures()),
        ),
      ],
      child: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // 화면이 로드될 때 데이터 요청
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(LoadHomeData());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OrmeeColor.gray[10],
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 4),
          alignment: Alignment.centerLeft,
          child: SvgPicture.asset('assets/icons/ormee.svg'),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return Center(
              child: CircularProgressIndicator(color: OrmeeColor.purple[50]),
            );
          }

          if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: OrmeeColor.gray[40],
                  ),
                  SizedBox(height: 16),
                  Label1Semibold14(
                    text: '데이터를 불러오는데 실패했습니다',
                    color: OrmeeColor.gray[40],
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(LoadHomeData());
                    },
                    child: Text('다시 시도'),
                  ),
                ],
              ),
            );
          }

          if (state is HomeLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(LoadHomeData());
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 배너
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: AutoBannerSlider(banners: state.banners),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                    // 수업 섹션
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Headline2SemiBold16(text: '수업'),
                    ),
                    SizedBox(height: 6),

                    // 강의가 있는 경우와 없는 경우 분기
                    if (state.lectures.isEmpty)
                      LectureHomeEmpty(bloc: context.read<LectureHomeBloc>())
                    else
                      LectureCardSlider(lectures: state.lectures),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                    // 퀴즈 섹션
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Headline2SemiBold16(text: '퀴즈 '),
                          Headline2SemiBold16(
                            text: '${state.quizzes.length}',
                            color: OrmeeColor.purple[50],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6),

                    // 퀴즈가 있는 경우와 없는 경우 분기
                    if (state.quizzes.isEmpty)
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.12,
                        child: Center(
                          child: Label1Semibold14(
                            text: '응시 가능한 퀴즈가 없어요',
                            color: OrmeeColor.gray[40],
                          ),
                        ),
                      )
                    else
                      QuizCardSlider(quizzes: state.quizzes),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                    // 숙제 섹션
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Headline2SemiBold16(text: '숙제 '),
                          Headline2SemiBold16(
                            text: '${state.homeworks.length}',
                            color: OrmeeColor.purple[50],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6),

                    // 숙제가 있는 경우와 없는 경우 분기
                    if (state.homeworks.isEmpty)
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.12,
                        child: Center(
                          child: Label1Semibold14(
                            text: '제출 가능한 숙제가 없어요',
                            color: OrmeeColor.gray[40],
                          ),
                        ),
                      )
                    else
                      HomeworkCardSlider(homeworks: state.homeworks),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  ],
                ),
              ),
            );
          }

          // HomeInitial 상태일 때
          return Center(
            child: CircularProgressIndicator(color: OrmeeColor.purple[50]),
          );
        },
      ),
    );
  }
}
