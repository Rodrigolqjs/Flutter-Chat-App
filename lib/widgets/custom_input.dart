import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String title;
  final IconData iconData;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool obscureText;

  const CustomInput(
      {super.key,
      required this.title,
      required this.iconData,
      required this.textController,
      required this.keyboardType,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.09),
              offset: const Offset(0, 5),
              blurRadius: 5)
        ],
      ),
      child: TextFormField(
        controller: textController,
        autocorrect: false,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: _inputDecoration(title, iconData),
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText, IconData iconData) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(iconData),
      focusedBorder: InputBorder.none,
      border: InputBorder.none,
    );
  }
}
