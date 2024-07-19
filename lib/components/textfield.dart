import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final String? errorMsg;
  final String? Function(String?)? onChanged;
  final String label;
  final bool? enabled;
  final bool? maxLinesEnabled;
  final bool? minLinesEnabled;
  final int? maxCharacters;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.keyboardType,
    this.suffixIcon,
    this.onTap,
    this.prefixIcon,
    this.validator,
    this.focusNode,
    this.errorMsg,
    this.onChanged,
    this.enabled,
    required this.label,
    this.maxLinesEnabled,
    this.minLinesEnabled,
    this.maxCharacters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            label,
            style: TextStyle(
                fontSize: 16,
                //fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground),
          ),
        ),
        TextFormField(
          maxLines: maxLinesEnabled == true ? null : 1,
          minLines: minLinesEnabled == true ? 8 : null,
          maxLength: maxCharacters,
          maxLengthEnforcement: maxCharacters != null
              ? MaxLengthEnforcement.enforced
              : MaxLengthEnforcement.none,
          enabled: enabled,
          buildCounter: maxCharacters != null
              ? (BuildContext context,
                  {int? currentLength, int? maxLength, bool? isFocused}) {
                  return Text(
                    '$currentLength/$maxLength',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  );
                }
              : null,
          validator: validator,
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          focusNode: focusNode,
          onTap: onTap,
          textInputAction: TextInputAction.next,
          onChanged: onChanged,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.secondary),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500]),
            errorText: errorMsg,
          ),
        ),
      ],
    );
  }
}
