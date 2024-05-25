import 'package:hive_flutter/hive_flutter.dart';
import 'package:labcure/models/test.dart';

part 'group.g.dart';

@HiveType(typeId: 3)
class Group {
  const Group({required this.id, required this.label, required this.tests});

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String label;
  @HiveField(2)
  final List<Test> tests;
}
