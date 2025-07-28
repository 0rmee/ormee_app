import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/feature/memo/bloc/memo_bloc.dart';
import 'package:ormee_app/feature/memo/bloc/memo_event.dart';
import 'package:ormee_app/feature/memo/bloc/memo_state.dart';
import 'package:ormee_app/feature/memo/data/repository.dart';
import 'package:ormee_app/feature/memo/data/remote_datasource.dart';
import 'package:ormee_app/feature/memo/presentation/widgets/teacher_bubble.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/button.dart';
import 'package:ormee_app/shared/widgets/textfield.dart';
import 'package:ormee_app/shared/widgets/toast.dart';

class MemoDialog extends StatelessWidget {
  final VoidCallback? onClose;
  final VoidCallback? onSubmitted;
  final int memoId;

  const MemoDialog({
    super.key,
    this.onClose,
    this.onSubmitted,
    required this.memoId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MemoBloc(
        repository: MemoRepositoryImpl(
          remoteDataSource: MemoRemoteDataSource(),
        ),
      )..add(LoadMemoDetail(memoId: memoId)),
      child: MemoDialogView(
        onClose: onClose,
        onSubmitted: onSubmitted,
        memoId: memoId,
      ),
    );
  }
}

class MemoDialogView extends StatefulWidget {
  final VoidCallback? onClose;
  final VoidCallback? onSubmitted;
  final int memoId;

  const MemoDialogView({
    super.key,
    this.onClose,
    this.onSubmitted,
    required this.memoId,
  });

  @override
  State<MemoDialogView> createState() => _MemoDialogViewState();
}

class _MemoDialogViewState extends State<MemoDialogView> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MemoBloc, MemoState>(
      listener: (context, state) {
        if (state is MemoSubmitSuccess) {
          OrmeeToast.show(context, state.message);
          // 제출 성공 시 onSubmitted 콜백 호출
          widget.onSubmitted?.call();
        } else if (state is MemoSubmitError) {
          OrmeeToast.show(context, state.message);
        } else if (state is MemoDetailError) {
          OrmeeToast.show(context, state.message);
        }
      },
      builder: (context, state) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: OrmeeColor.white,
          surfaceTintColor: Colors.transparent,
          title: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Heading2SemiBold20(
                  text: '쪽지',
                  color: OrmeeColor.gray[90],
                ),
              ),
              Positioned(
                right: 0,
                child: GestureDetector(
                  onTap: widget.onClose ?? () => context.pop(),
                  child: SvgPicture.asset("assets/icons/x.svg"),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: _buildContent(context, state),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, MemoState state) {
    if (state is MemoLoading) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 40),
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            '쪽지를 불러오는 중...',
            style: TextStyle(fontSize: 14, color: OrmeeColor.gray[60]),
          ),
          const SizedBox(height: 40),
        ],
      );
    }

    if (state is MemoDetailLoaded) {
      final memo = state.memo;

      // 기존 제출 내용이 있으면 텍스트 필드에 표시
      if (memo.submission != null &&
          memo.submission!.isNotEmpty &&
          _controller.text.isEmpty) {
        _controller.text = memo.submission!;
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TeacherBubble(text: memo.title, memoState: memo.isOpen),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: OrmeeTextField(
                  hintText: "쉼표로 구분해 입력하세요. ex) 1, 7, 18",
                  controller: _controller,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (text) => _submitMemo(context, memo),
                  focusNode: _focusNode,
                  maxLines: 5,
                ),
              ),
              const SizedBox(width: 12),
              BlocBuilder<MemoBloc, MemoState>(
                builder: (context, submitState) {
                  final isSubmitting = submitState is MemoSubmitting;
                  return OrmeeButton(
                    trueAction: isSubmitting
                        ? null
                        : () => _submitMemo(context, memo),
                    text: isSubmitting ? '제출 중...' : '제출',
                    isTrue: !isSubmitting && _controller.text.trim().isNotEmpty,
                  );
                },
              ),
            ],
          ),
          if (memo.submission != null && memo.submission!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: OrmeeColor.gray[10],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: OrmeeColor.gray[30]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: OrmeeColor.gray[60],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '이미 제출된 내용이 있습니다. 다시 제출하면 기존 내용이 수정됩니다.',
                      style: TextStyle(
                        fontSize: 12,
                        color: OrmeeColor.gray[60],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    }

    if (state is MemoDetailError) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
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
                LoadMemoDetail(memoId: widget.memoId),
              );
            },
            child: const Text('다시 시도'),
          ),
          const SizedBox(height: 20),
        ],
      );
    }

    return const SizedBox();
  }

  void _submitMemo(BuildContext context, memo) {
    final submission = _controller.text.trim();

    if (submission.isEmpty) {
      OrmeeToast.show(context, '제출할 내용을 입력해주세요.');
      return;
    }

    context.read<MemoBloc>().add(
      SubmitMemo(memoId: widget.memoId, context: submission),
    );
  }
}
