import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:labcure/config/router/router.dart';
import 'package:labcure/config/styles/borders.dart';
import 'package:labcure/config/styles/constants.dart';
import 'package:labcure/functions/hive_functions.dart';
import 'package:labcure/models/patient.dart';
import 'package:labcure/models/test.dart';
import 'package:labcure/services/document_services.dart';
import 'package:labcure/services/hive_services.dart';
import 'package:labcure/widgets/delete_dialog.dart';

class PatientView extends StatefulWidget {
  const PatientView({super.key, required this.uid});
  final String uid;

  @override
  State<PatientView> createState() => _PatientViewState();
}

class _PatientViewState extends State<PatientView> {
  void setting(Patient patient) => Hiveservices.instance.patientbox.put(patient.uid, patient);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    ColorScheme colors = Theme.of(context).colorScheme;
    TextTheme texts = Theme.of(context).textTheme;

    return ValueListenableBuilder(
        valueListenable: Hiveservices.instance.patientbox.listenable(),
        builder: (context, box, _) {
          Patient patient = box.get(widget.uid)!;
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: Text('${patient.title} ${patient.name}'),
              actions: [
                IconButton(
                  onPressed: () => context.push(RoutePath.patientedit.path, extra: patient),
                  icon: const Icon(Icons.edit_rounded),
                ),
                const Gap(gap),
                IconButton(
                  onPressed: () {
                    DateFormat formatter = DateFormat('dd MMM yyyy - hh:mm a');
                    patient.reportDate = formatter.format(DateTime.now());
                    Hiveservices.instance.patientbox.put(patient.uid, patient);
                    DocumentServices.create(patient: patient);
                  },
                  icon: const Icon(Icons.print_rounded),
                ),
                const Gap(padding)
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: padding),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: size.width / 2.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TestBox(patient: patient, colors: colors, textTheme: texts),
                      const Gap(40),
                      CupertinoListSection.insetGrouped(
                        backgroundColor: Colors.transparent,
                        margin: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: colors.surfaceContainer.withOpacity(0.5),
                          borderRadius: Borders.borderRadius,
                        ),
                        header: Text(
                          'Status',
                          style: texts.labelMedium!.copyWith(color: colors.onSurfaceVariant.withOpacity(0.5)),
                        ),
                        children: [
                          CupertinoListTile(
                            onTap: () => setState(() {
                              patient.postpone = !patient.postpone;
                              if (patient.tested) patient.tested = !patient.tested;
                              setting(patient);
                            }),
                            title: Text('Postpone', style: texts.labelSmall),
                            trailing: Visibility(
                              visible: patient.postpone,
                              replacement: const Icon(CupertinoIcons.square),
                              child: Icon(CupertinoIcons.checkmark_square_fill, color: colors.primary),
                            ),
                          ),
                          CupertinoListTile(
                            onTap: () => setState(() {
                              patient.urgent = !patient.urgent;
                              setting(patient);
                            }),
                            title: Text('Urgent', style: texts.labelSmall),
                            trailing: Visibility(
                              visible: patient.urgent,
                              replacement: const Icon(CupertinoIcons.square),
                              child: Icon(CupertinoIcons.checkmark_square_fill, color: colors.primary),
                            ),
                          ),
                          CupertinoListTile(
                            onTap: () => setState(() {
                              patient.tested = !patient.tested;
                              if (patient.postpone) patient.postpone = !patient.postpone;
                              setting(patient);
                              context.go(RoutePath.patientview.path, extra: null);
                            }),
                            title: Text('Complate', style: texts.labelSmall),
                            trailing: Visibility(
                              visible: patient.tested,
                              replacement: const Icon(CupertinoIcons.square),
                              child: Icon(CupertinoIcons.checkmark_square_fill, color: colors.primary),
                            ),
                          ),
                        ],
                      ),
                      const Gap(padding),
                      CupertinoListSection.insetGrouped(
                        backgroundColor: Colors.transparent,
                        margin: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: colors.surfaceContainer.withOpacity(0.5),
                          borderRadius: Borders.borderRadius,
                        ),
                        children: [
                          CupertinoListTile(
                            onTap: () => showDialog(
                              context: context,
                              builder: (context) {
                                return DeleteDialog(
                                  onAcepted: () => Hiveservices.instance.patientbox.delete(patient.uid).then(
                                        (_) => context.go(RoutePath.patientview.path),
                                      ),
                                  text: patient.name,
                                );
                              },
                            ),
                            title: Text('Delete', style: texts.labelSmall!.copyWith(color: CupertinoColors.systemRed)),
                          ),
                        ],
                      ),
                      const Gap(40),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class _TestPage {
  _TestPage({required this.tests});
  final List<Test> tests;
}

class _TestBox extends StatefulWidget {
  const _TestBox({required this.patient, required this.colors, required this.textTheme});
  final Patient patient;
  final ColorScheme colors;
  final TextTheme textTheme;

