import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tools_tkmonkey/tools_tkmonkey.dart';

import 'controller.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (_) => AnimationsProvider(),
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int index = 0;

  final listOfWidgets = [
    PageViewOne(),
    PageViewTwo(),
    PageViewThree(),
  ];

  @override
  void initState() {
    super.initState();

    context.read<AnimationsProvider>().addVsyncToAnimation(this);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      body: PageTransitionSwitcher(
        transitionBuilder: (
          Widget child,
          Animation<double> primaryAnimation,
          Animation<double> secondaryAnimation,
        ) {
          return SharedAxisTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
        child: listOfWidgets[index],
      ),
      bottomNavigationBar: AnimatedContainer(
        height: !context.watch<AnimationsProvider>().actionWidgetAnimationCall
            ? (75 + bottomPadding / 2)
            : 0,
        duration: Duration(milliseconds: 300),
        // child: Container(
        //   color: Colors.amber,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Icon(Icons.abc),
        //       Icon(Icons.abc),
        //       Icon(Icons.abc),
        //     ],
        //   ),
        // )
        child: Stack(
          children: [
            NavigationBar(
              selectedIndex: index,
              backgroundColor: Colors.white,
              onDestinationSelected: (i) {
                setState(() {
                  index = i;
                });
              },
              destinations: [
                NavigationDestination(
                  label: 'One',
                  icon: Icon(Icons.home),
                ),
                NavigationDestination(
                  label: 'Two',
                  icon: Icon(Icons.ac_unit),
                ),
                NavigationDestination(
                  label: 'Three',
                  icon: Icon(Icons.access_time_filled_outlined),
                ),
              ],
            ),
            VisibilityAndFadeAnimation(
              conditionToStarAnimation: !context
                  .watch<AnimationsProvider>()
                  .showCenterWidgetAnimationCall,
              child: GestureDetector(
                onTap: context
                    .read<AnimationsProvider>()
                    .runCenterWidgetAppbarAnimation,
                child: OverlayForBottombarView(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    context.read<AnimationsProvider>().arrowTitleController.dispose();
    context.read<AnimationsProvider>().appbarController.dispose();
    super.dispose();
  }
}

class PageViewOne extends StatelessWidget {
  const PageViewOne({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OneAppbar(),
      body: Stack(
        children: [
          Container(
            child: Center(
              child: InkWell(
                onTap: () {
                  print('msg');
                },
                child: Text('Page One'),
              ),
            ),
          ),
          AddWalletFadeView(),
          WalletListFadeView(),
        ],
      ),
    );
  }
}

class OverlayForBottombarView extends StatelessWidget {
  const OverlayForBottombarView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.3),
    );
  }
}

class WalletListFadeView extends StatelessWidget {
  const WalletListFadeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VisibilityAndFadeAnimation(
      conditionToStarAnimation:
          !context.watch<AnimationsProvider>().showCenterWidgetAnimationCall,
      child: Column(
        children: [
          Flexible(
            flex: 9,
            child: Container(
              child: ColoredBox(
                color: Colors.blue,
                child: Center(
                  child: Text('SECOND HIDE'),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: GestureDetector(
              onTap: context
                  .read<AnimationsProvider>()
                  .runCenterWidgetAppbarAnimation,
              child: OverlayForBottombarView(),
            ),
          ),
        ],
      ),
    );
  }
}

class AddWalletFadeView extends StatelessWidget {
  const AddWalletFadeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VisibilityAndFadeAnimation(
      conditionToStarAnimation:
          !context.watch<AnimationsProvider>().actionWidgetAnimationCall,
      child: Container(
        child: ColoredBox(
          color: Colors.green,
          child: Center(
            child: Text('To FADE'),
          ),
        ),
      ),
    );
  }
}

class VisibilityAndFadeAnimation extends StatelessWidget {
  const VisibilityAndFadeAnimation({
    Key? key,
    required this.conditionToStarAnimation,
    required this.child,
  }) : super(key: key);

  final bool conditionToStarAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      child: conditionToStarAnimation ? const SizedBox() : child,
    );
  }
}

class PageViewTwo extends StatelessWidget {
  const PageViewTwo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TwoAppbar(),
      body: Center(
        child: GestureDetector(
          onTap: context.read<AnimationsProvider>().runActionAppbarAnimation,
          child: Text('Page Two'),
        ),
      ),
    );
  }
}

class PageViewThree extends StatelessWidget {
  const PageViewThree({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThreeAppbar(),
      body: Center(child: Text('Page Three')),
    );
  }
}

class AnimationsProvider extends ChangeNotifier {
  late AnimationController _appbarController;
  late AnimationController _arrowTitleController;

  bool _actionWidgetAnimationCall = false;
  bool _centerWidgetAnimationCall = false;

