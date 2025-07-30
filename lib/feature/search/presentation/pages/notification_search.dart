import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/feature/search/bloc/notification/notification_search_bloc.dart';
import 'package:ormee_app/feature/search/bloc/notification/notification_search_event.dart';
import 'package:ormee_app/feature/search/bloc/notification/notification_search_state.dart';
import 'package:ormee_app/feature/search/data/notification/remote_datasource.dart';
import 'package:ormee_app/feature/search/data/notification/repository.dart';
import 'package:ormee_app/feature/search/presentation/widgets/history.dart';
import 'package:ormee_app/feature/search/presentation/widgets/notification_result.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/search_bar.dart';

class NotificationSearch extends StatelessWidget {
  const NotificationSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationSearchBloc(
        repository: NotificationSearchRepositoryImpl(
          remoteDataSource: NotificationRemoteDataSourceImpl(),
        ),
      )..add(const LoadSearchHistory()),
      child: const _NotificationSearchView(),
    );
  }
}

class _NotificationSearchView extends StatefulWidget {
  const _NotificationSearchView();

  @override
  State<_NotificationSearchView> createState() =>
      _NotificationSearchViewState();
}

class _NotificationSearchViewState extends State<_NotificationSearchView> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchHistoryTap(String keyword) {
    _controller.text = keyword;
    context.read<NotificationSearchBloc>().add(
      SearchFromHistory(keyword: keyword),
    );
  }

  void _onDeleteHistory(String keyword) {
    context.read<NotificationSearchBloc>().add(
      DeleteSearchHistory(keyword: keyword),
    );
  }

  void _onClearAllHistory() {
    context.read<NotificationSearchBloc>().add(const ClearAllSearchHistory());
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
              child:
                  BlocBuilder<NotificationSearchBloc, NotificationSearchState>(
                    builder: (context, state) {
                      return OrmeeSearchBar(
                        controller: _controller,
                        focusNode: _focusNode,
                        onChanged: (text) {
                          context.read<NotificationSearchBloc>().add(
                            UpdateSearchKeyword(keyword: text),
                          );
                        },
                        onSearch: () {
                          if (_controller.text.trim().isNotEmpty) {
                            context.read<NotificationSearchBloc>().add(
                              SearchNotifications(keyword: _controller.text),
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
      body: BlocListener<NotificationSearchBloc, NotificationSearchState>(
        listener: (context, state) {
          if (state.status == NotificationSearchStatus.failure &&
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
          child: BlocBuilder<NotificationSearchBloc, NotificationSearchState>(
            builder: (context, state) {
              return Column(
                children: [
                  const SizedBox(height: 20),
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
                  ] else ...[
                    if (state.isSearching)
                      const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (state.notifications.isEmpty)
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
                        child: SingleChildScrollView(
                          child: NotificationResult(
                            notifications: state.notifications,
                            onTap: (id) {
                              context.push('/notification/detail/$id');
                            },
                          ),
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
