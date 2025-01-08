import 'package:flutter/material.dart';
import 'package:prestamos/ui/extensions/build_context_extension.dart';

class CompanyValidation {
  static String? validateName(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.l10n.emptyField;
    }
    return null;
  }

  static String? validateAddress(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.l10n.emptyField;
    }
    return null;
  }

  static String? validatePhone(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.l10n.emptyField;
    }
    return null;
  }
}
