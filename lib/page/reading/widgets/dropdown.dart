import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Dropdown extends StatefulWidget {
  final Function(String) onChanged;

  const Dropdown({super.key, required this.onChanged});

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  // Danh sách các giá trị trong Dropdown
  static const List<String> list = <String>[
    "All",
    "Like",
  ];
  // Giá trị được chọn mặc định là phần tử đầu tiên trong danh sách
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Gap(25),
        Expanded(
          child: Center(

            // DropdownButton để hiển thị danh sách lựa chọn
            child: DropdownButton(
              value: dropdownValue, // Giá trị hiện tại của dropdown
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w200,
                color: Colors.black,
              ),
              icon: const Gap(0),  // Không hiển thị biểu tượng mũi tên mặc định
              underline: Container(
                height: 0,  // Không hiển thị đường gạch dưới mặc định
              ),
              onChanged: (String? value) {  // Hàm callback khi giá trị thay đổi
                setState(() {
                  dropdownValue = value!; // Cập nhật giá trị được chọn
                  widget.onChanged(dropdownValue);  // Gọi hàm callback onChanged
                });
              },
              items: list.map<DropdownMenuItem<String>>(  // Tạo danh sách các mục Dropdown
                (value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value), // Hiển thị văn bản của từng mục
                  );
                },
              ).toList(),
            ),
          ),
        ),
        Image.asset(
          "assets/images/img_expand_arrow.png", // Hiển thị biểu tượng mũi tên tùy chỉnh
          width: 25,
          height: 25,
        ),
      ],
    );
  }
}
