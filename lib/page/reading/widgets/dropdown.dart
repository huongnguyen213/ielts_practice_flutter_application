import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Dropdown extends StatefulWidget {
  final Function(String) onChanged;

  const Dropdown({super.key, required this.onChanged});

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  static const List<String> list = <String>[
    "All",
    "Like",
  ];
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Gap(25),
        Expanded(
          child: Center(
            child: DropdownButton(
              value: dropdownValue,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w200,
                color: Colors.black,
              ),
              icon: const Gap(0),
              underline: Container(
                height: 0,
              ),
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                  widget.onChanged(dropdownValue);
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
