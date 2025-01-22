import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:prestamos/ui/loan/bloc/loan_bloc.dart';
import 'package:prestamos/ui/loan/bloc/loan_event.dart';
import 'package:prestamos/ui/loan/bloc/loan_state.dart';
import 'package:prestamos/ui/widgets/validators/loan_validator.dart';
import 'package:prestamos/ui/extensions/build_context_extension.dart';
import '../../widgets/utils/snack_bar_top.dart';
import '../../widgets/utils/loan_calculator.dart';

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

  void _confirmLoan() async {
    final amountError =
        LoanValidation.validateAmount(_amountController.text, context);
    final interestError = LoanValidation.validateInterestRate(
        interestRateController.text, context);
    final installmentsError = LoanValidation.validateInstallments(
        numberOfInstallments.toString(), context);
    final paymentFrequencyError =
        LoanValidation.validatePaymentFrequency(paymentFrequency, context);

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

    // Usar el BLoC para agregar el préstamo

    final loanBloc = context.read<LoanBloc>();

    loanBloc.add(AddLoan(
      widget.clientName,
      double.parse(_amountController.text),
      double.parse(interestRateController.text),
      numberOfInstallments,
      paymentFrequency,
    ));
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
      body: BlocListener<LoanBloc, LoanState>(
        listener: (context, state) {
          if (state is LoanSuccess) {
            _showSnackBar(state.message);

            context.pop();
          } else if (state is LoanError) {
            _showSnackBar(state.message);
          }
        },
        child: Center(
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
                            amountError =
                                LoanValidation.validateAmount(value, context);
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
                            interestError = LoanValidation.validateInterestRate(
                                value, context);
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
                                LoanValidation.validatePaymentFrequency(
                                    paymentFrequency, context);
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
                              installmentsError =
                                  LoanValidation.validateInstallments(
                                      value, context);
                            }
                          });
                          calculateInstallment();
                        },
                      ),
                      const SizedBox(height: 16),
                      if (totalToPay != null) ...[
                        Text(
                            '${'${context.l10n.totalToPay}:  '}${formatCurrency(totalToPay)}'),
                        Text(
                            '${'${context.l10n.amountPerInstallment}:  '}${formatCurrency(amountToPayPerInstallment)}'),
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
                            onPressed: () {
                              context.pop();
                            },
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
      ),
    );
  }
}
