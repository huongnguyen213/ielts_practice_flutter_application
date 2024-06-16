import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TimeDropdown extends StatefulWidget {
  const TimeDropdown({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  State<TimeDropdown> createState() => _DropdownState();
}

class _DropdownState extends State<TimeDropdown> {
  static const List<String> list = <String>[
    "Standard",
    '10',
    '15',
    '20',
    '25',
    '30',
    '35',
    '40'
  ];
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Gap(25),
        Expanded(
          child: DropdownButton(
            value: dropdownValue,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
            icon: const Gap(0),
            underline: Container(
              height: 0,
            ),
            onChanged: (String? value) {
              setState(() {
                dropdownValue = value!;
                widget.onChanged(value);
              });
            },
            items: list.map<DropdownMenuItem<String>>(
              (value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              },
            ).toList(),
          ),
        ),
        Image.asset(
          "assets/images/img_expand_arrow.png",
          width: 25,
          height: 25,
        ),
      ],
    );
  }
}
