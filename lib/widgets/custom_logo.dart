import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget {
  const CustomLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: const [
          Image(
            image: AssetImage('assets/images/tag-logo.png'),
            fit: BoxFit.contain,
            width: 200,
          ),
          SizedBox(height: 20),
          Text(
            'Messages App',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
