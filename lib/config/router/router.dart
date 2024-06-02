import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labcure/main.dart';
import 'package:labcure/models/patient.dart';
import 'package:labcure/pages/home/patient_creating.dart';
import 'package:labcure/pages/home/patient_edit.dart';
import 'package:labcure/pages/home/patient_page.dart';
import 'package:labcure/pages/home/patient_view.dart';
import 'package:labcure/pages/library/catalog_page.dart';
import 'package:labcure/pages/library/catalog_view.dart';
import 'package:labcure/pages/library/group_creation.dart';
import 'package:labcure/pages/report/report_page.dart';
import 'package:labcure/pages/settings/settings_page.dart';
import 'package:labcure/widgets/replacement.dart';

enum Paths {
  patientview(path: '/'),
  patientcreation(path: '/patient_creation'),
  patientedit(path: '/patient_edit'),

  report(path: '/report'),

  catalog(path: '/catalog'),
  catalogview(path: '/catalog_view'),
  groupcreation(path: 'group_creation'),

  settings(path: '/settings');

  final String path;
  const Paths({required this.path});
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
                      path: Paths.patientview.path,
                      pageBuilder: (context, state) {
                        String? uid = state.extra as String?;
                        return MaterialPage(child: uid != null ? PatientView(uid: uid) : const Replacement());
                      },
                    ),
                    GoRoute(
                      path: Paths.patientcreation.path,
                      name: Paths.patientcreation.name,
                      pageBuilder: (context, state) => const MaterialPage(child: PatientCreation()),
                    ),
                    GoRoute(
                      path: Paths.patientedit.path,
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
                  path: Paths.report.path,
                  pageBuilder: (context, state) => const MaterialPage(
                    child: ReportPage(),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: Paths.catalog.path,
                  pageBuilder: (context, state) => const MaterialPage(
                    child: CatalogPage(),
                  ),
                ),
                GoRoute(
                  path: Paths.catalogview.path,
                  pageBuilder: (context, state) {
                    String uid = state.extra as String;
                    return MaterialPage(child: CatalogView(uid: uid));
                  },
                  routes: [
                    GoRoute(
                      path: Paths.groupcreation.path,
                      name: Paths.groupcreation.name,
                      pageBuilder: (context, state) {
                        String uid = state.extra as String;
                        return MaterialPage(child: GroupCreation(uid: uid));
                      },
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: Paths.settings.path,
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
