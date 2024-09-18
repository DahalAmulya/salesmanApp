import 'package:deskgoo/themes/custom_colors.dart';
import 'package:flutter/material.dart';

class TextFromFieldWithPrefixSuffix extends StatelessWidget {
  const TextFromFieldWithPrefixSuffix({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
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
    this.minLine = 1,
    this.maxLines = 1,
    this.onChange,
    this.onTap,
  });

  final TextEditingController controller;
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
  final int minLine;
  final int maxLines;
  final Function(String?)? onChange;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscure,
      validator: validator,
      autofocus: autoFocus,
      readOnly: readOnly,
      minLines: minLine,
      maxLines: maxLines,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onTap: onTap,
      onChanged: onChange,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor ?? CustomColors.primaryWhite,
        focusColor: CustomColors.primaryWhite,
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
