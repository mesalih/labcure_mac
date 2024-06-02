import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:labcure/config/styles/borders.dart';
import 'package:labcure/config/styles/constants.dart';
import 'package:labcure/config/styles/shapes.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({super.key, required this.onAcepted, required this.text});
  final void Function()? onAcepted;
  final String text;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ColorScheme colors = Theme.of(context).colorScheme;
    return AlertDialog(
      backgroundColor: colors.surfaceContainer,
      shape: Shapes.rec,
      contentPadding: EdgeInsets.zero,
      titlePadding: const EdgeInsets.symmetric(vertical: padding * 1.2),
      title: const Icon(Icons.delete_rounded),
      content: ConstrainedBox(
        constraints: BoxConstraints(minWidth: size.width / 2.80),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(),
            const Gap(padding * 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: padding),
              child: Text('This will delete $text'),
            ),
            const Gap(padding * 2),
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            Flexible(
              child: FilledButton.tonal(
                onPressed: () => Navigator.of(context).pop(),
                style: ButtonStyle(
                  minimumSize: const WidgetStatePropertyAll(Size.fromHeight(56)),
                  shape: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.focused)) {
                      return RoundedRectangleBorder(
                        side: BorderSide(color: colors.inverseSurface, width: 2),
                        borderRadius: Borders.borderRadius,
                      );
                    }
                    return null;
                  }),
                ),
                child: const Text('Cancel'),
              ),
            ),
            const Gap(gap),
            Flexible(
              child: FilledButton(
                onPressed: () {
                  onAcepted!.call();
                  Navigator.of(context).pop();
                },
                autofocus: true,
                style: ButtonStyle(
                  backgroundColor: const WidgetStatePropertyAll(Colors.red),
                  minimumSize: const WidgetStatePropertyAll(Size.fromHeight(56)),
                  shape: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.focused)) {
                      return RoundedRectangleBorder(
                        side: BorderSide(color: colors.inverseSurface, width: 2),
                        borderRadius: Borders.borderRadius,
                      );
                    }
                    return null;
                  }),
                ),
                child: const Text('Delete'),
              ),
            ),
          ],
        )
      ],
    );
  }
}
