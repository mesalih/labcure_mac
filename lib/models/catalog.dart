import 'package:hive_flutter/hive_flutter.dart';
import 'package:labcure/models/group.dart';
import 'package:labcure/models/test.dart';

part 'catalog.g.dart';

@HiveType(typeId: 3)
class Catalog {
  const Catalog({required this.uid, required this.label, this.tests, this.groups});

  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String label;
  @HiveField(2)
  final List<Test>? tests;
  @HiveField(3)
  final List<Group>? groups;
}
