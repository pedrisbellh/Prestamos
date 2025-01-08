import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:prestamos/ui/extensions/build_context_extension.dart';
import '../../../data/utils/snack_bar_top.dart';
import '../../../data/utils/loan_calculator.dart';
import '../../../data/services/firebase_service.dart';

class CreateLoanScreen extends StatefulWidget {
  final String clientName;

  const CreateLoanScreen({super.key, required this.clientName});

  @override
  CreateLoanScreenState createState() => CreateLoanScreenState();
}

class CreateLoanScreenState extends State<CreateLoanScreen> {
  late TextEditingController _amountController;
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController interestRateController = TextEditingController();

  String paymentFrequency = '';
  double? amountToPayPerInstallment;
  double? totalToPay;
  double? interesRate;
  int numberOfInstallments =
      1; // Inicializado en 1 para evitar división por cero
  String? amountError;
  String? interestError;
  String? installmentsError;
  String? paymentFrequencyError;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    clientNameController.text = widget.clientName;
  }

  @override
  void dispose() {
    _amountController.dispose();
    clientNameController.dispose();
    interestRateController.dispose();
    super.dispose();
  }

  void calculateInstallment() {
    final double amount = double.tryParse(_amountController.text) ?? 0;
    final double interest = double.tryParse(interestRateController.text) ?? 1;

    if (amount > 0 && interest >= 0 && numberOfInstallments > 1) {
      setState(() {
        totalToPay = LoanCalculator.calculateTotalToPay(amount, interest);
        amountToPayPerInstallment =
            LoanCalculator.calculateAmountPerInstallment(
                totalToPay!, numberOfInstallments);
      });
    }
  }

  void _showSnackBar(String message) {
    SnackBarTop.showTopSnackBar(context, message);
  }

  String? _validateAmount(String? value) {
    final amount = double.tryParse(value ?? '');
    if (amount == null) {
      return context.l10n.emptyField;
    } else if (amount <= 1) {
      return context.l10n.invalidAmount;
    }
    return null;
  }

  String? _validateInterestRate(String? value) {
    final interest = double.tryParse(value ?? '');
    if (interest == null) {
      return context.l10n.emptyField;
    } else if (interest <= 1) {
      return context.l10n.invalidAmount;
    }
    return null;
  }

  String? _validatePaymentFrequency(String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.emptyField;
    }
    return null;
  }

  String? _validateInstallments(String? value) {
    final installments = int.tryParse(value ?? '');
    if (installments == null) {
      return context.l10n.emptyField;
    } else if (installments <= 1) {
      return context.l10n.invalidAmount;
    }
    return null;
  }

  void _cancelLoan() {
    context.go('/');
  }

  void _confirmLoan() async {
    final amountError = _validateAmount(_amountController.text);
    final interestError = _validateInterestRate(interestRateController.text);
    final installmentsError =
        _validateInstallments(numberOfInstallments.toString());
    final paymentFrequencyError = _validatePaymentFrequency(paymentFrequency);

    setState(() {
      this.amountError = amountError;
      this.interestError = interestError;
      this.installmentsError = installmentsError;
      this.paymentFrequencyError = paymentFrequencyError;
    });

    if (amountError != null ||
        interestError != null ||
        installmentsError != null ||
        paymentFrequencyError != null) {
      return;
    }

    try {
      String loanId = await saveLoanToFirestore(
        clientName: widget.clientName,
        userId: FirebaseAuth.instance.currentUser!.uid,
        amount: double.parse(_amountController.text),
        interestRate: double.parse(interestRateController.text),
        numberOfInstallments: numberOfInstallments,
        paymentFrequency: paymentFrequency,
        cuotasRestantes: numberOfInstallments,
        completado: false,
        renovado: false,
      );

      _showSnackBar(context.l10n.createdLoan);

      context.go('/viewLoan/$loanId');
    } catch (e) {
      _showSnackBar(context.l10n.error);
    }
  }

  String formatCurrency(double? value) {
    if (value == null) return '';
    final formatter = NumberFormat.simpleCurrency(locale: 'es_ES');
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.createLoan),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: clientNameController,
                      decoration: InputDecoration(
                        labelText: context.l10n.fullName,
                        border: const OutlineInputBorder(),
                      ),
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: context.l10n.amount,
                        border: const OutlineInputBorder(),
                        errorText: amountError,
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        calculateInstallment();
                        setState(() {
                          amountError = _validateAmount(value);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: interestRateController,
                      decoration: InputDecoration(
                        labelText: context.l10n.interest,
                        border: const OutlineInputBorder(),
                        errorText: interestError,
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        calculateInstallment();
                        setState(() {
                          interestError = _validateInterestRate(value);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: paymentFrequency,
                      decoration: InputDecoration(
                        labelText: context.l10n.frecuency,
                        border: const OutlineInputBorder(),
                        errorText: paymentFrequencyError,
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      items: <String>[
                        '',
                        context.l10n.daily,
                        context.l10n.weekly,
                        context.l10n.biweekly,
                        context.l10n.monthly,
                        context.l10n.yearly
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.isEmpty ? '' : value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          paymentFrequency = newValue!;
                          paymentFrequencyError =
                              _validatePaymentFrequency(paymentFrequency);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: context.l10n.cantCuotes,
                        border: const OutlineInputBorder(),
                        errorText: installmentsError,
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        int? installments = int.tryParse(value);
                        setState(() {
                          if (installments != null && installments > 1) {
                            numberOfInstallments = installments;
                            installmentsError = null;
                          } else {
                            installmentsError = _validateInstallments(value);
                          }
                        });
                        calculateInstallment();
                      },
                    ),
                    const SizedBox(height: 16),
                    if (totalToPay != null) ...[
                      Text(
                          '${context.l10n.totalToPay}${formatCurrency(totalToPay)}'),
                      Text(
                          '${context.l10n.amountPerInstallment}${formatCurrency(amountToPayPerInstallment)}'),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _confirmLoan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(context.l10n.acept),
                        ),
                        const SizedBox(width: 40),
                        ElevatedButton(
                          onPressed: _cancelLoan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(context.l10n.cancel),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
