import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labcure/config/router/router.dart';
import 'package:labcure/config/styles/constants.dart';
import 'package:labcure/config/styles/shapes.dart';
import 'package:labcure/config/themes/dark_theme.dart';
import 'package:labcure/config/themes/theme.dart';
import 'package:labcure/services/perefences.dart';
import 'package:labcure/utils/hive_initializer.dart';
import 'package:labcure/utils/window_initializer.dart';
import 'package:labcure/widgets/sidebar/sidebar.dart';
import 'package:labcure/widgets/sidebar/sidebar_style.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WindowInitializer.initialize();
  await Preferences.ensureInitialized();
  await HiveInitializer.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Routes()),
        ChangeNotifierProvider(create: (_) => Preferences()),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: theme,
      darkTheme: darkTheme,
      themeMode: context.watch<Preferences>().theme == ThemeModes.dark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: context.read<Routes>().router(context),
    );
  }
}

class Root extends StatelessWidget {
  const Root({super.key, required this.shell});
  final StatefulNavigationShell shell;

  void onDestinationSelected(int index) {
    shell.goBranch(index, initialLocation: shell.currentIndex == index);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Sidebar(
          selectedDestination: shell.currentIndex,
          onDestinationSelected: onDestinationSelected,
          leading: const SizedBox(height: 32),
          destinations: const [
            SidebarDestination(icon: Icon(CupertinoIcons.square_grid_2x2_fill), label: Text('Homne')),
            SidebarDestination(icon: Icon(CupertinoIcons.chart_bar_alt_fill), label: Text('Report')),
            SidebarDestination(icon: Icon(CupertinoIcons.collections_solid), label: Text('Library')),
            SidebarDestination(icon: Icon(CupertinoIcons.settings_solid), label: Text('Settings')),
          ],
          trailing: IconButton(
            onPressed: () => context.read<Preferences>().toggleTheme(),
            isSelected: context.read<Preferences>().theme == ThemeModes.dark,
            selectedIcon: const Icon(CupertinoIcons.moon_fill),
            icon: const Icon(CupertinoIcons.sun_max_fill),
          ),
          style: SidebarStyle(
            verticalSpacing: padding,
            backgroundColor: colors.surfaceContainer,
            indicatorStyle: IndicatorStyle(shape: Shapes.rec),
          ),
        ),
        Flexible(child: shell),
      ],
    );
  }
}
