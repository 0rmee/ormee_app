import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/auth/signup/bloc/signup_bloc.dart';
import 'package:ormee_app/feature/auth/signup/data/model/signup_field_type.dart';
import 'package:ormee_app/feature/auth/signup/data/model/validation_status.dart';
import 'package:ormee_app/feature/auth/signup/presentation/widgets/info_text.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';
import 'package:ormee_app/shared/widgets/button.dart';
import 'package:ormee_app/shared/widgets/textfield.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(),
      child: SignupContent(),
    );
  }
}

class SignupContent extends StatefulWidget {
  @override
  _SignupContentState createState() => _SignupContentState();
}

class _SignupContentState extends State<SignupContent> {
  final Map<SignUpFieldType, TextEditingController> _controllers = {};
  final Map<SignUpFieldType, FocusNode> _focusNodes = {};

  // ID 필드 상태 관리를 위한 변수들
  String _lastCheckedId = '';
  String _lastValidatedId = ''; // 마지막으로 validation된 ID 추가
  bool _idTextChanged = false;

  @override
  void initState() {
    super.initState();

    // 컨트롤러와 포커스 노드 초기화
    for (SignUpFieldType type in SignUpFieldType.values) {
      _controllers[type] = TextEditingController();
      _focusNodes[type] = FocusNode();
    }

    // 아이디 필드가 아닌 경우에만 포커스 잃을 때 validation 실행
    for (SignUpFieldType type in SignUpFieldType.values) {
      if (type != SignUpFieldType.id) {
        // 👈 ID 필드 제외
        _focusNodes[type]!.addListener(() {
          if (!_focusNodes[type]!.hasFocus) {
            context.read<SignUpBloc>().add(FieldValidated(type));
          }
        });
      }
    }

    // ID 필드 포커스 리스너 등록 (조건부 validation)
    _focusNodes[SignUpFieldType.id]!.addListener(() {
      if (!_focusNodes[SignUpFieldType.id]!.hasFocus) {
        _handleIdFieldUnfocus();
      }
    });

    // ID 필드 텍스트 변경 감지
    String _previousText = '';
    _controllers[SignUpFieldType.id]!.addListener(() {
      final currentText = _controllers[SignUpFieldType.id]!.text;

      // 실제로 텍스트가 변경되었을 때만 처리
      if (currentText != _previousText) {
        debugPrint(
          '📝 Text actually changed: "$_previousText" → "$currentText"',
        );
        _previousText = currentText;

        if (currentText != _lastCheckedId) {
          debugPrint('🔄 Setting _idTextChanged to true');
          setState(() {
            _idTextChanged = true;
          });
        }

        debugPrint('📤 Sending FieldChanged event');
        context.read<SignUpBloc>().add(
          FieldChanged(SignUpFieldType.id, currentText),
        );
      } else {
        debugPrint(
          '👆 Focus change detected, but text unchanged: "$currentText"',
        );
      }
    });
    // 🔥 비밀번호 필드 unfocus 시 비밀번호 확인 필드 재검증
    _focusNodes[SignUpFieldType.password]!.addListener(() {
      if (!_focusNodes[SignUpFieldType.password]!.hasFocus) {
        final passwordConfirmText =
            _controllers[SignUpFieldType.passwordConfirm]!.text;

        // 비밀번호 확인 필드에 텍스트가 있으면 재검증
        if (passwordConfirmText.isNotEmpty) {
          context.read<SignUpBloc>().add(
            FieldValidated(SignUpFieldType.passwordConfirm),
          );
        }
      }
    });
  }

