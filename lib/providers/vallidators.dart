import 'package:flutter/material.dart';

abstract class Validation<T> {
  const Validation();

  String? validate(BuildContext context, T? value);
}

class Validator {
  Validator._();

  static FormFieldValidator<T> apply<T>(
    BuildContext context,
    List<Validation<T>> validations,
  ) {
    return (T? value) {
      for (final validation in validations) {
        final errorMessage = validation.validate(context, value);
        if (errorMessage != null) {
          return errorMessage;
        }
      }
      return null;
    };
  }
}

class RequiredValidation<T> extends Validation<T> {
  const RequiredValidation();

  @override
  String? validate(BuildContext context, T? value) {
    if (value is String && (value as String).isEmpty) {
      return 'This field is required';
    }
    return null;
  }
}

class EmailValidation extends Validation<String> {
  const EmailValidation();

  @override
  String? validate(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Invalid email address';
    }
    return null;
  }
}

class PasswordValidation extends Validation<String> {
  final int minLength;
  final bool numbers;
  final bool uppercase;
  final bool lowercase;
  final bool specialCharacters;
  const PasswordValidation({
    this.minLength = 8,
    this.numbers = true,
    this.uppercase = false,
    this.lowercase = true,
    this.specialCharacters = false,
  });

  @override
  String? validate(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters long';
    }
    if (numbers && !RegExp(r'\d').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (uppercase && !RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (lowercase && !RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (specialCharacters && !RegExp(r'[@$!%*?&]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }
}

class DropDownValidation<T> extends Validation<T> {
  final List<T> validValues;
  const DropDownValidation(this.validValues);

  @override
  String? validate(BuildContext context, T? value) {
    if (value == null || !validValues.contains(value)) {
      return 'Please select a valid option';
    }
    return null;
  }
}
