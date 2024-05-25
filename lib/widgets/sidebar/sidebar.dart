import 'package:flutter/material.dart';
import 'package:labcure/widgets/sidebar/sidebar_style.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({
    super.key,
    this.leading,
    this.trailing,
    required this.destinations,
    required this.selectedDestination,
    this.onDestinationSelected,
    this.style,
    this.extended = false,
  }) : assert(destinations.length >= 2);

  final Widget? leading;
  final Widget? trailing;
  final List<SidebarDestination> destinations;
  final int? selectedDestination;
  final ValueChanged<int>? onDestinationSelected;
  final SidebarStyle? style;
  final bool extended;

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    SidebarStyle defaults = SidebarStyleDefaults(context);

    double width = widget.style?.width ?? defaults.width!;
    double extendedWidth = widget.style?.extendedWidth ?? defaults.extendedWidth!;
    double verticalSpacing = widget.style?.verticalSpacing ?? defaults.verticalSpacing!;
    Color? backgroundColor = widget.style?.backgroundColor;
    IndicatorStyle indicatorStyle = widget.style?.indicatorStyle ?? defaults.indicatorStyle!;
    IconThemeData selectedIconTheme = widget.style?.selectedIconTheme ?? defaults.selectedIconTheme!;
    IconThemeData unselectedIconTheme = widget.style?.unselectedIconTheme ?? defaults.unselectedIconTheme!;
    TextStyle selectedLabelTextStyle = widget.style?.selectedLabelTextStyle ?? defaults.selectedLabelTextStyle!;
    TextStyle unselectedLabelTextStyle = widget.style?.unselectedLabelTextStyle ?? defaults.unselectedLabelTextStyle!;

    return Material(
      color: backgroundColor,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: verticalSpacing),
        constraints: BoxConstraints.tightFor(width: widget.extended ? extendedWidth : width),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.leading != null) widget.leading!,
            Expanded(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                itemCount: widget.destinations.length,
                itemBuilder: (context, index) {
                  return _SidebarDestination(
                    onPressed: () {
                      if (widget.onDestinationSelected != null) {
                        widget.onDestinationSelected!(index);
                      }
                    },
                    icon: widget.destinations[index].icon,
                    label: widget.destinations[index].label,
                    selected: widget.selectedDestination == index,
                    extended: widget.extended,
                    indicatorStyle: indicatorStyle,
                    selectedIconTheme: selectedIconTheme,
                    unselectedIconTheme: unselectedIconTheme,
                    selectedLabelTextStyle: selectedLabelTextStyle,
                    unselectedLabelTextStyle: unselectedLabelTextStyle,
                  );
                },
              ),
            ),
            if (widget.trailing != null) widget.trailing!,
          ],
        ),
      ),
    );
  }
}

class _SidebarDestination extends StatelessWidget {
  const _SidebarDestination({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.selected,
    required this.extended,
    required this.selectedIconTheme,
    required this.unselectedIconTheme,
    required this.selectedLabelTextStyle,
    required this.unselectedLabelTextStyle,
    required this.indicatorStyle,
  });
  final VoidCallback onPressed;
  final Widget icon;
  final Widget label;
  final bool selected;
  final bool extended;
  final TextStyle selectedLabelTextStyle;
  final TextStyle unselectedLabelTextStyle;
  final IconThemeData selectedIconTheme;
  final IconThemeData unselectedIconTheme;
  final IndicatorStyle indicatorStyle;

  @override
  Widget build(BuildContext context) {
    Widget themeIcon = IconTheme(data: selected ? selectedIconTheme : unselectedIconTheme, child: icon);
    Widget styleLabel = DefaultTextStyle(
      style: selected ? selectedLabelTextStyle : unselectedLabelTextStyle,
      child: label,
    );
    IndicatorStyle defaults = SidebarStyleDefaults(context).indicatorStyle!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: MaterialButton(
        onPressed: onPressed,
        color: selected ? indicatorStyle.color ?? defaults.color : null,
        shape: indicatorStyle.shape ?? defaults.shape,
        elevation: 0,
        hoverElevation: 0,
        height: indicatorStyle.height ?? defaults.height,
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Visibility(
          visible: extended,
          replacement: themeIcon,
          child: Row(children: [themeIcon, const SizedBox(width: 10.0), styleLabel]),
        ),
      ),
    );
  }
}

class SidebarDestination {
  const SidebarDestination({
    required this.icon,
    required this.label,
    this.trailing,
  });

  final Widget icon;
  final Widget label;
  final Widget? trailing;
}