  // ID 필드 unfocus 처리 로직
  void _handleIdFieldUnfocus() {
    final currentText = _controllers[SignUpFieldType.id]!.text;
    final currentState = context.read<SignUpBloc>().state;
    final currentValidation =
        currentState.validationResults[SignUpFieldType.id];

    debugPrint(
      '🔍 ID unfocus - current: "$currentText", lastChecked: "$_lastCheckedId", lastValidated: "$_lastValidatedId"',
    );
    debugPrint('📊 Current status: ${currentValidation?.status}');

    // checked 상태에서 텍스트가 변경되지 않았다면 아무것도 하지 않음
    if (currentValidation?.status == ValidationStatus.checked &&
        currentText == _lastCheckedId) {
      debugPrint('🚫 Skipping validation - text unchanged in checked state');
      return;
    }

    // 텍스트가 실제로 변경되었을 때만 validation 실행
    // 단, 초기 상태이거나 이전 validation과 다른 텍스트인 경우에만
    bool textActuallyChanged = currentText != _lastValidatedId;
    bool shouldValidate =
        currentText.isNotEmpty &&
        textActuallyChanged &&
        (currentValidation?.status == ValidationStatus.initial ||
            currentValidation?.status == ValidationStatus.valid ||
            currentValidation?.status == ValidationStatus.invalid);

    if (shouldValidate) {
      debugPrint('✅ Validating ID field on unfocus');
      context.read<SignUpBloc>().add(FieldValidated(SignUpFieldType.id));
      _lastValidatedId = currentText;
    } else {
      debugPrint('🚫 Skipping validation - conditions not met');
    }
  }

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    _focusNodes.values.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  // 개별 필드 생성 헬퍼 함수
  Widget _buildField(SignUpFieldType type, SignUpState state) {
    final validationResult =
        state.validationResults[type] ?? ValidationResult.initial;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OrmeeTextField(
          hintText: type.hintText,
          controller: _controllers[type]!,
          focusNode: _focusNodes[type]!,
          textInputAction: _getTextInputAction(type),
          isPassword: type.isPassword,
          errorText: validationResult.status == ValidationStatus.invalid
              ? ""
              : null, // 빈 문자열로 errorBorder 트리거
          onTextChanged: (text) {
            context.read<SignUpBloc>().add(FieldChanged(type, text));
          },
          onFieldSubmitted: (_) {
            _moveToNextField(type);
          },
        ),
        if (validationResult.message.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Label2Regular12(
              text: validationResult.message,
              color: validationResult.status == ValidationStatus.valid
                  ? OrmeeColor.purple[50]
                  : validationResult.status == ValidationStatus.initial
                  ? OrmeeColor.gray[60] // 초기 상태는 회색으로 표시
                  : OrmeeColor.systemError,
            ),
          ),
        if (validationResult.status == ValidationStatus.checking)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              children: [
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text(
                  '확인 중...',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSingleField(SignUpFieldType type, SignUpState state) {
    return Column(children: [_buildField(type, state), SizedBox(height: 16)]);
  }

  bool _isDuplicateCheckNeeded(ValidationResult validationResult) {
    final currentText = _controllers[SignUpFieldType.id]!.text;

    switch (validationResult.status) {
      case ValidationStatus.valid:
        return true; // 유효한 형식이면 중복확인 가능
      case ValidationStatus.checked:
        return _idTextChanged; // 중복확인 완료 상태에서는 텍스트가 변경된 경우만
      case ValidationStatus.initial:
      case ValidationStatus.invalid:
      case ValidationStatus.checking:
      default:
        return false;
    }
  }

  Widget _buildIdField(SignUpState state) {
    final validationResult =
        state.validationResults[SignUpFieldType.id] ??
        ValidationResult.idInitial;

    // 중복확인 버튼 활성화 조건
    bool isDuplicateCheckEnabled =
        _controllers[SignUpFieldType.id]!.text.isNotEmpty &&
        _isDuplicateCheckNeeded(validationResult);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: OrmeeTextField(
                hintText: SignUpFieldType.id.hintText,
                controller: _controllers[SignUpFieldType.id]!,
                focusNode: _focusNodes[SignUpFieldType.id]!,
                textInputAction: _getTextInputAction(SignUpFieldType.id),
                errorText: validationResult.status == ValidationStatus.invalid
                    ? ""
                    : null,
                onTextChanged: (text) {
                  setState(() {
                    _idTextChanged = true;
                  });
                  context.read<SignUpBloc>().add(
                    FieldChanged(SignUpFieldType.id, text),
                  );
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).unfocus();
                  context.read<SignUpBloc>().add(
                    FieldValidated(SignUpFieldType.id),
                  );
                  _moveToNextField(SignUpFieldType.id);
                },
              ),
            ),
            SizedBox(width: 8),
            OrmeeButton(
              text: "중복확인",
              isTrue: isDuplicateCheckEnabled,
              trueAction: () {
                FocusScope.of(context).unfocus();
                context.read<SignUpBloc>().add(
                  CheckIdDuplication(_controllers[SignUpFieldType.id]!.text),
                );

                // 중복확인 완료 후 상태 업데이트
                setState(() {
                  _lastCheckedId = _controllers[SignUpFieldType.id]!.text;
                  _idTextChanged = false;
                });
              },
            ),
          ],
        ),
        if (validationResult.message.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Label2Regular12(
              text: validationResult.message,
              color: validationResult.status == ValidationStatus.checked
                  ? OrmeeColor.purple[50]
                  : (validationResult.status == ValidationStatus.initial ||
                        validationResult.status == ValidationStatus.valid ||
                        validationResult.status == ValidationStatus.checking)
                  ? OrmeeColor.gray[60]
                  : OrmeeColor.systemError,
            ),
          ),
        // if (validationResult.status == ValidationStatus.checking)
        //   Padding(
        //     padding: const EdgeInsets.only(top: 4.0),
        //     child: Row(
        //       children: [
        //         SizedBox(
        //           width: 12,
        //           height: 12,
        //           child: CircularProgressIndicator(strokeWidth: 2),
        //         ),
        //         SizedBox(width: 8),
        //         Text(
        //           '확인 중...',
        //           style: TextStyle(fontSize: 12, color: Colors.grey),
        //         ),
        //       ],
        //     ),
        //   ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPhoneFields(SignUpState state) {
    final phone1Validation =
        state.validationResults[SignUpFieldType.phone1] ??
        ValidationResult.initial;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OrmeeTextField(
                hintText: SignUpFieldType.phone1.hintText,
                controller: _controllers[SignUpFieldType.phone1]!,
                focusNode: _focusNodes[SignUpFieldType.phone1]!,
                textInputAction: TextInputAction.next,
                errorText: phone1Validation.status == ValidationStatus.invalid
                    ? ""
                    : null,
                onTextChanged: (text) {
                  context.read<SignUpBloc>().add(
                    FieldChanged(SignUpFieldType.phone1, text),
                  );
                },
                onFieldSubmitted: (_) {
                  _moveToNextField(SignUpFieldType.phone1);
                },
              ),
            ),
            SizedBox(
              width: 13,
              child: Center(child: Label1Regular14(text: "-")),
            ),
            Expanded(
              child: OrmeeTextField(
                hintText: SignUpFieldType.phone2.hintText,
                controller: _controllers[SignUpFieldType.phone2]!,
                focusNode: _focusNodes[SignUpFieldType.phone2]!,
                textInputAction: TextInputAction.next,
                errorText: phone1Validation.status == ValidationStatus.invalid
                    ? ""
                    : null,
                onTextChanged: (text) {
                  context.read<SignUpBloc>().add(
                    FieldChanged(SignUpFieldType.phone2, text),
                  );
                },
                onFieldSubmitted: (_) {
                  _moveToNextField(SignUpFieldType.phone2);
                },
              ),
            ),
            SizedBox(
              width: 13,
              child: Center(child: Label1Regular14(text: "-")),
            ),
            Expanded(
              child: OrmeeTextField(
                hintText: SignUpFieldType.phone3.hintText,
                controller: _controllers[SignUpFieldType.phone3]!,
                focusNode: _focusNodes[SignUpFieldType.phone3]!,
                textInputAction: TextInputAction.next,
                errorText: phone1Validation.status == ValidationStatus.invalid
                    ? ""
                    : null,
                onTextChanged: (text) {
                  context.read<SignUpBloc>().add(
                    FieldChanged(SignUpFieldType.phone3, text),
                  );
                },
                onFieldSubmitted: (_) {
                  _moveToNextField(SignUpFieldType.phone3);
                },
              ),
            ),
          ],
        ),
        if (phone1Validation.message.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Label2Regular12(
                text: phone1Validation.message,
                color: phone1Validation.status == ValidationStatus.valid
                    ? OrmeeColor.purple[50]
                    : OrmeeColor.systemError,
              ),
            ),
          ),
        if (phone1Validation.status == ValidationStatus.checking)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '확인 중...',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildEmailFields(SignUpState state) {
    final emailValidation =
        state.validationResults[SignUpFieldType.email] ??
        ValidationResult.initial;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: OrmeeTextField(
                hintText: SignUpFieldType.email.hintText,
                controller: _controllers[SignUpFieldType.email]!,
                focusNode: _focusNodes[SignUpFieldType.email]!,
                textInputAction: TextInputAction.next,
                errorText: emailValidation.status == ValidationStatus.invalid
                    ? ""
                    : null,
                onTextChanged: (text) {
                  context.read<SignUpBloc>().add(
                    FieldChanged(SignUpFieldType.email, text),
                  );
                },
                onFieldSubmitted: (_) {
                  _moveToNextField(SignUpFieldType.email);
                },
              ),
            ),
            SizedBox(width: 8),
            Text('@', style: TextStyle(fontSize: 16)),
            SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: OrmeeTextField(
                hintText: SignUpFieldType.emailProvider.hintText,
                controller: _controllers[SignUpFieldType.emailProvider]!,
                focusNode: _focusNodes[SignUpFieldType.emailProvider]!,
                textInputAction: TextInputAction.done,
                errorText: emailValidation.status == ValidationStatus.invalid
                    ? ""
                    : null,
                onTextChanged: (text) {
                  context.read<SignUpBloc>().add(
                    FieldChanged(SignUpFieldType.emailProvider, text),
                  );
                },
                onFieldSubmitted: (_) {
                  _moveToNextField(SignUpFieldType.emailProvider);
                },
              ),
            ),
          ],
        ),
        if (emailValidation.message.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Label2Regular12(
                text: emailValidation.message,
                color: emailValidation.status == ValidationStatus.valid
                    ? OrmeeColor.purple[50]
                    : OrmeeColor.systemError,
              ),
            ),
          ),
        if (emailValidation.status == ValidationStatus.checking)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '확인 중...',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: OrmeeAppBar(
          isLecture: false,
          isImage: false,
          isDetail: false,
          isPosting: false,
          title: "회원가입",
        ),
        body: SingleChildScrollView(
          child: BlocListener<SignUpBloc, SignUpState>(
            listener: (context, state) {
              if (state.isSuccess) {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('회원가입이 완료되었습니다.')));
              }

              if (state.errorMessage != null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
              }
            },
            child: BlocBuilder<SignUpBloc, SignUpState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoText(text: "이름"),
                      _buildSingleField(SignUpFieldType.name, state),
                      InfoText(text: "아이디"),
                      // _buildSingleField(SignUpFieldType.id, state),
                      _buildIdField(state),
                      InfoText(text: "비밀번호"),
                      _buildSingleField(SignUpFieldType.password, state),
                      InfoText(text: "비밀번호 확인"),
                      _buildSingleField(SignUpFieldType.passwordConfirm, state),
                      InfoText(text: "연락처"),
                      _buildPhoneFields(state),
                      InfoText(text: "이메일"),
                      _buildEmailFields(state),

                      // 회원가입 버튼
                      // SizedBox(
                      //   width: double.infinity,
                      //   child: ElevatedButton(
                      //     onPressed: state.isLoading
                      //         ? null
                      //         : () {
                      //             context.read<SignUpBloc>().add(
                      //               const SubmitSignUp(),
                      //             );
                      //           },
                      //     child: state.isLoading
                      //         ? CircularProgressIndicator()
                      //         : Text('회원가입'),
                      //   ),
                      // ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: BlocBuilder<SignUpBloc, SignUpState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: OrmeeButton(
                text: "회원가입",
                isTrue: state.isValid && !state.isLoading,
                trueAction: () {
                  context.read<SignUpBloc>().add(const SubmitSignUp());
                },
              ),
            );
          },
        ),
      ),
    );
  }

  TextInputAction _getTextInputAction(SignUpFieldType type) {
    return type == SignUpFieldType.emailProvider
        ? TextInputAction.done
        : TextInputAction.next;
  }

  void _moveToNextField(SignUpFieldType currentType) {
    List<SignUpFieldType> fieldOrder = SignUpFieldType.values;
    int currentIndex = fieldOrder.indexOf(currentType);

    if (currentIndex < fieldOrder.length - 1) {
      SignUpFieldType nextType = fieldOrder[currentIndex + 1];
      FocusScope.of(context).requestFocus(_focusNodes[nextType]!);
    } else {
      // 마지막 필드에서 엔터 누르면 회원가입 실행
      context.read<SignUpBloc>().add(const SubmitSignUp());
    }
  }
}
