import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../extensions.dart';

class SlideBottomWidget extends HookWidget {
  final Widget child;
  final bool doForward;
  const SlideBottomWidget({@required this.child, @required this.doForward});
  @override
  Widget build(BuildContext context) {
    final controller =
        useAnimationController(duration: const Duration(milliseconds: 500));
    useValueChanged<bool, void>(doForward, (oldValue, newValue) {
      if (!oldValue)
        controller.forward();
      else
        controller.reverse();
    });
    return child.toSlideAnimation(controller);
  }
}
