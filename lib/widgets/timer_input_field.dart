// Packages
import 'package:flutter/material.dart';

class TimerInputField extends StatefulWidget {
  final String leftText;
  final String rightText;
  final VoidCallback onTap;
  const TimerInputField({
    Key? key,
    required this.leftText,
    required this.rightText,
    required this.onTap,
  }) : super(key: key);

  @override
  State<TimerInputField> createState() => _TimerInputFieldState();
}

class _TimerInputFieldState extends State<TimerInputField> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.leftText,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
            const Spacer(),
            Text(
              widget.rightText,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.arrow_back_ios,
              color: Colors.white54,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