  void addVsyncToAnimation(TickerProvider state) {
    _appbarController = AnimationController(
      vsync: state,
      duration: const Duration(milliseconds: 600),
    );

    _arrowTitleController = AnimationController(
      vsync: state,
      duration: const Duration(milliseconds: 600),
      lowerBound: 0,
      upperBound: 0.5,
    );
  }

  AnimationController get appbarController => _appbarController;
  AnimationController get arrowTitleController => _arrowTitleController;

  bool get actionWidgetAnimationCall => _actionWidgetAnimationCall;
  bool get centerWidgetAnimationCall => _centerWidgetAnimationCall;
  bool get showCenterWidgetAnimationCall =>
      !_actionWidgetAnimationCall && _centerWidgetAnimationCall;

  void runActionAppbarAnimation() {
    if (isAnimationCompleted(_appbarController)) {
      _changeFlagsForActionAnimation();
      _appbarController.reverse();
    } else if (isAnimationDismissed(_appbarController)) {
      _changeFlagsForActionAnimation();
      _appbarController.forward();
    }
  }

  void runCenterWidgetAppbarAnimation() {
    if (isAnimationCompleted(_arrowTitleController)) {
      _changeFlagsForCenterAnimation();
      _arrowTitleController.reverse();
    } else if (isAnimationDismissed(_arrowTitleController)) {
      _changeFlagsForCenterAnimation();
      _arrowTitleController.forward();
    }
  }

  void _changeFlagsForActionAnimation() {
    _actionWidgetAnimationCall = !_actionWidgetAnimationCall;
    notifyListeners();
  }

  void _changeFlagsForCenterAnimation() {
    _centerWidgetAnimationCall = !_centerWidgetAnimationCall;
    notifyListeners();
  }

  bool isAnimationDismissed(AnimationController animationController) =>
      animationController.status == AnimationStatus.dismissed;
  bool isAnimationCompleted(AnimationController animationController) =>
      animationController.status == AnimationStatus.completed;
}
// class AnimationsControllersProvider extends ChangeNotifier {
//   late CustomAnimationCtrl _appbarController;
//   late CustomAnimationCtrl _addWalletFadeController;

//   CustomAnimationCtrl get customAnimationController => _appbarController;

//   void createCustomController(TKMControllerMixin state) {
//     _appbarController = CustomAnimationCtrl()..addState = state;
//   }

//   void onBackTap() {}

//   void onActionWidgetTap() {}

//   void onTitleTap() {}

//   void runAnimation() {
//     _appbarController.runFunction();
//   }
// }

class OneAppbar extends StatelessWidget implements PreferredSizeWidget {
  const OneAppbar({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return MyAppbarWidget(
      actionType: ActionWidgetAnimation.rotate,
      leftWidget: Text('Add Wallet'),
      centerWidget: ArrowTittleWidget(),
      rightWidget: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Icon(Icons.add_rounded, color: Colors.white),
        ),
      ),
    );
  }
}

class TwoAppbar extends StatelessWidget implements PreferredSizeWidget {
  const TwoAppbar({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return MyAppbarWidget(
      actionType: ActionWidgetAnimation.fadeOut,
      leftWidget: Text('Consolidate'),
      centerWidget: Text(
        'Consolidate',
        overflow: TextOverflow.ellipsis,
      ),
      rightWidget: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Icon(Icons.add_rounded, color: Colors.white),
        ),
      ),
    );
  }
}

