import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:prestamos/screens/view_loan_screen.dart';
import '../utils/snack_bar_top.dart';
import '../utils/loan_calculator.dart';
import '/services/firebase_service.dart'; 

class SecondScreen extends StatefulWidget {
  final String clientName;

  const SecondScreen({super.key, required this.clientName});

  @override
  SecondScreenState createState() => SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  late TextEditingController _amountController;
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController interestRateController = TextEditingController();

  String paymentFrequency = 'Mensual';
  double? amountToPayPerInstallment;
  double? totalToPay;
  double? interesRate;
  int numberOfInstallments = 1; // Cambiado a 1 para evitar división por cero
  String? amountError;
  String? interestError;
  String? installmentsError;

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
        amountToPayPerInstallment = LoanCalculator.calculateAmountPerInstallment(totalToPay!, numberOfInstallments);
      });
    }
  }

  // Método para mostrar SnackBar
  void _showSnackBar(String message) {
      SnackBarTop.showTopSnackBar(context, message);
    }

  // Método para navegar a la pantalla de detalles del préstamo
  void _navigateToLoanDetails(String loanId) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ViewLoanScreen(
            loanId: loanId, // Pasa el ID del préstamo aquí
          ),
        ),
      );
    }

  String? _validateAmount(String? value) {
    final amount = double.tryParse(value ?? '');
    if (amount == null || amount <= 0) {
      return 'El monto debe ser mayor que cero.';
    }
    return null;
  }

  String? _validateInterestRate(String? value) {
    final interest = double.tryParse(value ?? '');
    if (interest == null || interest <= 0) {
      return 'La tasa de interés debe ser mayor que cero.';
    }
    return null;
  }

  String? _validateInstallments(String? value) {
    final installments = int.tryParse(value ?? '');
    if (installments == null || installments <= 1) {
      return 'El número de cuotas debe ser mayor que uno.';
    }
    return null;
  }

  void cancelLoan() {
    Navigator.pop(context);
  }

  void confirmLoan() async {
    final amountError = _validateAmount(_amountController.text);
    final interestError = _validateInterestRate(interestRateController.text);
    final installmentsError = _validateInstallments(numberOfInstallments.toString());

    setState(() {
      this.amountError = amountError;
      this.interestError = interestError;
      this.installmentsError = installmentsError;
    });

    if (amountError != null || interestError != null || installmentsError != null) {
      return; // No continuar si hay errores
    }

    // Guardar el préstamo en Firestore
    try {
      // Guarda el préstamo y obtén el ID
      String loanId = await saveLoanToFirestore(
        clientName: widget.clientName,
        userId: FirebaseAuth.instance.currentUser !.uid, // Obtener el userId del usuario actual
        amount: double.parse(_amountController.text),
        interestRate: double.parse(interestRateController.text),
        numberOfInstallments: numberOfInstallments,
        paymentFrequency: paymentFrequency,
        cuotasRestantes: numberOfInstallments,
        completado: false,
        renovado: false,
      );

      _showSnackBar('Préstamo creado con éxito');

      // Navegar a la pantalla de detalles del préstamo
      _navigateToLoanDetails(loanId);
    } catch (e) {
      _showSnackBar('Error al crear el préstamo: $e');
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
        title: const Text('Crear Préstamo'),
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
                borderRadius: BorderRadius.circular(12), // Bordes redondeados
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: clientNameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del Cliente',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: 'Monto a prestar',
                        border: const OutlineInputBorder(),
                        errorText: amountError, // Muestra el mensaje de error aquí
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
                        labelText: 'Tasa de Interés (%)',
                        border: const OutlineInputBorder(),
                        errorText: interestError, // Muestra el mensaje de error aquí
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
                      decoration: const InputDecoration(
                        labelText: 'Frecuencia de Pago',
                        border: OutlineInputBorder(),
                      ),
                      items: <String>['Diario', 'Semanal', 'Quincenal', 'Mensual', 'Anual']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          paymentFrequency = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Número de Cuotas',
                        border: const OutlineInputBorder(),
                        errorText: installmentsError, // Muestra el mensaje de error aquí
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
                            installmentsError = null; // Limpiar error si es válido
                          } else {
                            installmentsError = _validateInstallments(value);
                          }
                        });
                          calculateInstallment();
                      },
                    ),
                    const SizedBox(height: 16),
                    if (totalToPay != null) ...[
                      Text('Total a pagar: ${formatCurrency(totalToPay)}'),
                      Text('Monto por cuota: ${formatCurrency(amountToPayPerInstallment)}'),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: confirmLoan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal, // Cambiar color a teal
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Aceptar'),
                        ),
                        const SizedBox(width: 40),
                        ElevatedButton(
                          onPressed: cancelLoan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Cancelar'),
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