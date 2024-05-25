import 'dart:math';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:labcure/models/catalog.dart';
import 'package:labcure/models/patient.dart';
import 'package:labcure/models/test.dart';
import 'package:labcure/services/hive_services.dart';

class HiveFunctions {
  Box<Patient> patientbox = Hiveservices.instance.patientbox;
  Box<Catalog> catalogbox = Hiveservices.instance.catalogbox;

  void submitPatient({
    required String pid,
    required String title,
    required String name,
    required String age,
    required String gender,
    required List<Test> tests,
  }) {
    String uid = '${DateTime.now().millisecondsSinceEpoch + Random().nextInt(100)}';
    String admissionDate = DateFormat('dd MMM yyyy - hh:mm a').format(DateTime.now());

    Patient patient = Patient(
      uid: uid,
      pid: pid,
      title: title,
      name: name,
      age: age,
      gender: gender,
      admissionDate: admissionDate,
      tests: tests,
    );
    patientbox.put(uid, patient);
  }

  String get generatepid => _pidgenerator(patientbox);

  String _pidgenerator(Box<Patient> box) {
    if (box.isEmpty) return '${'P'.padRight(5, '0')}1';
    String pid = box.values.last.pid;
    int number = int.parse(pid.substring(pid.indexOf(RegExp(r'[1-9]'))));
    if (number <= 8) return '${'P'.padRight(5, '0')}${number + 1}';
    if (number >= 9 && number <= 99) return '${'P'.padRight(4, '0')}${number + 1}';

    return '${'P'.padRight(3, '0')}${number + 1}';
  }

  void submitResult({required String uid, required Test test, required String result}) {
    Patient patient = patientbox.get(uid)!;
    for (final t in patient.tests) {
      if (t.id == test.id) t.result = result;
    }
    patientbox.put(uid, patient);
  }

  void updatePatient({
    required String uid,
    required String pid,
    required String title,
    required String name,
    required String age,
    required String gender,
    required List<Test> tests,
  }) {
    Patient patient = Patient(
      uid: uid,
      pid: pid,
      title: title,
      name: name,
      age: age,
      gender: gender,
      tests: tests,
    );
    patientbox.put(uid, patient);
  }

  void updateTest({
    required String key,
    required int index,
    required String id,
    required String label,
    required String rate,
    required String unit,
  }) {
    Catalog? catalog = catalogbox.get(key);
    Test test = Test(
      id: id,
      label: label,
      rate: rate,
      unit: unit,
    );
    catalog!.tests![index] = test;
    catalogbox.put(catalog.uid, catalog);
  }
}
