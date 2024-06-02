import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:labcure/config/router/router.dart';
import 'package:labcure/config/styles/constants.dart';
import 'package:labcure/config/styles/shapes.dart';
import 'package:labcure/models/catalog.dart';
import 'package:labcure/models/group.dart';
import 'package:labcure/models/test.dart';
import 'package:labcure/services/hive_services.dart';
import 'package:labcure/widgets/delete_dialog.dart';
import 'package:labcure/widgets/test_dialog.dart';

class CatalogView extends StatefulWidget {
  const CatalogView({super.key, required this.uid});
  final String uid;

  @override
  State<CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends State<CatalogView> {
  late Map<String, Map<IconData, void Function()?>> items;
  late String label;

  @override
  void initState() {
    super.initState();
    items = {
      'Create Group': {Icons.add_rounded: group},
      'Delete All': {Icons.delete_rounded: delete}
    };
    label = Hiveservices.instance.catalogbox.get(widget.uid)!.label;
  }

  void group() {
    context.push('${Paths.catalogview.path}/${Paths.groupcreation.path}', extra: widget.uid);
  }

  void delete() {
    showAdaptiveDialog(
      context: context,
      builder: (context) => DeleteDialog(onAcepted: () {}, text: 'all tests in $label'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(CupertinoIcons.chevron_back),
          ),
          title: Text(label),
          actions: [
            PopupMenuButton(
              tooltip: '',
              itemBuilder: (context) => items.entries.map((item) {
                return PopupMenuItem(
                  onTap: item.value.values.first,
                  height: height / 1.2,
                  child: Row(
                    children: [Icon(item.value.keys.first), const Gap(padding), Text(item.key)],
                  ),
                );
              }).toList(),
            ),
            const Gap(gap),
            IconButton(
              onPressed: () => showAdaptiveDialog(
                context: context,
                builder: (context) => TestDialog(uid: widget.uid, index: null, test: null),
              ),
              icon: const Icon(CupertinoIcons.add),
            ),
            const Gap(padding),
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(kTextTabBarHeight),
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [Tab(text: 'Tests'), Tab(text: 'Groups')],
            ),
          ),
        ),
        body: ValueListenableBuilder(
          valueListenable: Hiveservices.instance.catalogbox.listenable(),
          builder: (context, box, _) {
            Catalog catalog = box.get(widget.uid)!;
            return TabBarView(
              children: [_Tests(catalog: catalog), _Groups(catalog: catalog, onPressed: group)],
            );
          },
        ),
      ),
    );
  }
}

class _Tests extends StatefulWidget {
  const _Tests({required this.catalog});
  final Catalog catalog;

  @override
  State<_Tests> createState() => _TestsState();
}

class _TestsState extends State<_Tests> {
  bool visible = false;
  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    TextTheme texts = Theme.of(context).textTheme;
    final List<Test> tests = widget.catalog.tests!;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
        bottom: visible ? _AnimatedHeader(visible) : null,
        notificationPredicate: (notification) {
          if (notification.metrics.pixels > 144) {
            if (!visible) setState(() => visible = true);
          } else {
            if (visible) setState(() => visible = false);
          }
          return true;
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: padding),
        child: Column(
          children: [
            const Gap(40),
            Text(
              'There ${tests.length > 1 ? 'are' : 'is'} ${tests.length} ${tests.length > 1 ? 'tests' : 'test'} in the ${widget.catalog.label}',
              style: texts.displayMedium!.copyWith(color: colors.primary),
            ),
            const Gap(40),
            const _Header(),
            ...List.generate(tests.length, (index) {
              Test test = tests[index];
              return _Tile(
                onTap: () => showAdaptiveDialog(
                  useRootNavigator: false,
                  context: context,
                  builder: (context) => TestDialog(uid: widget.catalog.uid, index: index, test: test),
                ),
                test: test,
              );
            }),
            const Gap(40),
          ],
        ),
      ),
    );
  }
}

class _Groups extends StatelessWidget {
  const _Groups({required this.catalog, this.onPressed});
  final Catalog catalog;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    TextTheme texts = Theme.of(context).textTheme;
    List<Group> groups = catalog.groups!;
    return Visibility(
      visible: groups.isNotEmpty,
      replacement: Align(
        alignment: Alignment.center,
        child: TextButton(
          onPressed: onPressed,
          child: const Text('Create Group'),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: padding),
        child: Center(
          child: Column(
            children: [
              const Gap(40),
              Text(
                'There ${groups.length > 1 ? 'are' : 'is'} ${catalog.groups!.length} ${groups.length > 1 ? 'groups' : 'group'} in the ${catalog.label}',
                style: texts.displayMedium!.copyWith(color: colors.primary),
              ),
              const Gap(40),
              ...List.generate(groups.length, (index) {
                Group group = catalog.groups![index];
                return ListTile(title: Text(group.label));
              }),
              const Gap(40),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedHeader extends StatefulWidget implements PreferredSizeWidget {
  const _AnimatedHeader(this.visible);
  final bool visible;

  @override
  State<_AnimatedHeader> createState() => _AnimatedHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight);
}

class _AnimatedHeaderState extends State<_AnimatedHeader> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<Offset> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);

    animation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.ease));

    if (widget.visible) controller.forward();
  }

  @override
  void didUpdateWidget(_AnimatedHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation,
      child: const Padding(padding: EdgeInsets.symmetric(horizontal: padding), child: _Header()),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    TextTheme texts = Theme.of(context).textTheme;
    return ListTile(
      leading: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(width: 60),
        child: const Text('ID'),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(child: Text('Label')),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 60),
            child: const Text('Rate', textAlign: TextAlign.center),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 60),
            child: const Text('Upper', textAlign: TextAlign.center),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 60),
            child: const Text('Lower', textAlign: TextAlign.center),
          ),
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 100),
              child: const Text('Unit', textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
      leadingAndTrailingTextStyle: texts.titleMedium,
      titleTextStyle: texts.titleMedium,
      horizontalTitleGap: padding * 2,
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({this.onTap, required this.test});
  final void Function()? onTap;
  final Test test;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(width: 60),
        child: Text(test.id),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(test.label)),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 60),
            child: Text(test.rate, textAlign: TextAlign.center),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 60),
            child: const Text('', textAlign: TextAlign.center),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 60),
            child: const Text('', textAlign: TextAlign.center),
          ),
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 100),
              child: Text(test.unit, textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
      horizontalTitleGap: padding * 2,
      shape: Shapes.rec,
    );
  }
}
