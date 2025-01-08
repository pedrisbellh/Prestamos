import 'package:flutter/material.dart';
import 'package:prestamos/ui/extensions/build_context_extension.dart';

class LoanValidation {
  static String? validateAmount(String? value, BuildContext context) {
    final amount = double.tryParse(value ?? '');
    if (amount == null) {
      return context.l10n.emptyField;
    } else if (amount <= 1) {
      return context.l10n.invalidAmount;
    }
    return null;
  }

  static String? validateInterestRate(String? value, BuildContext context) {
    final interest = double.tryParse(value ?? '');
    if (interest == null) {
      return context.l10n.emptyField;
    } else if (interest <= 1) {
      return context.l10n.invalidAmount;
    }
    return null;
  }

  static String? validatePaymentFrequency(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.l10n.emptyField;
    }
    return null;
  }

  static String? validateInstallments(String? value, BuildContext context) {
    final installments = int.tryParse(value ?? '');
    if (installments == null) {
      return context.l10n.emptyField;
    } else if (installments <= 1) {
      return context.l10n.invalidAmount;
    }
    return null;
  }
}
