import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:labcure/config/styles/borders.dart';
import 'package:labcure/config/styles/constants.dart';
import 'package:labcure/models/catalog.dart';
import 'package:labcure/models/test.dart';
import 'package:labcure/services/hive_services.dart';

class Initialize extends StatefulWidget {
  const Initialize({super.key, required this.tests});
  final List<Test> tests;

  @override
  State<Initialize> createState() => _InitializeState();
}

class _InitializeState extends State<Initialize> {
  FocusNode focusNode = FocusNode();
  TextEditingController controller = TextEditingController();
  bool inbox = false;

  Iterable<Test> filter(Box<Catalog> box) {
    String query = controller.text.toLowerCase();
    if (query.trim().isEmpty) return box.values.expand((c) => c.tests!);

    return box.values.expand(
      (c) => c.tests!.where((t) => t.id.toLowerCase().contains(query) || t.label.toLowerCase().contains(query)),
    );
  }

  void find(String id, Box<Catalog> box) {
    if (id.isEmpty) return;

    for (Catalog catalog in box.values) {
      for (Test test in catalog.tests!) {
        if (test.id.toLowerCase() == id.toLowerCase() && widget.tests.every((t) => t.id != test.id)) {
          setState(() => widget.tests.add(test));
          controller.clear();
          FocusScope.of(context).requestFocus(focusNode);
          return;
        }
      }
    }
    controller.clear();
    FocusScope.of(context).requestFocus(focusNode);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      constraints: const BoxConstraints(maxHeight: 417), // The same height for container in the patient view page
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: colors.surfaceContainer.withOpacity(0.5), borderRadius: Borders.borderRadius),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(gap),
            child: SearchBar(
              focusNode: focusNode,
              controller: controller,
              onChanged: (_) => setState(() {}),
              hintText: 'ID',
              onSubmitted: (id) => find(id, Hiveservices.instance.catalogbox),
              trailing: [
                CupertinoButton(
                  onPressed: () => setState(() => inbox = !inbox),
                  padding: const EdgeInsets.only(right: gap),
                  minSize: 0,
                  child: Visibility(
                    visible: !inbox,
                    replacement: Icon(Icons.inbox_rounded, color: colors.primary),
                    child: Icon(Icons.inbox_rounded, color: colors.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Material(
              color: Colors.transparent,
              child: Visibility(
                visible: inbox,
                replacement: Visibility(
                  visible: widget.tests.isNotEmpty,
                  replacement: DefaultTextStyle(
                    style: textTheme.bodySmall!.copyWith(color: colors.onSurfaceVariant.withOpacity(0.5)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Start adding by entering ID for each test.'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Click '),
                            Icon(Icons.inbox_rounded, size: 16, color: colors.onSurfaceVariant.withOpacity(0.5)),
                            const Text(' to see all the tests.')
                          ],
                        ),
                        const Gap(44),
                      ],
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: widget.tests.length,
                    itemBuilder: (context, index) {
                      Test test = widget.tests[index];
                      return _TestTile(
                        test: test,
                        onTap: () => setState(() => widget.tests.remove(test)),
                        trailing: const Icon(Icons.delete_rounded),
                      );
                    },
                  ),
                ),
                child: ValueListenableBuilder(
                  valueListenable: Hiveservices.instance.catalogbox.listenable(),
                  builder: (context, box, _) {
                    return ListView.builder(
                      itemCount: filter(box).length,
                      itemBuilder: (context, index) {
                        Test test = filter(box).elementAt(index);
                        return _TestTile(
                          test: test,
                          onTap: () {
                            if (widget.tests.every((t) => t.id != test.id)) widget.tests.add(test);
                          },
                          trailing: const Icon(Icons.add_rounded),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TestTile extends StatefulWidget {
  const _TestTile({required this.test, this.trailing, this.onTap});
  final Test test;
  final Widget? trailing;
  final void Function()? onTap;

  @override
  State<_TestTile> createState() => _TestTileState();
}

class _TestTileState extends State<_TestTile> {
  bool hovering = false;
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle? style = textTheme.labelSmall;

    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: ListTile(
        onTap: widget.onTap,
        leading: Text(widget.test.id),
        title: Text(widget.test.label),
        leadingAndTrailingTextStyle: style,
        titleTextStyle: style,
        trailing: hovering ? widget.trailing : null,
      ),
    );
  }
}



/*


class Initialize extends StatefulWidget {
  const Initialize({super.key, required this.tests});
  final List<Test> tests;

  @override
  State<Initialize> createState() => _InitializeState();
}

class _InitializeState extends State<Initialize> {
  FocusNode focusNode = FocusNode();
  TextEditingController controller = TextEditingController();
  bool inbox = false;
  int? inboxHovered;
  int? hovered;
  List<Test> tests = List.generate(20, (index) {
    return Test(id: '$index', label: 'Test $index', rate: '${index * 4}', unit: 'mg/dl', result: '');
  });

  Iterable<Test> filter(List<Test> tests) {
    String query = controller.text.toLowerCase();
    if (query.trim().isEmpty) return tests;
    return tests.where((t) => t.id.contains(query) || t.label.toLowerCase().contains(query));
  }

  void find(String id) {
    if (id.isEmpty) return;
    for (Test t in tests) {
      if (t.id == id && !widget.tests.contains(t)) {
        setState(() => widget.tests.add(t));
        break;
      }
    }
    controller.clear();
    FocusScope.of(context).requestFocus(focusNode);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    TextStyle? style = textTheme.bodySmall!.copyWith(fontSize: 8, fontWeight: FontWeight.w400);

    return Container(
      height: size.height / 1.8,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: colorScheme.secondaryContainer.withOpacity(0.2), borderRadius: Borders.borderRadius),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(gap),
            child: Searchbar(
              focusNode: focusNode,
              controller: controller,
              onChanged: (_) => setState(() {}),
              onSubmitted: find,
              onSuffix: () => setState(() => inbox = !inbox),
              isSuffix: inbox,
            ),
          ),
          Flexible(
            child: Material(
              color: Colors.transparent,
              child: Visibility(
                visible: inbox,
                replacement: Visibility(
                  visible: widget.tests.isNotEmpty,
                  replacement: DefaultTextStyle(
                    style: textTheme.bodySmall!.copyWith(color: colorScheme.surfaceVariant),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Start adding by entering ID for each test.'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Click '),
                            Icon(Icons.inbox_rounded, size: 16, color: colorScheme.surfaceVariant),
                            const Text(' to see all the tests.')
                          ],
                        ),
                        const Gap(44),
                      ],
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: widget.tests.length,
                    itemBuilder: (context, index) {
                      Test test = widget.tests[index];
                      return MouseRegion(
                        onEnter: (_) => setState(() => hovered = index),
                        onExit: (_) => setState(() => hovered = null),
                        child: ListTile(
                          onTap: () => setState(() => widget.tests.remove(test)),
                          title: Text(test.label),
                          titleTextStyle: style,
                          trailing: index == hovered ? const Icon(Icons.delete_rounded, size: iconSize) : null,
                        ),
                      );
                    },
                  ),
                ),
                child: ListView.builder(
                  itemCount: filter(tests).length,
                  itemBuilder: (context, index) {
                    Test test = filter(tests).elementAt(index);
                    return MouseRegion(
                      onEnter: (_) => setState(() => inboxHovered = index),
                      onExit: (_) => setState(() => inboxHovered = null),
                      child: ListTile(
                        onTap: () {
                          if (!widget.tests.contains(test)) widget.tests.add(test);
                        },
                        leading: Text(test.id),
                        title: Text(test.label),
                        leadingAndTrailingTextStyle: style,
                        titleTextStyle: style,
                        trailing: inboxHovered == index ? const Icon(Icons.add_rounded, size: iconSize) : null,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



 */