import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:labcure/config/router/router.dart';
import 'package:labcure/config/styles/borders.dart';
import 'package:labcure/models/patient.dart';
import 'package:labcure/services/hive_services.dart';

class Patients extends StatefulWidget {
  const Patients({super.key, required this.query});
  final String query;

  @override
  State<Patients> createState() => _PatientPageState();
}

class _PatientPageState extends State<Patients> {
  Patient? patient;

  Iterable<Patient> filter(Box<Patient> box) {
    String query = widget.query.toLowerCase();
    if (query.isEmpty) return box.values.where((p) => !p.tested && !p.postpone);
    if (query.contains('postpone')) return box.values.where((p) => p.postpone);
    if (query.contains('active')) return box.values.where((p) => !p.urgent);
    if (query.contains('urgent')) return box.values.where((p) => p.urgent);
    if (query.contains('complate')) return box.values.where((p) => p.tested);
    return box.values.where((p) => p.name.toLowerCase().contains(query));
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;

    return ValueListenableBuilder(
      valueListenable: Hiveservices.instance.patientbox.listenable(),
      builder: (context, box, _) {
        Iterable<Patient> patients = filter(box);
        return Material(
          color: Colors.transparent,
          child: ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              Patient p = patients.elementAt(index);

              return _Tile(
                onTap: () {
                  setState(() => patient = p);
                  context.go(Paths.patientview.path, extra: p.uid);
                },
                selected: patient == p,
                colors: colors,
                patient: p,
              );
            },
          ),
        );
      },
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.patient, this.onTap, required this.selected, required this.colors});
  final Patient patient;
  final void Function()? onTap;
  final bool selected;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    ListTileThemeData style = Theme.of(context).listTileTheme;

    Color? color() {
      if (!patient.urgent) return null;
      if (selected) return colors.primary;
      return CupertinoColors.systemRed;
    }

    Text text(String data) {
      return Text(data, style: style.leadingAndTrailingTextStyle!.copyWith(color: color()));
    }

    Text status() {
      if (patient.urgent) return text('Urgent');
      if (patient.postpone) return text('Postpone');
      if (patient.tested) return text('Complate');
      return text('Active');
    }

    return ListTile(
      onTap: onTap,
      title: Text(patient.name, style: style.titleTextStyle!.copyWith(color: color()), overflow: TextOverflow.ellipsis),
      selected: selected,
      titleTextStyle: style.titleTextStyle!.copyWith(
        color: selected ? colors.primary : colors.onSurfaceVariant.withOpacity(0.5),
      ),
      leadingAndTrailingTextStyle: style.leadingAndTrailingTextStyle!.copyWith(
        color: colors.onSurfaceVariant.withOpacity(0.5),
      ),
      trailing: Container(
        constraints: const BoxConstraints(maxHeight: 25, maxWidth: 70),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: Borders.borderRadius,
          color: colors.secondaryContainer.withOpacity(0.2),
        ),
        child: status(),
      ),
    );
  }
}
