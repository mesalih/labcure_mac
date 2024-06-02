import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:labcure/config/styles/borders.dart';
import 'package:labcure/config/styles/constants.dart';
import 'package:labcure/config/styles/shapes.dart';
import 'package:labcure/functions/hive_functions.dart';
import 'package:labcure/models/catalog.dart';
import 'package:labcure/models/test.dart';
import 'package:labcure/services/hive_services.dart';

class GroupCreation extends StatefulWidget {
  const GroupCreation({super.key, required this.uid});
  final String uid;

  @override
  State<GroupCreation> createState() => _GroupCreationState();
}

class _GroupCreationState extends State<GroupCreation> {
  late List<FocusNode> focusNodes;
  late List<TextEditingController> controllers;
  late FocusNode searchFocusNode;
  late TextEditingController searchController;

  late List<Test> tests = [];

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(2, (_) => FocusNode());
    controllers = List.generate(2, (_) => TextEditingController());
    searchFocusNode = FocusNode();
    searchController = TextEditingController();
  }

  void addTest(Test t) {
    if (tests.contains(t)) return;
    setState(() => tests.add(t));
  }

  void removeTest(Test t) => setState(() => tests.remove(t));

  void submit() {
    bool filled = true;
    filled = control(filled: filled);

    if (filled) {
      HiveFunctions().submitGroup(
        uid: widget.uid,
        id: controllers[0].text.trim(),
        label: controllers[1].text.trim(),
        tests: tests,
      );
      context.pop();
    }
  }

  bool control({required bool filled}) {
    for (int i = 0; i < controllers.length; i++) {
      if (controllers[i].text.trim().isEmpty) {
        filled = false;
        FocusScope.of(context).requestFocus(focusNodes[i]);
        return false;
      }
    }

    if (tests.length < 2) {
      filled = false;
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text('There has to be a least 2 tests in the test box!'),
            showCloseIcon: true,
            padding: const EdgeInsets.all(padding),
            margin: const EdgeInsets.all(padding * 2),
            shape: Shapes.rec,
            behavior: SnackBarBehavior.floating,
          ),
        );
      return false;
    }

    return filled;
  }

  void find(String id, Catalog catalog) {
    if (id.isEmpty) return;

    for (Test test in catalog.tests!) {
      if (test.id.toLowerCase() == id.toLowerCase() && tests.every((t) => t.id != test.id)) {
        setState(() => tests.add(test));
        searchController.clear();
        FocusScope.of(context).requestFocus(searchFocusNode);
        return;
      }
    }
    searchController.clear();
    FocusScope.of(context).requestFocus(searchFocusNode);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    ColorScheme colors = Theme.of(context).colorScheme;
    TextTheme texts = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Create Group'),
        actions: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(CupertinoIcons.clear),
          ),
          const Gap(padding),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hiveservices.instance.catalogbox.listenable(),
        builder: (context, box, _) {
          Catalog catalog = box.get(widget.uid)!;
          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: size.width / 2.2, minHeight: size.height - toolbarHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(40),
                    Row(
                      children: [
                        Flexible(
                          child: TextField(
                            focusNode: focusNodes[0],
                            controller: controllers[0],
                            decoration: const InputDecoration(labelText: 'Group ID'),
                          ),
                        ),
                        const Gap(gap),
                        Flexible(
                          child: TextField(
                            focusNode: focusNodes[1],
                            controller: controllers[1],
                            decoration: const InputDecoration(labelText: 'Group Label'),
                          ),
                        ),
                      ],
                    ),
                    const Gap(padding * 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: padding * 0.6),
                      child: Text(
                        'GROUP BOX',
                        style: texts.labelMedium!.copyWith(color: colors.onSurfaceVariant.withOpacity(0.5)),
                      ),
                    ),
                    const Gap(gap),
                    Container(
                      clipBehavior: Clip.antiAlias,
                      constraints: const BoxConstraints.tightFor(height: 180, width: double.maxFinite),
                      decoration: BoxDecoration(
                        border: Border.all(color: colors.outlineVariant),
                        borderRadius: Borders.borderRadius,
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(padding),
                        child: Wrap(
                          spacing: gap,
                          runSpacing: gap,
                          children: List.generate(tests.length, (index) {
                            Test t = tests[index];
                            return FilledButton.tonal(
                              onPressed: () => removeTest(t),
                              style: const ButtonStyle(
                                padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: padding)),
                              ),
                              child: Text(t.label),
                            );
                          }),
                        ),
                      ),
                    ),
                    const Gap(padding * 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: padding * 0.6),
                      child: Text(
                        'TESTS IN ${catalog.label.toUpperCase()}',
                        style: texts.labelMedium!.copyWith(color: colors.onSurfaceVariant.withOpacity(0.5)),
                      ),
                    ),
                    const Gap(gap),
                    Container(
                      constraints: BoxConstraints.tightFor(height: size.height / 2.2),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: colors.surfaceContainer.withOpacity(0.5),
                        borderRadius: Borders.borderRadius,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(gap),
                            child: SearchBar(
                              focusNode: searchFocusNode,
                              controller: searchController,
                              onChanged: (_) => setState(() {}),
                              hintText: 'ID',
                              onSubmitted: (id) => find(id, catalog),
                            ),
                          ),
                          Flexible(
                            child: Material(
                              color: Colors.transparent,
                              child: ListView.builder(
                                itemCount: catalog.tests!.length,
                                itemBuilder: (context, index) {
                                  Test t = catalog.tests![index];
                                  return _TestTile(
                                    onTap: () => addTest(t),
                                    test: t,
                                    trailing: const Icon(Icons.add_rounded),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(padding),
                    FilledButton(
                      onPressed: submit,
                      style: const ButtonStyle(
                        minimumSize: WidgetStatePropertyAll(Size.fromHeight(height)),
                      ),
                      child: const Text('Submit'),
                    ),
                    const Gap(40),
                  ],
                ),
              ),
            ),
          );
        },
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
