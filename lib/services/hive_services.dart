import 'package:hive/hive.dart';
import 'package:labcure/models/catalog.dart';
import 'package:labcure/models/patient.dart';

class Hiveservices {
  Hiveservices._(this.patientbox, this.catalogbox);
  Box<Patient> patientbox;
  Box<Catalog> catalogbox;

  static Hiveservices get instance => Hiveservices();
  static final Hiveservices _instance = Hiveservices._(
    Hive.box<Patient>(Boxes.patient),
    Hive.box<Catalog>(Boxes.catalog),
  );
  factory Hiveservices() => _instance;
}

class Boxes {
  static const patient = 'patient';
  static const catalog = 'catalog';
}
