import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/feature/search/bloc/notice/notice_search_bloc.dart';
import 'package:ormee_app/feature/search/bloc/notice/notice_search_event.dart';
import 'package:ormee_app/feature/search/bloc/notice/notice_search_state.dart';
import 'package:ormee_app/feature/search/data/notice/remote_datasource.dart';
import 'package:ormee_app/feature/search/data/notice/repository.dart';
import 'package:ormee_app/feature/search/presentation/widgets/history.dart';
import 'package:ormee_app/feature/search/presentation/widgets/notice_result.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/search_bar.dart';

class NoticeSearch extends StatelessWidget {
  final int lectureId;

  const NoticeSearch({super.key, required this.lectureId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NoticeSearchBloc(
        repository: NoticeSearchRepositoryImpl(
          remoteDataSource: NoticeRemoteDataSourceImpl(),
        ),
      ),
      child: _NoticeSearchView(lectureId: lectureId),
    );
  }
}

class _NoticeSearchView extends StatefulWidget {
  final int lectureId;

  const _NoticeSearchView({required this.lectureId});

  @override
  State<_NoticeSearchView> createState() => _NoticeSearchViewState();
}

class _NoticeSearchViewState extends State<_NoticeSearchView> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 검색 기록 로드
    context.read<NoticeSearchBloc>().add(const LoadSearchHistory());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchHistoryTap(String keyword) {
    _controller.text = keyword;
    context.read<NoticeSearchBloc>().add(
      SearchFromHistory(keyword: keyword, lectureId: widget.lectureId),
    );
  }

  void _onDeleteHistory(String keyword) {
    context.read<NoticeSearchBloc>().add(DeleteSearchHistory(keyword: keyword));
  }

  void _onClearAllHistory() {
    context.read<NoticeSearchBloc>().add(const ClearAllSearchHistory());
  }

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
              child: BlocBuilder<NoticeSearchBloc, NoticeSearchState>(
                builder: (context, state) {
                  return OrmeeSearchBar(
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: (text) {
                      context.read<NoticeSearchBloc>().add(
                        UpdateSearchKeyword(keyword: text),
                      );
                    },
                    onSearch: () {
                      if (_controller.text.trim().isNotEmpty) {
                        context.read<NoticeSearchBloc>().add(
                          SearchNotices(
                            keyword: _controller.text,
                            lectureId: widget.lectureId,
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
      body: BlocListener<NoticeSearchBloc, NoticeSearchState>(
        listener: (context, state) {
          if (state.status == NoticeSearchStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocBuilder<NoticeSearchBloc, NoticeSearchState>(
            builder: (context, state) {
              return Column(
                children: [
                  const SizedBox(height: 20),

                  // 검색 시 검색 기록 숨김
                  if (!state.hasSearched) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Headline2SemiBold16(text: '최근 검색어'),
                        GestureDetector(
                          onTap: _onClearAllHistory,
                          child: Label1Semibold14(
                            text: '전체삭제',
                            color: OrmeeColor.gray[60],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // 검색 기록 리스트
                    if (state.searchHistory.isEmpty)
                      Expanded(
                        child: Center(
                          child: Body2RegularNormal14(
                            text: '최근 검색어가 없어요.',
                            color: OrmeeColor.gray[50],
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.searchHistory.length,
                          itemBuilder: (context, index) {
                            final history = state.searchHistory[index];
                            return History(
                              keyword: history.keyword,
                              searchDate: history.searchDate,
                              onTap: () => _onSearchHistoryTap(history.keyword),
                              onDelete: () => _onDeleteHistory(history.keyword),
                            );
                          },
                        ),
                      ),
                  ],

                  // 검색 결과
                  if (state.hasSearched) ...[
                    if (state.isSearching)
                      const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (state.notices.isEmpty)
                      Expanded(
                        child: Center(
                          child: Body2RegularNormal14(
                            text: '검색 결과가 없어요.',
                            color: OrmeeColor.gray[50],
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.notices.length,
                          itemBuilder: (context, index) {
                            final notice = state.notices[index];
                            return NoticeResult(
                              notice: notice,
                              onTap: () {
                                context.push('/notice/detail/${notice.id}');
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
