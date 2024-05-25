import 'package:flutter/material.dart';
import 'package:labcure/config/styles/shapes.dart';

class StepButton extends StatelessWidget {
  const StepButton({
    super.key,
    this.onPressed,
    required this.child,
    this.active = false,
  });
  final void Function()? onPressed;
  final Widget child;
  final bool active;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return MaterialButton(
      onPressed: onPressed,
      height: double.maxFinite,
      minWidth: double.maxFinite,
      shape: Shapes.rec,
      color: active ? colorScheme.secondaryContainer : null,
      child: DefaultTextStyle(
        style: textTheme.labelMedium!,
        child: child,
      ),
    );
  }
}
