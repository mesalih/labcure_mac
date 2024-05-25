import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Replacement extends StatelessWidget {
  const Replacement({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Material(
      child: DefaultTextStyle(
        style: textTheme.bodySmall!.copyWith(color: colors.onSurfaceVariant.withOpacity(0.5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Select a patient.'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Press '),
                Icon(CupertinoIcons.add, size: 14, color: colors.onSurfaceVariant.withOpacity(0.5)),
                const Text(' to add a new patient.')
              ],
            )
          ],
        ),
      ),
    );
  }
}
