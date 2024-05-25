import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:labcure/config/styles/borders.dart';
import 'package:labcure/config/styles/constants.dart';
import 'package:labcure/widgets/months.dart';

class Initials extends StatelessWidget {
  const Initials({
    super.key,
    required this.focusNodes,
    required this.controllers,
  });
  final List<FocusNode> focusNodes;
  final List<TextEditingController> controllers;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Flexible(
              child: DropdownButtonFormField(
                autofocus: controllers[0].text.isEmpty ? true : false,
                focusNode: focusNodes[0],
                value: controllers[0].text.isEmpty ? null : controllers[0].text,
                borderRadius: Borders.borderRadius,
                focusColor: Colors.transparent,
                style: textTheme.bodySmall,
                onChanged: (item) {
                  controllers[0].text = item!;
                  FocusScope.of(context).nextFocus();
                },
                decoration: const InputDecoration(labelText: 'Title'),
                items: const [
                  DropdownMenuItem(value: 'Mr.', child: Text('Mr')),
                  DropdownMenuItem(value: 'Mrs.', child: Text('Mrs')),
                  DropdownMenuItem(value: 'Ms.', child: Text('Ms')),
                ],
              ),
            ),
            const Gap(gap),
            Flexible(
              child: TextField(
                focusNode: focusNodes[1],
                controller: controllers[1],
                style: textTheme.bodySmall,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
            ),
          ],
        ),
        const Gap(padding),
        Row(
          children: [
            Flexible(
              child: TextField(
                focusNode: focusNodes[2],
                controller: controllers[2],
                onSubmitted: (value) {
                  if (value.isEmpty) {
                    controllers[2].text = '01';
                    return;
                  }
                  int day = int.parse(value);
                  if (day < 10) controllers[2].text = '0$value';
                },
                textInputAction: TextInputAction.next,
                style: textTheme.bodySmall,
                decoration: const InputDecoration(labelText: 'Day'),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
              ),
            ),
            const Gap(gap),
            Flexible(
              child: Months(
                focusNode: focusNodes[3],
                value: controllers[3].text.isEmpty ? null : controllers[3].text,
                onChanged: (item) {
                  controllers[3].text = item!;
                  FocusScope.of(context).nextFocus();
                },
                textTheme: textTheme,
              ),
            ),
            const Gap(gap),
            Flexible(
              child: TextField(
                focusNode: focusNodes[4],
                controller: controllers[4],
                textInputAction: TextInputAction.next,
                style: textTheme.bodySmall,
                decoration: const InputDecoration(labelText: 'Year'),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
              ),
            ),
          ],
        ),
        const Gap(padding),
        DropdownButtonFormField<String>(
          focusNode: focusNodes[5],
          value: controllers[5].text.isEmpty ? null : controllers[5].text,
          borderRadius: Borders.borderRadius,
          focusColor: Colors.transparent,
          style: textTheme.bodySmall,
          items: const [
            DropdownMenuItem(value: 'Male', child: Text('Male')),
            DropdownMenuItem(value: 'Female', child: Text('Female')),
          ],
          decoration: const InputDecoration(labelText: 'Gender'),
          onChanged: (item) {
            controllers[5].text = item!;
            FocusScope.of(context).nextFocus();
          },
        ),
      ],
    );
  }
}
