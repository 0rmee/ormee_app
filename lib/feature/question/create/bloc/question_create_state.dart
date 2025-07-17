class QuestionCreateState {
  final String title;

  QuestionCreateState({required this.title});

  QuestionCreateState copyWith({String? title}) {
    return QuestionCreateState(title: title ?? this.title);
  }
}
