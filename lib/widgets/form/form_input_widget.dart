import 'package:flutter/material.dart';

class FormInputWidget extends StatelessWidget {
  final String inputType;
  final String? labelText;
  final String? hintText;
  final dynamic value;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  Map<String, Widget Function(BuildContext, bool)> get _fieldsMap => {
    "text": _buildTextField,
    "email": _buildTextField,
    "password": _buildTextField,
    "number": _buildTextField,
  };
  const FormInputWidget({
    super.key,
    this.inputType = "text",
    required this.labelText,
    required this.hintText,
    this.value,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    final fieldBuilder = _fieldsMap[inputType] ?? _buildTextField;
    return fieldBuilder(context, isDarkMode);
  }

  Widget _buildTextField(BuildContext context, bool isDarkMode) {
    final isEmail = inputType == "email";
    final isPassword = inputType == "password";

    return SizedBox(
      height: 50,
      child: TextFormField(
        obscureText: isPassword,
        keyboardType: () {
          if (isEmail) {
            return TextInputType.emailAddress;
          } else if (inputType == "number") {
            return TextInputType.number;
          }
          return TextInputType.text;
        }(),
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          fontWeight: FontWeight.normal,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          labelStyle: TextStyle(fontWeight: FontWeight.normal),
        ).copyWith(
          // change the color of bottom border
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color:
                  isDarkMode
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.tertiary,
            ),
          ),
          fillColor:
              isDarkMode
                  ? Theme.of(context).colorScheme.secondary.withAlpha(30)
                  : Theme.of(context).colorScheme.secondary.withAlpha(120),
          filled: true,
        ),
        onChanged: (value) {
          if (onChanged != null) {
            onChanged!(value);
          }
        },
        validator: (value) {
          if (validator != null) {
            return validator!(value);
          }
          return null;
        },
      ),
    );
  }
}
