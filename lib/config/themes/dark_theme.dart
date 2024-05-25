import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labcure/config/styles/borders.dart';
import 'package:labcure/config/styles/constants.dart';
import 'package:labcure/config/styles/shapes.dart';

ColorScheme _colorScheme = ColorScheme.fromSeed(brightness: Brightness.dark, seedColor: CupertinoColors.systemCyan);
TextTheme textTheme = TextTheme(
  labelMedium: GoogleFonts.poppins(fontSize: 13.0, fontWeight: FontWeight.w600),
  labelSmall: GoogleFonts.poppins(fontSize: 10.0),
);

ThemeData darkTheme = ThemeData(
  fontFamily: GoogleFonts.poppins().fontFamily,
  colorScheme: _colorScheme,
  appBarTheme: AppBarTheme(
    toolbarHeight: toolbarHeight,
    actionsIconTheme: const IconThemeData(size: 20.0),
    iconTheme: const CupertinoIconThemeData(size: 20.0),
    titleTextStyle: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.w600),
  ),
  iconTheme: IconThemeData(size: 16.0, color: _colorScheme.onSurfaceVariant),
  searchBarTheme: SearchBarThemeData(
    constraints: const BoxConstraints.tightFor(height: height),
    overlayColor: const WidgetStatePropertyAll(Colors.transparent),
    surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
    backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
    shadowColor: const WidgetStatePropertyAll(Colors.transparent),
    side: WidgetStateBorderSide.resolveWith((state) {
      if (state.contains(WidgetState.focused)) {
        return BorderSide(color: _colorScheme.primary);
      }
      return BorderSide(color: _colorScheme.outlineVariant.withOpacity(.5));
    }),
    shape: WidgetStatePropertyAll(Shapes.rec),
    textStyle: WidgetStatePropertyAll(textTheme.labelMedium),
  ),
  listTileTheme: ListTileThemeData(
    contentPadding: const EdgeInsets.symmetric(horizontal: padding),
    titleTextStyle: textTheme.labelSmall,
    leadingAndTrailingTextStyle: textTheme.labelSmall,
  ),
  popupMenuTheme: PopupMenuThemeData(
    position: PopupMenuPosition.under,
    shape: Shapes.rec,
    labelTextStyle: WidgetStatePropertyAll(GoogleFonts.poppins(fontSize: 12.0)),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      textStyle: WidgetStatePropertyAll(GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      shape: WidgetStatePropertyAll(Shapes.rec),
    ),
  ),
  iconButtonTheme: IconButtonThemeData(style: ButtonStyle(shape: WidgetStatePropertyAll(Shapes.rec))),
  dividerTheme: DividerThemeData(space: 0.5, thickness: 0.5, color: _colorScheme.outlineVariant.withOpacity(0.5)),
  textTheme: textTheme,
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.all(12),
    labelStyle: GoogleFonts.poppins(fontSize: 12),
    hintStyle: GoogleFonts.poppins(fontSize: 10),
    border: Borders.inputBorder,
  ),
);