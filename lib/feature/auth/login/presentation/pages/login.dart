import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/feature/auth/login/bloc/login_bloc.dart';
import 'package:ormee_app/feature/auth/login/bloc/login_event.dart';
import 'package:ormee_app/feature/auth/login/bloc/login_state.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/button.dart';
import 'package:ormee_app/shared/widgets/textfield.dart';
import 'package:ormee_app/shared/widgets/toast.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final TextEditingController _idController;
  late final FocusNode _idFocusNode;

  late final TextEditingController _pwController;
  late final FocusNode _pwFocusNode;
  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _idFocusNode = FocusNode();
    _pwController = TextEditingController();
    _pwFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _idController.dispose();
    _idFocusNode.dispose();
    _pwController.dispose();
    _pwFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.success) {
            OrmeeToast.show(context, "로그인 성공");
            //Navigator.pushReplacementNamed(context, '/home'); // 홈 화면으로 이동
            context.push('/home');
          } else if (state.status == LoginStatus.failure) {
            OrmeeToast.show(context, "로그인 실패");
          }
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // 로고
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset("assets/images/logo.svg"),
                            SizedBox(height: 16),
                            Body2RegularNormal14(text: "하나로 끝내는 수업 관리의 새로운 기준"),
                          ],
                        ),

                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 로그인 폼
                            OrmeeTextField(
                              hintText: "아이디를 입력하세요.",
                              controller: _idController,
                              focusNode: _idFocusNode,
                              textInputAction: TextInputAction.next,
                              //isTextNotEmpty: state.isIdNotEmpty,
                              onTextChanged: (text) {
                                context.read<LoginBloc>().add(IdChanged(text));
                              },
                              onFieldSubmitted: (_) {
                                FocusScope.of(
                                  context,
                                ).requestFocus(_pwFocusNode);
                              },
                            ),
                            SizedBox(height: 6),
                            OrmeeTextField(
                              hintText: "비밀번호를 입력하세요.",
                              controller: _pwController,
                              focusNode: _pwFocusNode,
                              textInputAction: TextInputAction.next,
                              //isTextNotEmpty: state.isPwNotEmpty,
                              isPassword: true,
                              onTextChanged: (text) {
                                context.read<LoginBloc>().add(PwChanged(text));
                              },
                              onFieldSubmitted: (term) {
                                FocusScope.of(context).unfocus();
                              },
                            ),
                            SizedBox(height: 26),
                            Row(
                              children: [
                                Expanded(
                                  child: OrmeeButton(
                                    text: '로그인',
                                    isTrue: state.isFormValid,
                                    trueAction: () {
                                      FocusScope.of(context).unfocus();
                                      context.read<LoginBloc>().add(
                                        LoginSubmitted(
                                          username: _idController.text,
                                          password: _pwController.text,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Label2Regular12(
                                  text: "아이디/비밀번호 찾기",
                                  color: OrmeeColor.gray[60],
                                ),
                                SizedBox(width: 12),
                                SvgPicture.asset(
                                  "assets/icons/vertical_bar.svg",
                                ),
                                SizedBox(width: 12),
                                Label2Regular12(
                                  text: "회원가입",
                                  color: OrmeeColor.gray[60],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
