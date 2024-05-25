import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labcure/main.dart';
import 'package:labcure/models/catalog.dart';
import 'package:labcure/models/patient.dart';
import 'package:labcure/pages/home/patient_creating.dart';
import 'package:labcure/pages/home/patient_edit.dart';
import 'package:labcure/pages/home/patient_page.dart';
import 'package:labcure/pages/home/patient_view.dart';
import 'package:labcure/pages/library/catalog_page.dart';
import 'package:labcure/pages/library/catalog_view.dart';
import 'package:labcure/pages/report/report_page.dart';
import 'package:labcure/pages/settings/settings_page.dart';
import 'package:labcure/widgets/replacement.dart';

enum RoutePath {
  patientview(path: '/'),
  patientcreation(path: '/patient_creation'),
  patientedit(path: '/patient_edit'),

  report(path: '/report'),
  catalog(path: '/catalog'),
  catalogview(path: '/catalog_view'),
  settings(path: '/settings');

  final String path;
  const RoutePath({required this.path});
}

class Routes with ChangeNotifier {
  GoRouter router(BuildContext context) {
    return GoRouter(
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) => Root(shell: shell),
          branches: [
            StatefulShellBranch(
              routes: [
                ShellRoute(
                  builder: (context, state, child) => PatientPage(child: child),
                  routes: [
                    GoRoute(
                      path: RoutePath.patientview.path,
                      pageBuilder: (context, state) {
                        String? uid = state.extra as String?;
                        return MaterialPage(child: uid != null ? PatientView(uid: uid) : const Replacement());
                      },
                    ),
                    GoRoute(
                      path: RoutePath.patientcreation.path,
                      name: RoutePath.patientcreation.name,
                      pageBuilder: (context, state) => const MaterialPage(child: PatientCreation()),
                    ),
                    GoRoute(
                      path: RoutePath.patientedit.path,
                      pageBuilder: (context, state) {
                        Patient p = state.extra as Patient;
                        return MaterialPage(child: PatientEdit(patient: p));
                      },
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RoutePath.report.path,
                  pageBuilder: (context, state) => const MaterialPage(
                    child: ReportPage(),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RoutePath.catalog.path,
                  pageBuilder: (context, state) => const MaterialPage(
                    child: CatalogPage(),
                  ),
                ),
                GoRoute(
                  path: RoutePath.catalogview.path,
                  pageBuilder: (context, state) {
                    Catalog c = state.extra as Catalog;
                    return MaterialPage(child: CatalogView(catalog: c));
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RoutePath.settings.path,
                  pageBuilder: (context, state) => const MaterialPage(
                    child: SettingsPage(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
