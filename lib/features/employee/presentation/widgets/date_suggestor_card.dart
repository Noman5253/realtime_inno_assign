import 'package:flutter/material.dart';

class DateSuggestionCard extends StatelessWidget {
  const DateSuggestionCard({
    required this.index,
    required this.text,
    required this.onTap,
    required this.bkgColor,
    required this.textColor,
    super.key,
  });

  final int index;
  final String text;
  final int bkgColor;
  final int textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        width: MediaQuery.of(context).size.width / 3,
        decoration: BoxDecoration(
          color: Color(bkgColor),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Color(textColor),
              fontWeight: FontWeight.w400,
              fontSize: 14),
        ),
      ),
    );
  }
}

class DateSuggestor {
  String? text;
  int? index;

  DateSuggestor(this.index, this.text);
}