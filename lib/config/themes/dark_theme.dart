import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labcure/config/styles/borders.dart';
import 'package:labcure/config/styles/constants.dart';
import 'package:labcure/config/styles/shapes.dart';

ColorScheme _colors = ColorScheme.fromSeed(brightness: Brightness.dark, seedColor: CupertinoColors.systemCyan);
TextTheme _texts = TextTheme(
  displayMedium: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.w600),
  titleMedium: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
  labelMedium: GoogleFonts.poppins(fontSize: 13.0, fontWeight: FontWeight.w600),
  labelSmall: GoogleFonts.poppins(fontSize: 11.0),
);

ThemeData darkTheme = ThemeData(
  fontFamily: GoogleFonts.poppins().fontFamily,
  colorScheme: _colors,
  appBarTheme: AppBarTheme(
    centerTitle: false,
    toolbarHeight: toolbarHeight,
    actionsIconTheme: const IconThemeData(size: 20.0),
    iconTheme: const CupertinoIconThemeData(size: 20.0),
    titleTextStyle: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.w600),
  ),
  tabBarTheme: TabBarTheme(
    labelStyle: _texts.labelMedium,
    unselectedLabelStyle: _texts.labelMedium,
    unselectedLabelColor: _colors.onSurfaceVariant,
  ),
  iconTheme: IconThemeData(size: 16.0, color: _colors.onSurfaceVariant),
  searchBarTheme: SearchBarThemeData(
    constraints: const BoxConstraints.tightFor(height: height),
    overlayColor: const WidgetStatePropertyAll(Colors.transparent),
    surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
    backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
    shadowColor: const WidgetStatePropertyAll(Colors.transparent),
    side: WidgetStateBorderSide.resolveWith((state) {
      if (state.contains(WidgetState.focused)) {
        return BorderSide(color: _colors.primary);
      }
      return BorderSide(color: _colors.outlineVariant.withOpacity(.5));
    }),
    shape: WidgetStatePropertyAll(Shapes.rec),
    textStyle: WidgetStatePropertyAll(_texts.labelMedium),
  ),
  listTileTheme: ListTileThemeData(
    contentPadding: const EdgeInsets.symmetric(horizontal: padding),
    titleTextStyle: _texts.labelSmall,
    leadingAndTrailingTextStyle: _texts.labelSmall,
  ),
  popupMenuTheme: PopupMenuThemeData(
    position: PopupMenuPosition.under,
    shape: Shapes.rec,
    labelTextStyle: WidgetStatePropertyAll(GoogleFonts.poppins(fontSize: 12.0)),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      textStyle: WidgetStatePropertyAll(GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      shape: WidgetStatePropertyAll(Shapes.rec),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      textStyle: WidgetStatePropertyAll(GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      shape: WidgetStatePropertyAll(Shapes.rec),
    ),
  ),
  iconButtonTheme: IconButtonThemeData(style: ButtonStyle(shape: WidgetStatePropertyAll(Shapes.rec))),
  dialogTheme: DialogTheme(shape: Shapes.rec),
  dividerTheme: DividerThemeData(space: 0.5, thickness: 0.5, color: _colors.outlineVariant.withOpacity(0.5)),
  textTheme: _texts,
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.all(12),
    labelStyle: GoogleFonts.poppins(fontSize: 12),
    hintStyle: GoogleFonts.poppins(fontSize: 10),
    border: Borders.inputBorder,
  ),
);
