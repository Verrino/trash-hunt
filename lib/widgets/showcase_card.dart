import 'package:flutter/material.dart';

class ShowcaseCard extends StatelessWidget {
  final String title;
  final String value;
  const ShowcaseCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 110,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(value),
          ],
        ),
      ),
    );
  }
}