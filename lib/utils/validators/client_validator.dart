import 'package:flutter/material.dart';
import 'package:prestamos/extensions/build_context_extension.dart';

class ClientValidation {
  static String? validateName(String? value, BuildContext context) {
    if (value == null || value.trim().split(' ').length < 3) {
      return context.l10n.fullName;
    }
    return null;
  }

  static String? validatePhone(String? value, BuildContext context) {
    final phoneRegex = RegExp(r'^\+?[0-9]{8,15}$');
    if (value == null || !phoneRegex.hasMatch(value)) {
      return context.l10n.wrongPhone;
    }
    return null;
  }

  static String? validateIdentityCard(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.l10n.emptyField;
    } else if (value.length < 8) {
      return context.l10n.invalidId;
    }
    return null;
  }
}
