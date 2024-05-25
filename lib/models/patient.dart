import 'package:hive/hive.dart';
import 'package:labcure/models/test.dart';

part 'patient.g.dart';

@HiveType(typeId: 0)
class Patient {
  Patient({
    required this.uid,
    required this.pid,
    required this.title,
    required this.name,
    required this.age,
    required this.gender,
    this.admissionDate,
    this.reportDate,
    this.tested = false,
    this.urgent = false,
    this.postpone = false,
    required this.tests,
  });

  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String pid;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String name;
  @HiveField(4)
  final String age;
  @HiveField(6)
  final String gender;
  @HiveField(7)
  final String? admissionDate;
  @HiveField(8)
  String? reportDate;
  @HiveField(9)
  bool tested;
  @HiveField(10)
  bool urgent;
  @HiveField(11)
  bool postpone;
  @HiveField(12)
  final List<Test> tests;
}