  @override
  State<_TestBox> createState() => _TestBoxState();
}

class _TestBoxState extends State<_TestBox> {
  Patient get patient => widget.patient;
  late List<_TestPage> pages;
  late PageController pageController;
  int pageIndex = 1;
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    initialize();
  }

  void initialize() {
    pageIndex = 1;
    List<Test> tests = patient.tests;
    int length = (tests.length / 8).ceil();
    pages = List.generate(length, (index) {
      int startIndex = index * 8;
      int endIndex = startIndex + 8;
      if (endIndex > tests.length) endIndex = tests.length;

      return _TestPage(tests: tests.sublist(startIndex, endIndex));
    });

    controllers = List.generate(patient.tests.length, (index) {
      final controller = TextEditingController();
      if (patient.tests[index].result != null) {
        controller.text = patient.tests[index].result!;
      }
      return controller;
    });

    focusNodes = List.generate(patient.tests.length, (index) => FocusNode());
  }

  @override
  void didUpdateWidget(_TestBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.patient != widget.patient) {
      initialize();
    }
  }

  void next() {
    pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear);
  }

  void back() {
    pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? style = Theme.of(context).listTileTheme.titleTextStyle;
    return Container(
      clipBehavior: Clip.antiAlias,
      constraints: const BoxConstraints(maxHeight: 320 + kTextTabBarHeight * 2 + 1),
      decoration: BoxDecoration(
        color: widget.colors.surfaceContainer.withOpacity(0.5),
        borderRadius: Borders.borderRadius,
      ),
      child: Column(
        children: [
          ListTile(
            titleTextStyle: widget.textTheme.labelMedium,
            leadingAndTrailingTextStyle: widget.textTheme.labelMedium,
            title: const Row(
              children: [
                Expanded(flex: 2, child: Text('Name')),
                Flexible(child: Align(alignment: Alignment.center, child: Text('Rate'))),
              ],
            ),
            trailing: ConstrainedBox(
              constraints: const BoxConstraints.tightFor(width: 100),
              child: const Align(alignment: Alignment.center, child: Text('Result')),
            ),
          ),
          const Divider(),
          Flexible(
            child: Material(
              color: Colors.transparent,
              child: PageView.builder(
                controller: pageController,
                itemCount: pages.length,
                onPageChanged: (page) => setState(() => pageIndex = page + 1),
                itemBuilder: (context, index) {
                  _TestPage page = pages[index];
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: page.tests.length,
                    itemBuilder: (context, idx) {
                      Test t = page.tests[idx];
                      int gindex = index * 8 + idx; // The global index

                      return ListTile(
                        onTap: () => focusNodes[gindex].requestFocus(),
                        titleTextStyle: style,
                        leadingAndTrailingTextStyle: style,
                        title: Row(
                          children: [
                            Expanded(flex: 2, child: Text(t.label, overflow: TextOverflow.ellipsis)),
                            Flexible(child: Align(alignment: Alignment.center, child: Text(t.rate))),
                          ],
                        ),
                        trailing: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 100),
                          child: Focus(
                            onFocusChange: (_) => HiveFunctions().submitResult(
                              uid: patient.uid,
                              test: t,
                              result: controllers[gindex].text,
                            ),
                            child: TextField(
                              focusNode: focusNodes[gindex],
                              controller: controllers[gindex],
                              style: style,
                              textAlign: TextAlign.center,
                              onTapOutside: (_) {
                                HiveFunctions().submitResult(
                                  uid: patient.uid,
                                  test: t,
                                  result: controllers[gindex].text,
                                );
                                focusNodes[gindex].unfocus();
                              },
                              onSubmitted: (result) {
                                HiveFunctions().submitResult(uid: patient.uid, test: t, result: result);
                                if (gindex != patient.tests.length - 1) {
                                  FocusScope.of(context).requestFocus(focusNodes[gindex + 1]);
                                }
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                constraints: const BoxConstraints.tightFor(height: 30),
                                border: const OutlineInputBorder(borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: widget.colors.primary)),
                              ),
                            ),
                          ),
                        ),
                        visualDensity: const VisualDensity(vertical: VisualDensity.minimumDensity),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          const Divider(),
          Container(
            constraints: const BoxConstraints(minHeight: kTextTabBarHeight),
            padding: const EdgeInsets.symmetric(horizontal: padding),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(onPressed: back, icon: const Icon(CupertinoIcons.chevron_back)),
                  const Gap(gap),
                  Container(
                    width: 40,
                    alignment: Alignment.center,
                    child: Text('$pageIndex - ${pages.length}', style: widget.textTheme.bodySmall),
                  ),
                  const Gap(gap),
                  IconButton(onPressed: next, icon: const Icon(CupertinoIcons.chevron_forward)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}


/*



class PatientView extends StatefulWidget {
  const PatientView({super.key, required this.patient});
  final Patient patient;

  @override
  State<PatientView> createState() => _PatientViewState();
}

class _PatientViewState extends State<PatientView> {
  void setting(Patient patient) => Hiveservices.instance.patientbox.put(patient.uid, patient);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    ColorScheme colors = Theme.of(context).colorScheme;
    TextTheme texts = Theme.of(context).textTheme;
    Patient patient = widget.patient;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('${widget.patient.title} ${widget.patient.name}'),
        actions: [
          IconButton(
            onPressed: () => context.push(RoutePath.patientedit.path, extra: patient),
            icon: const Icon(Icons.edit_rounded),
          ),
          const Gap(gap),
          IconButton(
            onPressed: () {
              DateFormat formatter = DateFormat('dd MMM yyyy - hh:mm a');
              patient.reportDate = formatter.format(DateTime.now());
              Hiveservices.instance.patientbox.put(patient.uid, patient);
              DocumentServices.create(patient: patient);
            },
            icon: const Icon(Icons.print_rounded),
          ),
          const Gap(padding)
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: padding),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width / 2.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TestBox(patient: widget.patient, colors: colors, textTheme: texts),
                const Gap(40),
                CupertinoListSection.insetGrouped(
                  backgroundColor: Colors.transparent,
                  margin: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: colors.surfaceContainer.withOpacity(0.5),
                    borderRadius: Borders.borderRadius,
                  ),
                  header: Text(
                    'Status',
                    style: texts.labelMedium!.copyWith(color: colors.onSurfaceVariant.withOpacity(0.5)),
                  ),
                  children: [
                    CupertinoListTile(
                      onTap: () => setState(() {
                        patient.postpone = !patient.postpone;
                        if (patient.tested) patient.tested = !patient.tested;
                        setting(patient);
                      }),
                      title: Text('Postpone', style: texts.labelSmall),
                      trailing: Visibility(
                        visible: patient.postpone,
                        replacement: const Icon(CupertinoIcons.square),
                        child: Icon(CupertinoIcons.checkmark_square_fill, color: colors.primary),
                      ),
                    ),
                    CupertinoListTile(
                      onTap: () => setState(() {
                        patient.urgent = !patient.urgent;
                        setting(patient);
                      }),
                      title: Text('Urgent', style: texts.labelSmall),
                      trailing: Visibility(
                        visible: patient.urgent,
                        replacement: const Icon(CupertinoIcons.square),
                        child: Icon(CupertinoIcons.checkmark_square_fill, color: colors.primary),
                      ),
                    ),
                    CupertinoListTile(
                      onTap: () => setState(() {
                        patient.tested = !patient.tested;
                        if (patient.postpone) patient.postpone = !patient.postpone;
                        setting(patient);
                        context.go(RoutePath.patientview.path, extra: null);
                      }),
                      title: Text('Complate', style: texts.labelSmall),
                      trailing: Visibility(
                        visible: patient.tested,
                        replacement: const Icon(CupertinoIcons.square),
                        child: Icon(CupertinoIcons.checkmark_square_fill, color: colors.primary),
                      ),
                    ),
                  ],
                ),
                const Gap(padding),
                CupertinoListSection.insetGrouped(
                  backgroundColor: Colors.transparent,
                  margin: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: colors.surfaceContainer.withOpacity(0.5),
                    borderRadius: Borders.borderRadius,
                  ),
                  children: [
                    CupertinoListTile(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) {
                          return DeleteDialog(
                            onAcepted: () => Hiveservices.instance.patientbox.delete(patient.uid).then(
                                  (_) => context.go(RoutePath.patientview.path),
                                ),
                            text: patient.name,
                          );
                        },
                      ),
                      title: Text('Delete', style: texts.labelSmall!.copyWith(color: CupertinoColors.systemRed)),
                    ),
                  ],
                ),
                const Gap(40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TestPage {
  _TestPage({required this.tests});
  final List<Test> tests;
}

class _TestBox extends StatefulWidget {
  const _TestBox({required this.patient, required this.colors, required this.textTheme});
  final Patient patient;
  final ColorScheme colors;
  final TextTheme textTheme;

  @override
  State<_TestBox> createState() => _TestBoxState();
}

class _TestBoxState extends State<_TestBox> {
  Patient get patient => widget.patient;
  late List<_TestPage> pages;
  late PageController pageController;
  int pageIndex = 1;
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    initialize();
  }

  void initialize() {
    pageIndex = 1;
    List<Test> tests = patient.tests;
    int length = (tests.length / 8).ceil();
    pages = List.generate(length, (index) {
      int startIndex = index * 8;
      int endIndex = startIndex + 8;
      if (endIndex > tests.length) endIndex = tests.length;

      return _TestPage(tests: tests.sublist(startIndex, endIndex));
    });

    controllers = List.generate(patient.tests.length, (index) {
      final controller = TextEditingController();
      if (patient.tests[index].result != null) {
        controller.text = patient.tests[index].result!;
      }
      return controller;
    });

    focusNodes = List.generate(patient.tests.length, (index) => FocusNode());
  }

  @override
  void didUpdateWidget(_TestBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.patient != widget.patient) {
      initialize();
    }
  }

  void next() {
    pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear);
  }

  void back() {
    pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? style = Theme.of(context).listTileTheme.titleTextStyle;
    return Container(
      clipBehavior: Clip.antiAlias,
      constraints: const BoxConstraints(maxHeight: 320 + kTextTabBarHeight * 2 + 1),
      decoration: BoxDecoration(
        color: widget.colors.surfaceContainer.withOpacity(0.5),
        borderRadius: Borders.borderRadius,
      ),
      child: Column(
        children: [
          ListTile(
            titleTextStyle: widget.textTheme.labelMedium,
            leadingAndTrailingTextStyle: widget.textTheme.labelMedium,
            title: const Row(
              children: [
                Expanded(flex: 2, child: Text('Name')),
                Flexible(child: Align(alignment: Alignment.center, child: Text('Rate'))),
              ],
            ),
            trailing: ConstrainedBox(
              constraints: const BoxConstraints.tightFor(width: 100),
              child: const Align(alignment: Alignment.center, child: Text('Result')),
            ),
          ),
          const Divider(),
          Flexible(
            child: Material(
              color: Colors.transparent,
              child: PageView.builder(
                controller: pageController,
                itemCount: pages.length,
                onPageChanged: (page) => setState(() => pageIndex = page + 1),
                itemBuilder: (context, index) {
                  _TestPage page = pages[index];
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: page.tests.length,
                    itemBuilder: (context, idx) {
                      Test t = page.tests[idx];
                      int gindex = index * 8 + idx; // The global index

                      return ListTile(
                        onTap: () => focusNodes[gindex].requestFocus(),
                        titleTextStyle: style,
                        leadingAndTrailingTextStyle: style,
                        title: Row(
                          children: [
                            Expanded(flex: 2, child: Text(t.label, overflow: TextOverflow.ellipsis)),
                            Flexible(child: Align(alignment: Alignment.center, child: Text(t.rate))),
                          ],
                        ),
                        trailing: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 100),
                          child: Focus(
                            onFocusChange: (_) => HiveFunctions().submitResult(
                              uid: patient.uid,
                              test: t,
                              result: controllers[gindex].text,
                            ),
                            child: TextField(
                              focusNode: focusNodes[gindex],
                              controller: controllers[gindex],
                              style: style,
                              textAlign: TextAlign.center,
                              onTapOutside: (_) {
                                HiveFunctions().submitResult(
                                  uid: patient.uid,
                                  test: t,
                                  result: controllers[gindex].text,
                                );
                                focusNodes[gindex].unfocus();
                              },
                              onSubmitted: (result) {
                                HiveFunctions().submitResult(uid: patient.uid, test: t, result: result);
                                if (gindex != patient.tests.length - 1) {
                                  FocusScope.of(context).requestFocus(focusNodes[gindex + 1]);
                                }
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                constraints: const BoxConstraints.tightFor(height: 30),
                                border: const OutlineInputBorder(borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: widget.colors.primary)),
                              ),
                            ),
                          ),
                        ),
                        visualDensity: const VisualDensity(vertical: VisualDensity.minimumDensity),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          const Divider(),
          Container(
            constraints: const BoxConstraints(minHeight: kTextTabBarHeight),
            padding: const EdgeInsets.symmetric(horizontal: padding),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(onPressed: back, icon: const Icon(CupertinoIcons.chevron_back)),
                  const Gap(gap),
                  Container(
                    width: 40,
                    alignment: Alignment.center,
                    child: Text('$pageIndex - ${pages.length}', style: widget.textTheme.bodySmall),
                  ),
                  const Gap(gap),
                  IconButton(onPressed: next, icon: const Icon(CupertinoIcons.chevron_forward)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

 */