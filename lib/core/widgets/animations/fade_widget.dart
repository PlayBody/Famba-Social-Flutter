import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../extensions.dart';

class CustomAnimatedWidget extends HookWidget {
  final Widget child;

  const CustomAnimatedWidget({this.child});
  @override
  Widget build(BuildContext context) {
    final controller =
        useAnimationController(duration: const Duration(milliseconds: 800))
          ..forward();
    return child.toSlideAnimation(controller);
  }
}
