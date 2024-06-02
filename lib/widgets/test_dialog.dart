import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:labcure/config/styles/constants.dart';
import 'package:labcure/functions/hive_functions.dart';
import 'package:labcure/models/test.dart';

class TestDialog extends StatefulWidget {
  const TestDialog({super.key, required this.uid, this.index, this.test});

  final String uid;
  final int? index;
  final Test? test;

  @override
  State<TestDialog> createState() => _TestDialogState();
}

class _TestDialogState extends State<TestDialog> {
  late List<FocusNode> focusNodes;
  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(4, (index) => FocusNode());
    controllers = List.generate(4, (index) => TextEditingController());
    init();
  }

  void init() {
    if (widget.test != null) {
      controllers[0].text = widget.test!.id;
      controllers[1].text = widget.test!.label;
      controllers[2].text = widget.test!.rate;
      controllers[3].text = widget.test!.unit;
    }
  }

  void submit() {
    bool filled = true;
    filled = control(filled: filled);

    if (filled) {
      HiveFunctions().submitTest(
        uid: widget.uid,
        test: Test(
          id: controllers[0].text.trim(),
          label: controllers[1].text.trim(),
          rate: controllers[2].text.trim(),
          unit: controllers[3].text.trim(),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  void update() {
    bool filled = true;
    filled = control(filled: filled);

    if (filled) {
      HiveFunctions().updateTest(
        uid: widget.uid,
        index: widget.index!,
        id: controllers[0].text.trim(),
        label: controllers[1].text.trim(),
        rate: controllers[2].text.trim(),
        unit: controllers[3].text.trim(),
      );
      Navigator.of(context).pop();
    }
  }

  bool control({required bool filled}) {
    if (controllers[0].text.isEmpty) {
      filled = false;
      FocusScope.of(context).requestFocus(focusNodes[0]);
    }
    if (controllers[1].text.isEmpty) {
      filled = false;
      FocusScope.of(context).requestFocus(focusNodes[1]);
    }

    return filled;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    TextTheme texts = Theme.of(context).textTheme;
    ColorScheme colors = Theme.of(context).colorScheme;

    return SimpleDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      title: ConstrainedBox(
        constraints: BoxConstraints(minWidth: size.width > 540 ? 540 : 480),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Text(widget.test != null ? widget.test!.label : 'Create Test'),
          titleSpacing: padding * 1.4,
          actions: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(CupertinoIcons.clear, size: 20),
            ),
            const Gap(padding),
          ],
        ),
      ),
      children: [
        const Gap(40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding),
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  focusNode: focusNodes[0],
                  controller: controllers[0],
                  style: texts.bodySmall,
                  decoration: const InputDecoration(labelText: 'ID'),
                ),
              ),
              const Gap(gap),
              Flexible(
                child: TextField(
                  focusNode: focusNodes[1],
                  controller: controllers[1],
                  style: texts.bodySmall,
                  decoration: const InputDecoration(labelText: 'Label'),
                ),
              ),
            ],
          ),
        ),
        const Gap(padding),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding),
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  focusNode: focusNodes[2],
                  controller: controllers[2],
                  style: texts.bodySmall,
                  decoration: const InputDecoration(labelText: 'Rate'),
                ),
              ),
              const Gap(gap),
              Flexible(
                child: TextField(
                  focusNode: focusNodes[3],
                  controller: controllers[3],
                  style: texts.bodySmall,
                  decoration: const InputDecoration(labelText: 'Unit'),
                ),
              ),
            ],
          ),
        ),
        const Gap(40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding * 1.2),
          child: Text(
            'OPTIMAL RANGES',
            style: texts.labelMedium!.copyWith(color: colors.onSurfaceVariant.withOpacity(0.5)),
          ),
        ),
        const Gap(gap),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding),
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  style: texts.bodySmall,
                  decoration: const InputDecoration(labelText: 'Upper'),
                ),
              ),
              const Gap(gap),
              Flexible(
                child: TextField(
                  style: texts.bodySmall,
                  decoration: const InputDecoration(labelText: 'Lower'),
                ),
              ),
            ],
          ),
        ),
        const Gap(40),
        const Divider(),
        const Gap(padding),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton.tonal(
                onPressed: () => Navigator.of(context).pop(),
                style: const ButtonStyle(fixedSize: WidgetStatePropertyAll(Size.fromHeight(height / 1.2))),
                child: const Text('Cancel'),
              ),
              const Gap(gap),
              FilledButton(
                onPressed: widget.index != null ? update : submit,
                style: const ButtonStyle(fixedSize: WidgetStatePropertyAll(Size.fromHeight(height / 1.2))),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
        const Gap(padding),
      ],
    );
  }
}