class ThreeAppbar extends StatelessWidget implements PreferredSizeWidget {
  const ThreeAppbar({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return MyAppbarWidget(
      actionType: ActionWidgetAnimation.nothing,
      leftWidget: Text('Add Wallet'),
      centerWidget: Text(
        'Settings',
        overflow: TextOverflow.ellipsis,
      ),
      rightWidget: TextButton(
        onPressed: () {
          print('Reset click');
        },
        child: Text(
          'Reset',
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class ArrowTittleWidget extends StatefulWidget {
  const ArrowTittleWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ArrowTittleWidget> createState() => _ArrowTittleWidgetState();
}

class _ArrowTittleWidgetState extends State<ArrowTittleWidget> {
  @override
  void initState() {
    super.initState();

    // _rotatingArrowController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 600),
    //   lowerBound: 0,
    //   upperBound: 0.5,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: context.read<AnimationsProvider>().runCenterWidgetAppbarAnimation,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Text(
              'TExtO',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          RotationTransition(
            turns: context.read<AnimationsProvider>().arrowTitleController,
            child: Icon(
              Icons.expand_more_rounded,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class MyAppbarWidget extends StatefulWidget {
  const MyAppbarWidget({
    Key? key,
    required this.leftWidget,
    required this.rightWidget,
    required this.centerWidget,
    this.actionType = ActionWidgetAnimation.nothing,
    this.showBackButton = false,
    this.onBackTap,
    this.from,
  }) : super(key: key);

  final Widget leftWidget;
  final Widget rightWidget;
  final Widget centerWidget;
  final ActionWidgetAnimation actionType;
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final String? from;

  @override
  State<MyAppbarWidget> createState() => _MyAppbarWidgetState();
}

class _MyAppbarWidgetState extends State<MyAppbarWidget> {
  // late AnimationController _animationController;
  // animations handlers
  late Animation<Offset> _animationTranslateDown;
  late Animation<Offset> _animationTranslateRight;
  late Animation<double> _animationOppacityDown;
  late Animation<double> _animationOppacityRight;

  /// Rotation, Fade or Nothing,
  /// for fade the widget use `_animationOppacityDown`
  late Animation<double> _animationRotationActionWidget;
  late Animation<double> _animationOppacityEnd;

  @override
  void initState() {
    super.initState();

    // animationController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 600),
    // );

    _initAnimations();

    // Provider.of<AnimationsControllersProvider>(context, listen: false)
    //     .createCustomController(this);
    //animation: Listenable.merge([progressAnimation, cloudOutAnimation]),
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: topPadding,
      ),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          // back button
          Align(
            alignment: Alignment.centerLeft,
            child: Visibility(
              visible: widget.showBackButton,
              child: FadeTransition(
                opacity: _animationOppacityRight,
                child: IconButton(
                  icon: Icon(
                    Icons.west,
                    color: Colors.black,
                  ),
                  onPressed: widget.onBackTap ??
                      () {
                        //TODO BACK Her
                      },
                ),
              ),
            ),
          ),
          // Hide: Fade and slide from top
          Align(
            alignment: Alignment.centerLeft,
            child: SlideTransition(
              position: _animationTranslateDown,
              child: FadeTransition(
                opacity: _animationOppacityDown,
                child: widget.leftWidget,
              ),
            ),
          ),
          // Visible: Fade and slide to right
          Align(
            alignment: Alignment.center,
            child: SlideTransition(
              position: _animationTranslateRight,
              child: FadeTransition(
                opacity: _animationOppacityRight,
                child: widget.centerWidget,
              ),
            ),
          ),
          //Dependes of situation, rotate, fade or not
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap:
                  context.read<AnimationsProvider>().runActionAppbarAnimation,
              child: _RotateFadeOrNothing(
                type: widget.actionType,
                animationTurns: _animationRotationActionWidget,
                animationOpacity: _animationOppacityEnd,
                child: widget.rightWidget,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _initAnimations() {
    AnimationController _animationController =
        context.read<AnimationsProvider>().appbarController;

    _animationTranslateDown = Tween<Offset>(
      begin: const Offset(0, -3),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8),
      ),
    );
    _animationTranslateRight = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0.8, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8),
      ),
    );

    _animationOppacityDown = Tween<double>(
      begin: 0.0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.5),
        reverseCurve: const Interval(0.0, 1),
      ),
    );

    final fadeOut = widget.actionType == ActionWidgetAnimation.fadeOut;

    _animationOppacityEnd = Tween<double>(
      begin: fadeOut ? 0.0 : 1,
      end: fadeOut ? 1 : 0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.1, 0.6),
        reverseCurve: const Interval(0.5, 1),
      ),
    );

    _animationOppacityRight = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5),
        reverseCurve: const Interval(0.5, 1),
      ),
    );

    _animationRotationActionWidget = Tween<double>(
      begin: fadeOut ? 0.125 : 0,
      end: fadeOut ? 0 : 0.125,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 0.5),
        reverseCurve: const Interval(0.5, 1),
      ),
    );
  }
}

enum ActionWidgetAnimation {
  rotate,
  fadeIn,
  fadeOut,
  nothing,
}

class _RotateFadeOrNothing extends StatelessWidget {
  const _RotateFadeOrNothing({
    Key? key,
    this.child,
    required this.type,
    this.animationTurns,
    this.animationOpacity,
  }) : super(key: key);

  final ActionWidgetAnimation type;
  final Widget? child;
  final Animation<double>? animationTurns;
  final Animation<double>? animationOpacity;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ActionWidgetAnimation.rotate:
        return RotationTransition(
          turns: animationTurns!,
          child: child,
        );

      case ActionWidgetAnimation.fadeOut:
        return FadeTransition(
          opacity: animationOpacity!,
          child: RotationTransition(
            turns: animationTurns!,
            child: child,
          ),
        );

      case ActionWidgetAnimation.fadeIn:
        return FadeTransition(
          opacity: animationOpacity!,
          child: child,
        );
      case ActionWidgetAnimation.nothing:
        return SizedBox(child: child);
    }
  }
}
