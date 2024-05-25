import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:labcure/models/catalog.dart';
import 'package:labcure/models/patient.dart';
import 'package:labcure/models/test.dart';
import 'package:labcure/services/hive_services.dart';

class HiveInitializer {
  static Future<void> ensureInitialized() async {
    await Hive.initFlutter();
    registerAdapters();
    await Hive.openBox<Patient>(Boxes.patient);
    await Hive.openBox<Catalog>(Boxes.catalog);
    await initiateCatalogs();
  }

  static void registerAdapters() {
    Hive.registerAdapter(PatientAdapter());
    Hive.registerAdapter(TestAdapter());
    Hive.registerAdapter(CatalogAdapter());
  }

  static Future<void> initiateCatalogs() async {
    Box<Catalog> catalogbox = Hiveservices.instance.catalogbox;
    if (catalogbox.isOpen && catalogbox.isEmpty) {
      final file = await rootBundle.loadString('assets/catalogs.json');
      final List<dynamic> catalogs = json.decode(file);

      for (final data in catalogs) {
        String uid = '${DateTime.now().millisecondsSinceEpoch + Random().nextInt(100)}';
        Catalog catalog = Catalog(
          uid: uid,
          label: data['label'],
          tests: (data['tests'] as List<dynamic>).map((test) {
            return Test(id: test['id'], label: test['label'], rate: test['rate'], unit: test['unit']);
          }).toList(),
        );

        await catalogbox.put(catalog.uid, catalog);
      }
    }
  }
}


/*

import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:labcure/models/catalog.dart';
import 'package:labcure/models/patient.dart';
import 'package:labcure/models/test.dart';
import 'package:labcure/services/hive_services.dart';

class HiveInitializer {
  static Future<void> ensureInitialized() async {
    await Hive.initFlutter();
    registerAdapters();
    await Hive.openBox<Patient>(Boxes.patient);
    await Hive.openBox<Catalog>(Boxes.catalog);
    initiateData();
  }

  static void registerAdapters() {
    Hive.registerAdapter(PatientAdapter());
    Hive.registerAdapter(CatalogAdapter());
    Hive.registerAdapter(TestAdapter());
  }

  static Future<void> initiateData() async {
    Box<Catalog> catalogbox = Hiveservices.instance.catalogbox;
    if (catalogbox.isOpen && catalogbox.isEmpty) {
      final file = await rootBundle.loadString('assets/catalogs.json');
      final List<dynamic> catalogs = json.decode(file);

      for (final data in catalogs) {
        String uid = '${DateTime.now().millisecondsSinceEpoch + Random().nextInt(100)}';
        Catalog catalog = Catalog(
          uid: uid,
          label: data['label'],
          tests: (data['tests'] as List<dynamic>).map((test) {
            return Test(id: test['id'], label: test['label'], rate: test['rate'], unit: test['unit']);
          }).toList(),
        );

        await catalogbox.put(catalog.uid, catalog);
      }
    }
  }
}

 */