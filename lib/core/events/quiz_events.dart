import 'dart:async';

class QuizDetailRefreshEvent {
  final int quizId;
  QuizDetailRefreshEvent(this.quizId);
}

class GlobalEventBus {
  static final GlobalEventBus _instance = GlobalEventBus._internal();
  factory GlobalEventBus() => _instance;
  GlobalEventBus._internal();

  final StreamController<dynamic> _controller = StreamController.broadcast();

  Stream<T> on<T>() {
    return _controller.stream.where((event) => event is T).cast<T>();
  }

  void fire(dynamic event) {
    _controller.add(event);
  }

  void dispose() {
    _controller.close();
  }
}
