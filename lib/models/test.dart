import 'package:hive_flutter/adapters.dart';

part 'test.g.dart';

@HiveType(typeId: 1)
class Test {
  Test({required this.id, required this.label, required this.rate, required this.unit, this.result});

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String label;
  @HiveField(2)
  final String rate;
  @HiveField(3)
  final String unit;
  @HiveField(4)
  String? result;
}
