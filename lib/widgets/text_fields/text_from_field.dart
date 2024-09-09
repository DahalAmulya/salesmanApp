import 'package:flutter/material.dart';

class TextFromFieldWithPrefixSuffix extends StatelessWidget {
  const TextFromFieldWithPrefixSuffix({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    required this.validator,
    this.keyboardType = TextInputType.text,
    this.obscure = false,
    this.applyPrefix = true,
    this.applySuffixIcon = false,
    this.suffixIcon,
    this.fillColor,
    this.borderRadius = 8.0,
    this.autoFocus = false,
  });

  final TextEditingController controller;
  final String hintText;
  final bool obscure;
  final bool applyPrefix;
  final Widget prefixIcon;
  final bool applySuffixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final double borderRadius;
  final String? Function(String?) validator;
  final bool autoFocus;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscure,
      validator: validator,
      autofocus: autoFocus,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTapOutside: (event) {
        print('onTapOutside');
        FocusManager.instance.primaryFocus?.unfocus();
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor ?? Color(0xfff3f3f3),
        focusColor: Colors.blue,
        hintText: hintText,
        prefixIcon: applyPrefix ? prefixIcon : null,
        suffixIcon: applySuffixIcon ? suffixIcon : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
