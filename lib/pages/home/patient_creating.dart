import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:labcure/config/styles/borders.dart';
import 'package:labcure/config/styles/constants.dart';
import 'package:labcure/functions/hive_functions.dart';
import 'package:labcure/models/test.dart';
import 'package:labcure/widgets/initialize.dart';
import 'package:labcure/widgets/initials.dart';
import 'package:labcure/widgets/step_button.dart';

class PatientCreation extends StatefulWidget {
  const PatientCreation({super.key});

  @override
  State<PatientCreation> createState() => _PatientCreationState();
}

class _PatientCreationState extends State<PatientCreation> {
  late List<FocusNode> focusNodes;
  late List<TextEditingController> controllers;
  late List<String> steps;
  late List<Widget> pages;
  late List<Test> tests = [];
  int step = 0;
  late String pid;

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(6, (index) => FocusNode());
    controllers = List.generate(6, (index) => TextEditingController());
    steps = ['Initials', 'Initialize'];
    pages = [
      Initials(focusNodes: focusNodes.sublist(0, 6), controllers: controllers.sublist(0, 6)),
      Initialize(tests: tests),
    ];
    pid = HiveFunctions().generatepid;
  }

  bool control({required bool filled}) {
    for (int i = 0; i < controllers.length; i++) {
      if (controllers[i].text.isEmpty) {
        filled = false;
        FocusScope.of(context).requestFocus(focusNodes[i]);
        break;
      }
    }
    return filled;
  }

  void submit() {
    bool filled = true;
    filled = control(filled: filled);

    if (filled) {
      String age = '${controllers[2].text}/${controllers[3].text}/${controllers[4].text}';

      try {
        HiveFunctions().submitPatient(
          pid: pid,
          title: controllers[0].text.trim(),
          name: controllers[1].text.trim(),
          age: age,
          gender: controllers[5].text.trim(),
          tests: tests,
        );
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        context.pop();
      }
    }
  }

  void jump(int index) {
    bool filled = true;
    filled = control(filled: filled);
    if (index < step) setState(() => step = index);
    if (filled) setState(() => step = index);
  }

  void next() {
    bool filled = true;
    filled = control(filled: filled);
    if (filled) {
      setState(() => step++);
      FocusScope.of(context).unfocus();
    }
  }

  void previous() => setState(() => step--);

  @override
  void dispose() {
    super.dispose();
    for (int i = 0; i < controllers.length; i++) {
      focusNodes[i].dispose();
      controllers[i].dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    AppBarTheme style = Theme.of(context).appBarTheme;
    ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('New Patient'),
        actions: [
          Text(pid, style: style.titleTextStyle),
          const Gap(padding),
          IconButton(onPressed: () => context.pop(), icon: const Icon(CupertinoIcons.clear)),
          const Gap(padding),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kTextTabBarHeight + gap / 1.2),
          child: Container(
            padding: const EdgeInsets.all(gap / 1.2),
            margin: const EdgeInsets.only(bottom: gap / 1.2),
            constraints: const BoxConstraints(maxHeight: kTextTabBarHeight, maxWidth: 300),
            decoration: BoxDecoration(
              color: colors.surfaceContainer.withOpacity(0.5),
              borderRadius: Borders.borderRadius,
            ),
            child: Row(
              children: List.generate(steps.length, (index) {
                return Flexible(
                  child: StepButton(onPressed: () => jump(index), active: step == index, child: Text(steps[index])),
                );
              }),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: padding, vertical: padding),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: size.width / 2.2,
              minHeight: size.height - (toolbarHeight + kTextTabBarHeight + padding * 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                pages[step],
                const Gap(padding),
                Row(
                  children: [
                    Flexible(
                      child: FilledButton.tonal(
                        onPressed: step > 0 ? previous : null,
                        style: const ButtonStyle(minimumSize: WidgetStatePropertyAll(Size(double.maxFinite, 56))),
                        child: const Text('Previous'),
                      ),
                    ),
                    const Gap(gap),
                    Flexible(
                      child: FilledButton(
                        onPressed: step == steps.length - 1 ? submit : next,
                        style: ButtonStyle(
                          minimumSize: const WidgetStatePropertyAll(Size(double.maxFinite, 56)),
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
                        child: Text(step == steps.length - 1 ? 'Submit' : 'Next'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*


import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:labcure/config/styles/borders.dart';
import 'package:labcure/config/styles/constants.dart';
import 'package:labcure/functions/hive_functions.dart';
import 'package:labcure/models/test.dart';
import 'package:labcure/widgets/initialize.dart';
import 'package:labcure/widgets/initials.dart';
import 'package:labcure/widgets/step_button.dart';
import 'package:labcure/widgets/titlebar.dart';

class PatientCreation extends StatefulWidget {
  const PatientCreation({super.key});

  @override
  State<PatientCreation> createState() => _PatientCreationState();
}

class _PatientCreationState extends State<PatientCreation> {
  late List<FocusNode> focusNodes;
  late List<TextEditingController> controllers;
  late List<String> steps;
  late List<Widget> pages;
  late List<Test> tests = [];
  int step = 0;
  late String pid;

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(6, (index) => FocusNode());
    controllers = List.generate(6, (index) => TextEditingController());
    steps = ['Initials', 'Initialize'];
    pages = [Initials(focusNodes: focusNodes.sublist(0, 6), controllers: controllers.sublist(0, 6)), Initialize(tests: tests)];
    pid = HiveFunctions().generatepid;
  }

  bool control({required bool filled}) {
    for (int i = 0; i < controllers.length; i++) {
      if (controllers[i].text.isEmpty) {
        filled = false;
        FocusScope.of(context).requestFocus(focusNodes[i]);
        break;
      }
    }
    return filled;
  }

  void submit() {
    bool filled = true;
    filled = control(filled: filled);

    if (filled) {
      String age = '${controllers[2].text}/${controllers[3].text}/${controllers[4].text}';

      try {
        HiveFunctions().submitPatient(
          pid: pid,
          title: controllers[0].text.trim(),
          name: controllers[1].text.trim(),
          age: age,
          gender: controllers[5].text.trim(),
          tests: tests,
        );
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        context.pop();
      }
    }
  }

  void jump(int index) {
    bool filled = true;
    filled = control(filled: filled);
    if (index < step) setState(() => step = index);
    if (filled) setState(() => step = index);
  }

  void next() {
    bool filled = true;
    filled = control(filled: filled);
    if (filled) {
      setState(() => step++);
      FocusScope.of(context).unfocus();
      FocusScope.of(context).nextFocus();
    }
  }

  void previous() => setState(() => step--);

  @override
  void dispose() {
    super.dispose();
    for (int i = 0; i < controllers.length; i++) {
      focusNodes[i].dispose();
      controllers[i].dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    AppBarTheme sytle = Theme.of(context).appBarTheme;
    ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close_rounded, size: 22)),
        title: const MoveWindow(child: Text('New Patient')),
        actions: [MoveWindow(child: Text(pid, style: sytle.titleTextStyle)), const Gap(padding)],
        flexibleSpace: const MoveWindow(),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kTextTabBarHeight),
          child: Container(
            padding: const EdgeInsets.all(nook),
            constraints: const BoxConstraints(maxHeight: kTextTabBarHeight, maxWidth: 200),
            decoration: BoxDecoration(color: colors.secondaryContainer.withOpacity(0.2), borderRadius: Borders.borderRadius),
            child: Row(
              children: List.generate(steps.length, (index) {
                return Flexible(
                  child: StepButton(onPressed: () => jump(index), active: step == index, child: Text(steps[index])),
                );
              }),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: padding),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: size.width / 2, //size.width > 800 ? size.width / 2 : size.width / 1.2,
              minHeight: size.height - (kToolbarHeight + kTextTabBarHeight),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                pages[step],
                const Gap(padding),
                Row(
                  children: [
                    Flexible(
                      child: FilledButton.tonal(
                        onPressed: step > 0 ? previous : null,
                        style: const ButtonStyle(minimumSize: MaterialStatePropertyAll(Size(double.maxFinite, 56))),
                        child: const Text('Previous'),
                      ),
                    ),
                    const Gap(gap),
                    Flexible(
                      child: FilledButton(
                        onPressed: step == steps.length - 1 ? submit : next,
                        style: ButtonStyle(
                          minimumSize: const MaterialStatePropertyAll(Size(double.maxFinite, 56)),
                          shape: MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.focused)) {
                              return RoundedRectangleBorder(
                                side: BorderSide(color: colors.inverseSurface, width: 2),
                                borderRadius: Borders.borderRadius,
                              );
                            }
                            return null;
                          }),
                        ),
                        child: Text(step == steps.length - 1 ? 'Submit' : 'Next'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

 */