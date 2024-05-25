import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SidebarStyle {
  const SidebarStyle({
    this.width,
    this.extendedWidth,
    this.verticalSpacing,
    this.backgroundColor,
    this.selectedIconTheme,
    this.unselectedIconTheme,
    this.selectedLabelTextStyle,
    this.unselectedLabelTextStyle,
    this.indicatorStyle,
  });

  final double? width;
  final double? extendedWidth;
  final double? verticalSpacing;
  final Color? backgroundColor;
  final IconThemeData? selectedIconTheme;
  final IconThemeData? unselectedIconTheme;
  final TextStyle? selectedLabelTextStyle;
  final TextStyle? unselectedLabelTextStyle;
  final IndicatorStyle? indicatorStyle;
}

@immutable
class IndicatorStyle with Diagnosticable {
  const IndicatorStyle({this.height, this.color, this.shape});
  final double? height;
  final Color? color;
  final ShapeBorder? shape;

  IndicatorStyle copyWith({
    final double? height,
    final Color? color,
    final ShapeBorder? shape,
  }) {
    return IndicatorStyle(height: height ?? this.height, color: color ?? this.color, shape: shape ?? this.shape);
  }

  static IndicatorStyle? lerp(IndicatorStyle? a, IndicatorStyle? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return IndicatorStyle(
      height: lerpDouble(a?.height, b?.height, t),
      color: Color.lerp(a?.color, b?.color, t),
      shape: ShapeBorder.lerp(a?.shape, b?.shape, t),
    );
  }

  @override
  int get hashCode => Object.hash(height, color, shape);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is IndicatorStyle && other.height == height && other.color == color && other.shape == shape;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    const IndicatorStyle defaultData = IndicatorStyle();

    properties.add(DoubleProperty('height', height, defaultValue: defaultData.height));
    properties.add(ColorProperty('color', color, defaultValue: defaultData.color));
    properties.add(
      DiagnosticsProperty<ShapeBorder>('shape', shape, defaultValue: defaultData.shape),
    );
  }
}

class SidebarStyleDefaults extends SidebarStyle {
  SidebarStyleDefaults(this.context);
  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  @override
  double? get width => 70;
  @override
  double? get extendedWidth => 150.0;
  @override
  double get verticalSpacing => 8.0;

  @override
  IconThemeData? get selectedIconTheme => IconThemeData(size: 16, color: _colors.primary);
  @override
  IconThemeData? get unselectedIconTheme => IconThemeData(size: 16, color: _colors.onSurfaceVariant);
  @override
  TextStyle? get selectedLabelTextStyle => _textTheme.labelMedium!.copyWith(color: _colors.primary);
  @override
  TextStyle? get unselectedLabelTextStyle => _textTheme.labelMedium!.copyWith(color: _colors.onSurfaceVariant);

  @override
  IndicatorStyle? get indicatorStyle => IndicatorStyle(
        color: _colors.secondaryContainer,
        shape: const StadiumBorder(),
        height: 48,
      );
}
