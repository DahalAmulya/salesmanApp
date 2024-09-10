import 'package:flutter/material.dart';

class TextFromFieldWithPrefixSuffix extends StatelessWidget {
  const TextFromFieldWithPrefixSuffix({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
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
    this.readOnly = false,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool obscure;
  final bool applyPrefix;
  final Widget? prefixIcon;
  final bool applySuffixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final double borderRadius;
  final String? Function(String?) validator;
  final bool autoFocus;
  final bool readOnly;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscure,
      validator: validator,
      autofocus: autoFocus,
      readOnly: readOnly,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTapOutside: (event) {
        print('onTapOutside');
        FocusManager.instance.primaryFocus?.unfocus();
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor ?? Color(0xfff3f3f3),
        focusColor: Colors.blue,
        labelText: labelText ?? null,
        hintText: hintText ?? null,
        prefixIcon: applyPrefix ? prefixIcon : null,
        suffixIcon: applySuffixIcon ? suffixIcon : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}