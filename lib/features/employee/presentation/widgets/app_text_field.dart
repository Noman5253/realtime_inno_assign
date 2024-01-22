import 'package:flutter/material.dart';

import '../../../../resources/app_colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.employeeNameCtrl,
    this.hint,
    this.onTextChanged,
    this.enabled,
    this.readOnly,
    this.radius,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
  });

  final TextEditingController employeeNameCtrl;
  final Function(String)? onTextChanged;
  final bool? enabled;
  final bool? readOnly;
  final double? radius;
  final String? hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: employeeNameCtrl,
      onChanged: onTextChanged ?? (t) {},
      decoration: InputDecoration(
          enabled: enabled ?? true,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? 4.0),
              borderSide: BorderSide(color: Colors.grey.shade300)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? 4.0),
              borderSide: BorderSide(color: Colors.grey.shade300)),
          hintText: hint ?? "",
          hintStyle: const TextStyle(
              color: AppColors.lightGray,
              fontWeight: FontWeight.w400,
              fontSize: 16),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: AppColors.blueColor,
                )
              : null,
          suffixIcon: suffixIcon != null
              ? Icon(
                  suffixIcon,
                  color: AppColors.blueColor,
                )
              : null),
      enabled: enabled,
      readOnly: readOnly ?? false,
      onTap: onTap,
    );
  }
}
