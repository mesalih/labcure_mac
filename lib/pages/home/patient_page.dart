import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:labcure/config/router/router.dart';
import 'package:labcure/config/styles/constants.dart';
import 'package:labcure/pages/home/patients.dart';

class PatientPage extends StatefulWidget {
  const PatientPage({super.key, required this.child});
  final Widget child;

  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  late TextEditingController search;
  int? selected;
  late List<String> items;

  @override
  void initState() {
    super.initState();
    search = TextEditingController();
    search.addListener(() => setState(() {}));
    items = ['Postpone', 'Urgent', 'Complate'];
  }

  @override
  Widget build(BuildContext context) {
    IconThemeData iconTheme = Theme.of(context).iconTheme;
    return Scaffold(
      body: Row(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: 300),
            child: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: kToolbarHeight + padding + height),
                  child: AppBar(
                    centerTitle: false,
                    forceMaterialTransparency: true,
                    title: const Text('Patients'),
                    actions: [
                      PopupMenuButton(
                        tooltip: '',
                        icon: const Icon(CupertinoIcons.square_fill_line_vertical_square_fill),
                        itemBuilder: (context) => items.map((item) {
                          return PopupMenuItem(
                            onTap: () => search.text = item,
                            height: height / 1.2,
                            child: Text(item),
                          );
                        }).toList(),
                      ),
                      const Gap(gap),
                      IconButton(
                        onPressed: () {
                          if (GoRouterState.of(context).uri.path != RoutePath.patientcreation.path) {
                            context.push(RoutePath.patientcreation.path);
                          }
                        },
                        icon: const Icon(CupertinoIcons.add),
                      ),
                      const Gap(padding),
                    ],
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(kTextTabBarHeight),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: padding),
                        child: SearchBar(
                          controller: search,
                          hintText: 'Search',
                          onChanged: (_) => setState(() {}),
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
                      ),
                    ),
                  ),
                ),
                const Gap(padding),
                Flexible(child: Patients(query: search.text)),
              ],
            ),
          ),
          const VerticalDivider(),
          Expanded(flex: 2, child: widget.child)
        ],
      ),
    );
  }
}
