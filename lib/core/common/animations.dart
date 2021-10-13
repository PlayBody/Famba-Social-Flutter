import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ScrollControllerForAnimationHook extends Hook<NotificationListener> {
  final AnimationController animationController;
  final Widget child;
  const ScrollControllerForAnimationHook({
    @required this.animationController,
    @required this.child,
  });

  @override
  _ScrollControllerForAnimationHookState createState() =>
      _ScrollControllerForAnimationHookState(child);
}

class _ScrollControllerForAnimationHookState
    extends HookState<NotificationListener, ScrollControllerForAnimationHook> {
  ScrollController _scrollController;
  final Widget child;

  _ScrollControllerForAnimationHookState(this.child);
  @override
  void initHook() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      switch (_scrollController.position.userScrollDirection) {
        case ScrollDirection.forward:
          // State has the "widget" property
          // HookState has the "hook" property
          print("forward");
          hook.animationController.forward();
          break;
        case ScrollDirection.reverse:
          print("reverse");
          hook.animationController.forward();
          break;
        case ScrollDirection.idle:
          print("hide");
          hook.animationController.reverse();
          break;
      }
    });
  }

  // Build doesn't return a Widget but rather the ScrollController
  @override
  NotificationListener build(BuildContext context) =>
      NotificationListener<UserScrollNotification>(
          onNotification: (value) {
            switch (value.direction) {
              case ScrollDirection.forward:
                // State has the "widget" property
                // HookState has the "hook" property
                //   print("forward");
                hook.animationController.reverse();
                break;
              case ScrollDirection.reverse:
                // print("reverse");
                hook.animationController.reverse();
                break;
              case ScrollDirection.idle:
                // print("hide");
                hook.animationController.forward();
                break;
            }
            return true;
          },
          child: child);

  // This is what we came here for
  @override
  void dispose() => _scrollController.dispose();
}

NotificationListener useScrollControllerForAnimation(
  Widget child,
  AnimationController animationController,
) =>
    use(ScrollControllerForAnimationHook(
      child: child,
      animationController: animationController,
    ));
