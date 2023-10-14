import 'package:flutter/material.dart';

Widget CustomTextField({
  required TextEditingController? controller,
  ValueChanged<String>? submit,
  required TextInputType? keyboardType,
  required FormFieldValidator<String>? validator,
  required String label,
  required String hintText,
  required IconData prefixIcon,
   lines,
  GestureTapCallback? onTap,
}) => TextFormField(
  maxLines: lines,
  onTap:onTap,
  controller: controller,
  keyboardType: keyboardType,
  onFieldSubmitted: submit,
  validator: validator,
  decoration: InputDecoration(
    labelText: label,
    prefixIcon:Icon(prefixIcon),
    hintText: hintText,
    isDense: true,
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
  ),
);