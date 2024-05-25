import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:labcure/config/router/router.dart';
import 'package:labcure/config/styles/borders.dart';
import 'package:labcure/config/styles/constants.dart';
import 'package:labcure/models/catalog.dart';
import 'package:labcure/services/hive_services.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    search.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    search.removeListener(() {});
  }

  Iterable<Catalog> filter(Box<Catalog> box) {
    String query = search.text.toLowerCase();
    if (query.trim().isEmpty) return box.values;

    bool make(String value) => value.toLowerCase().contains(query);
    return box.values.where((c) => make(c.label) || c.tests!.any((t) => make(t.id) || make(t.label)));
    // return box.values.where((c) => make(c.label));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    IconThemeData iconTheme = Theme.of(context).iconTheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        actionsIconTheme: iconTheme.copyWith(size: 20.0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Catalogs'),
            SearchBar(
              controller: search,
              onChanged: (_) => setState(() {}),
              constraints: const BoxConstraints.tightFor(width: 300, height: height),
              hintText: 'Search',
              trailing: [
                Visibility(
                  visible: search.text.isNotEmpty,
                  child: CupertinoButton(
                    onPressed: () => setState(() => search.clear()),
                    minSize: 0,
                    padding: EdgeInsets.zero,
                    child: Icon(CupertinoIcons.clear, size: iconTheme.size, color: iconTheme.color),
                  ),
                ),
                const Gap(gap),
              ],
            ),
            const SizedBox.shrink(),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.add)),
          const Gap(padding),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hiveservices.instance.catalogbox.listenable(),
        builder: (context, box, _) {
          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: size.width > 1024 ? 1024 : size.width),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(padding),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 260,
                    mainAxisSpacing: gap,
                    crossAxisSpacing: gap,
                  ),
                  itemCount: filter(box).length,
                  itemBuilder: (context, index) {
                    Catalog c = filter(box).elementAt(index);
                    return _CatalogTile(catalog: c);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CatalogTile extends StatefulWidget {
  const _CatalogTile({required this.catalog});
  final Catalog catalog;

  @override
  State<_CatalogTile> createState() => _CatalogTileState();
}

class _CatalogTileState extends State<_CatalogTile> {
  bool hovering = false;
  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    TextTheme texts = Theme.of(context).textTheme;
    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: GestureDetector(
        onTap: () => context.push(RoutePath.catalogview.path, extra: widget.catalog),
        child: AnimatedContainer(
          duration: Durations.medium1,
          decoration: BoxDecoration(
            color: colors.surfaceContainer.withOpacity(hovering ? 1 : 0.5),
            borderRadius: Borders.borderRadius,
            border: hovering ? Border.all(color: colors.primary) : null,
          ),
          alignment: Alignment.center,
          child: Text(widget.catalog.label, style: texts.labelMedium),
        ),
      ),
    );
  }
}


/*


Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: List.generate(box.length, (index) {
                    Catalog c = box.getAt(index)!;
                    return Container(
                      constraints: const BoxConstraints.expand(width: 260, height: 260),
                      decoration: BoxDecoration(
                        color: colors.surfaceContainer.withOpacity(0.5),
                        borderRadius: Borders.borderRadius,
                      ),
                      alignment: Alignment.center,
                      child: Text(c.label, style: texts.labelMedium),
                    );
                  }),
                ),

GridView.builder(
                padding: const EdgeInsets.all(padding),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 260,
                  mainAxisSpacing: gap,
                  crossAxisSpacing: gap,
                ),
                itemCount: box.length,
                itemBuilder: (context, index) {
                  Catalog c = box.getAt(index)!;
                  return Container(
                    decoration: BoxDecoration(
                      color: colors.surfaceContainer.withOpacity(0.5),
                      borderRadius: Borders.borderRadius,
                    ),
                    alignment: Alignment.center,
                    child: Text(c.label, style: texts.labelMedium),
                  );
                },
              ),

 */