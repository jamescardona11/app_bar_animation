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
        child: NavigationBar(
          selectedIndex: index,
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
      ),
    );
  }

  @override
  void dispose() {
    context.read<AnimationsProvider>().dispose();
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
          ToFadeView(
            child: Center(
              child: Text('To FADE'),
            ),
          ),
        ],
      ),
    );
  }
}

class ToFadeView extends StatefulWidget {
  const ToFadeView({
    Key? key,
    required this.child,
    this.visibleForDefault = false,
  }) : super(key: key);

  final bool visibleForDefault;
  final Widget child;

  @override
  State<ToFadeView> createState() => _ToFadeViewState();
}

class _ToFadeViewState extends State<ToFadeView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _animationController =
        context.read<AnimationsProvider>().animationController;

    _opacityAnimation = Tween<double>(
      begin: !widget.visibleForDefault ? 0 : 1,
      end: !widget.visibleForDefault ? 1 : 0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0, 0.2, curve: Curves.easeIn),
        reverseCurve: Interval(0.8, 1, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, Widget? child) => Visibility(
        visible: _animationController.value != animationBeginValue,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: child,
        ),
      ),
      child: ColoredBox(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(child: widget.child),
          ],
        ),
      ),
    );
  }

  double get animationBeginValue => widget.visibleForDefault ? 1 : 0;
}

class PageViewTwo extends StatelessWidget {
  const PageViewTwo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appbar 2',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(child: Text('Page Two')),
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
      appBar: AppBar(
        title: Text(
          'Appbar 3',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(child: Text('Page Three')),
    );
  }
}

class AnimationsProvider extends ChangeNotifier {
  late AnimationController _animationController;
  bool _actionWidgetAnimationCall = false;

  void addVsyncToAnimation(TickerProvider state) {
    _animationController = AnimationController(
      vsync: state,
      duration: const Duration(milliseconds: 600),
    );
  }

  AnimationController get animationController => _animationController;
  bool get actionWidgetAnimationCall => _actionWidgetAnimationCall;

  void runActionAppbarAnimation() {
    if (isAnimationCompleted) {
      _actionWidgetAnimationCall = false;
      _animationController.reverse();
    } else if (isAnimationDismissed) {
      _actionWidgetAnimationCall = true;
      _animationController.forward();
    }

    notifyListeners();
  }

  bool get isAnimationDismissed =>
      animationController.status == AnimationStatus.dismissed;
  bool get isAnimationCompleted =>
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

class ArrowTittleWidget extends StatefulWidget {
  const ArrowTittleWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ArrowTittleWidget> createState() => _ArrowTittleWidgetState();
}

class _ArrowTittleWidgetState extends State<ArrowTittleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotatingArrowController;

  @override
  void initState() {
    super.initState();

    _rotatingArrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      lowerBound: 0,
      upperBound: 0.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_rotatingArrowController.status == AnimationStatus.completed) {
          _rotatingArrowController.reverse();
        } else if (_rotatingArrowController.status ==
            AnimationStatus.dismissed) {
          _rotatingArrowController.forward();
        }
      },
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
            turns: _rotatingArrowController,
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

class _MyAppbarWidgetState extends State<MyAppbarWidget>
    with SingleTickerProviderStateMixin {
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
        context.read<AnimationsProvider>().animationController;

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

    final startOnOpacityActionWidget =
        widget.actionType == ActionWidgetAnimation.fadeOut;

    _animationOppacityEnd = Tween<double>(
      begin: startOnOpacityActionWidget ? 0.0 : 1,
      end: startOnOpacityActionWidget ? 1 : 0,
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

    _animationRotationActionWidget =
        Tween<double>(begin: 0, end: 0.125).animate(
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

      case ActionWidgetAnimation.fadeIn:
      case ActionWidgetAnimation.fadeOut:
        return FadeTransition(
          opacity: animationOpacity!,
          child: child,
        );
      case ActionWidgetAnimation.nothing:
        return SizedBox(child: child);
    }
  }
}
