import 'package:flutter/material.dart';
import 'package:labcure/config/styles/constants.dart';

class Borders {
  static Radius radius = const Radius.circular(diameter);
  static BorderRadius borderRadius = BorderRadius.all(radius);
  static OutlineInputBorder inputBorder = OutlineInputBorder(
    borderRadius: borderRadius,
  );
}
