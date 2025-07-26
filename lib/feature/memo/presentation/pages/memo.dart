import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/memo/bloc/memo_bloc.dart';
import 'package:ormee_app/feature/memo/bloc/memo_event.dart';
import 'package:ormee_app/feature/memo/bloc/memo_state.dart';
import 'package:ormee_app/feature/memo/data/model.dart';
import 'package:ormee_app/feature/memo/data/repository.dart';
import 'package:ormee_app/feature/memo/data/remote_datasource.dart';
import 'package:ormee_app/feature/memo/presentation/widgets/student_bubble.dart';
import 'package:ormee_app/feature/memo/presentation/widgets/teacher_bubble.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';

class Memo extends StatelessWidget {
  final int lectureId;

  const Memo({super.key, required this.lectureId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MemoBloc(
        repository: MemoRepositoryImpl(
          remoteDataSource: MemoRemoteDataSource(),
        ),
      )..add(LoadMemoList(lectureId: lectureId)),
      child: MemoView(lectureId: lectureId),
    );
  }
}

class MemoView extends StatelessWidget {
  final int lectureId;

  const MemoView({super.key, required this.lectureId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrmeeAppBar(
        isLecture: false,
        isImage: false,
        isDetail: false,
        isPosting: false,
        title: "보낸 쪽지",
      ),
      body: BlocConsumer<MemoBloc, MemoState>(
        listener: (context, state) {
          if (state is MemoListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              final bloc = context.read<MemoBloc>();
              bloc.add(RefreshMemoList(lectureId: lectureId));
            },
            child: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, MemoState state) {
    if (state is MemoLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is MemoListLoaded) {
      return _buildMemoList(context, state);
    }

    if (state is MemoListError) {
      return _buildErrorView(context, state);
    }

    return _buildInitialView(context);
  }

  Widget _buildMemoList(BuildContext context, MemoListLoaded state) {
    final memoList = state.memoList;

    if (memoList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.message_outlined, size: 48, color: OrmeeColor.gray[50]),
            const SizedBox(height: 16),
            Text(
              '아직 받은 쪽지가 없습니다',
              style: TextStyle(
                fontSize: 16,
                color: OrmeeColor.gray[70],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(children: _buildMemoItems(context, memoList)),
    );
  }

  List<Widget> _buildMemoItems(BuildContext context, List<MemoModel> memoList) {
    List<Widget> widgets = [];
    String? lastDate;

    for (int i = 0; i < memoList.length; i++) {
      final memo = memoList[i];
      final currentDate = _getDateOnly(memo.dueTime);

      // 날짜가 달라질 때만 divider 추가 (맨 처음 제외)
      if (lastDate != null && lastDate != currentDate) {
        widgets.add(
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            height: 1,
            color: OrmeeColor.gray[20],
          ),
        );
      }

      // 같은 날짜의 첫 번째 쪽지에만 날짜 표시
      if (lastDate != currentDate) {
        widgets.add(
          Column(
            children: [
              Label2Regular12(
                text: _formatDate(memo.dueTime),
                color: OrmeeColor.gray[50],
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      }

      widgets.add(_buildMemoItem(context, memo));
      lastDate = currentDate;
    }

    return widgets;
  }

  Widget _buildMemoItem(BuildContext context, MemoModel memo) {
    return Column(
      children: [
        TeacherBubble(
          text: memo.title,
          memoState: false,
          autherImage: memo.authorImage,
        ),
        const SizedBox(height: 8),
        if (memo.submission != null && memo.submission!.isNotEmpty)
          StudentBubble(context, memo.submission!),
      ],
    );
  }

  String _getDateOnly(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  Widget _buildErrorView(BuildContext context, MemoListError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: OrmeeColor.gray[50]),
          const SizedBox(height: 16),
          Text(
            '쪽지를 불러올 수 없습니다',
            style: TextStyle(
              fontSize: 16,
              color: OrmeeColor.gray[70],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state.message,
            style: TextStyle(fontSize: 14, color: OrmeeColor.gray[50]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<MemoBloc>().add(
                RefreshMemoList(lectureId: lectureId),
              );
            },
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            height: 1,
            color: OrmeeColor.gray[20],
          ),
          Label2Regular12(text: "쪽지를 불러오는 중...", color: OrmeeColor.gray[50]),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    final weekday = weekdays[dateTime.weekday % 7];

    return '${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')} ($weekday)';
  }
}
