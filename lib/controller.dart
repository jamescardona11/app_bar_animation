import 'package:tools_tkmonkey/tools_tkmonkey.dart';

class CustomAnimationCtrl extends TKMController
    with
        ForwardFunction,
        ReverseFunction,
        RunFunction,
        GetPositionFunction,
        StateAnimationFunction {
  void open() => forwardFunction();

  void close() => reverseFunction();

  void start() => runFunction();

  bool get isOptionsOpened => isAnimationCompleted;

  bool get isOptionsClosed => isAnimationDismissed;
}
