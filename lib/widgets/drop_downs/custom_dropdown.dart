import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.labelText,
    required this.items,
    required this.value,
    required this.onChanged,
    this.color,
    this.withPrefixIcon = false,
  });

  final Color? color;
  final String labelText;
  final String value;
  final List<String> items;
  final Function(String?) onChanged;
  final bool withPrefixIcon;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color ?? CustomColors.primaryWhite,
      child: DropdownButtonFormField(
        value: value,
        dropdownColor: Colors.white,
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: withPrefixIcon
                ? Row(
                    children: [
                      SizedBox(
                        height: 28,
                        width: 28,
                        child: Image.asset(
                          item == '+977'
                              ? 'assets/flag_img/nepal.png'
                              : 'assets/flag_img/india.png',
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      CustomText(text: item),
                    ],
                  )
                : CustomText(text: item),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          fillColor: CustomColors.primaryWhite,
          focusColor: CustomColors.primaryWhite,
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
