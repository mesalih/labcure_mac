import 'package:flutter/material.dart';
import 'package:labcure/config/styles/borders.dart';

class Months extends StatelessWidget {
  const Months({super.key, this.focusNode, this.value, this.onChanged, required this.textTheme});
  final FocusNode? focusNode;
  final String? value;
  final void Function(String? item)? onChanged;
  final TextTheme textTheme;

  static final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      focusNode: focusNode,
      value: value,
      borderRadius: Borders.borderRadius,
      focusColor: Colors.transparent,
      style: textTheme.bodySmall,
      items: List.generate(
        _months.length,
        (index) => DropdownMenuItem(
          value: (index < 9 ? '0${index + 1}' : index + 1).toString(),
          child: Text(_months[index]),
        ),
      ),
      onChanged: onChanged,
      decoration: const InputDecoration(label: Text('Month')),
    );
  }
}
