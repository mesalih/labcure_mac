import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:labcure/config/styles/borders.dart';
import 'package:labcure/config/styles/constants.dart';
import 'package:labcure/functions/hive_functions.dart';
import 'package:labcure/models/patient.dart';
import 'package:labcure/models/test.dart';
import 'package:labcure/widgets/initialize.dart';
import 'package:labcure/widgets/initials.dart';
import 'package:labcure/widgets/step_button.dart';

class PatientEdit extends StatefulWidget {
  const PatientEdit({super.key, required this.patient});
  final Patient patient;

  @override
  State<PatientEdit> createState() => _PatientEditState();
}

class _PatientEditState extends State<PatientEdit> {
  Patient get patient => widget.patient;
  late List<FocusNode> focusNodes;
  late List<TextEditingController> controllers;
  late List<String> steps;
  late List<Widget> pages;
  late List<Test> tests = [];
  int step = 0;

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(6, (index) => FocusNode());
    controllers = List.generate(6, (index) => TextEditingController());
    steps = ['Initials', 'Initialize'];
    tests.addAll(patient.tests);
    init();
    pages = [
      Initials(focusNodes: focusNodes.sublist(0, 6), controllers: controllers.sublist(0, 6)),
      Initialize(tests: tests),
    ];
  }

  void init() {
    List<String> age = patient.age.split('/');
    controllers[0].text = patient.title;
    controllers[1].text = patient.name;
    controllers[2].text = age[0];
    controllers[3].text = age[1];
    controllers[4].text = age[2];
    controllers[5].text = patient.gender;
  }

  void submit() {
    bool filled = true;
    filled = control(filled: filled);

    if (filled) {
      String age = '${controllers[2].text}/${controllers[3].text}/${controllers[4].text}';

      HiveFunctions().updatePatient(
        uid: patient.uid,
        pid: patient.uid,
        title: controllers[0].text.trim(),
        name: controllers[1].text.trim(),
        age: age,
        gender: controllers[5].text.trim(),
        tests: tests,
      );
      context.pop();
    }
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text('Edit:  ${widget.patient.name}'),
        actions: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(CupertinoIcons.clear),
          ),
          const Gap(padding),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            padding: const EdgeInsets.all(gap / 1.2),
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
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: size.width / 2.2,
              minHeight: size.height - (toolbarHeight + kTextTabBarHeight + padding * 3),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Gap(padding),
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
                ),
                const Gap(padding)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
