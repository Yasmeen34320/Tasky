import 'package:flutter/material.dart';
import 'package:tasky/theme/theme_controller.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    required this.title,
    required this.hintText,
    this.maxLines,
    required this.controller,
    this.validator,
  });
  String title, hintText;
  int? maxLines;
  TextEditingController controller;
  final Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //  'Full Name'
        Text(
          title,
          style: Theme.of(context).textTheme.displaySmall,
          textAlign: TextAlign.left,
        ),

        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(
            color: ThemeController.isDark() ? Colors.white : Colors.black,
          ),
          cursorColor: Colors.white,
          decoration: InputDecoration(hintText: hintText),
          validator: validator != null
              ? (String? value) => validator!(value)
              : null,
        ),
      ],
    );
  }
}
