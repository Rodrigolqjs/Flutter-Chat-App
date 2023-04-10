import 'package:flutter/material.dart';

class CustomTexts extends StatelessWidget {
  final String text1;
  final String text2;
  final String routeName;
  const CustomTexts({
    super.key,
    required this.routeName,
    required this.text1,
    required this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Text(text1),
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, routeName);
            },
            child: Text(
              text2,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 40),
          const Text('Terms & Conditions'),
        ],
      ),
    );
  }
}
