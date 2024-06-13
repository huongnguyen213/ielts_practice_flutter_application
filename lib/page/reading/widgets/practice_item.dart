import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../pages/reading_choose_condition_page.dart';
import '../pages/reading_page.dart';
import 'linear_point.dart';

class PracticeItem extends StatefulWidget {
  const PracticeItem({super.key, required this.item});

  final PracticeTest item;

  @override
  State<PracticeItem> createState() => _PracticeItemState();
}

class _PracticeItemState extends State<PracticeItem> {
  @override
  void initState() {
    check = widget.item.star;
    super.initState();
  }

  late bool check;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => const ReadingChooseConditionPage()),
        );
      },
      minSize: 0,
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            width: 1,
            color: const Color(0xff80B7C3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const Gap(10),
                  LinearPoint(point: widget.item.point),
                  const Gap(12),
                  Text(
                    "Score: ${widget.item.point}/13",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(8),
            CupertinoButton(
              onPressed: () {
                setState(() {
                  check = !check;
                });
              },
              minSize: 0,
              padding: EdgeInsets.zero,
              child: check
                  ? Image.asset(
                "assets/images/img_star.png",
                width: 30,
                height: 30,
              )
                  : const SizedBox(
                width: 30,
                height: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
