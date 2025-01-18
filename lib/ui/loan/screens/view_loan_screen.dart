import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:prestamos/ui/extensions/build_context_extension.dart';
import '../../widgets/utils/snack_bar_top.dart';
import 'package:intl/intl.dart';

class ViewLoanScreen extends StatefulWidget {
  final String loanId;

  const ViewLoanScreen({
    super.key,
    required this.loanId,
  });

  @override
  ViewLoanScreenState createState() => ViewLoanScreenState();
}

class ViewLoanScreenState extends State<ViewLoanScreen> {
  double? totalAmount;
  double? interestRate;
  int? numberOfInstallments;
  String? paymentFrequency;
  int? selectedCuota;
  late int cuotasRestantes;
  DateTime? createdAt;
  DateTime? fechaUltimoPago;
  DateTime? fechaNextPay;
  bool? completado;
  String? clientName;
  int? previousSelectedCuota;

  @override
  void initState() {
    super.initState();
    _fetchLoanData();
    selectedCuota = null;
    previousSelectedCuota = null;
  }

  void _showSnackBar(String message) {
    SnackBarTop.showTopSnackBar(context, message);
  }

  DateTime? _calculateNextPaymentDate(
      DateTime? lastPaymentDate, String? frequency) {
    if (lastPaymentDate == null || frequency == null) return null;

    DateTime nextPaymentDate = lastPaymentDate;

    switch (frequency) {
      case 'Diario':
      case 'Daily':
        nextPaymentDate = nextPaymentDate.add(const Duration(days: 1));
        break;
      case 'Semanal':
      case 'Weekly':
        nextPaymentDate = nextPaymentDate.add(const Duration(days: 7));
        break;
      case 'Quincenal':
      case 'Biweekly':
        nextPaymentDate = nextPaymentDate.add(const Duration(days: 14));
        break;
      case 'Mensual':
      case 'Monthly':
        nextPaymentDate = DateTime(nextPaymentDate.year,
            nextPaymentDate.month + 1, nextPaymentDate.day);
        break;
      case 'Anual':
      case 'Yearly':
        nextPaymentDate = DateTime(nextPaymentDate.year + 1,
            nextPaymentDate.month, nextPaymentDate.day);
        break;
      default:
        break;
    }

    return nextPaymentDate;
  }

  Future<void> _fetchLoanData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('loan')
          .doc(widget.loanId)
          .get();
      if (doc.exists) {
        setState(() {
          totalAmount = doc['amount'];
          interestRate = doc['interestRate'];
          numberOfInstallments = doc['numberOfInstallments'];
          paymentFrequency = doc['paymentFrequency'];
          selectedCuota = doc['cuotasPagadas'] ?? 0;
          cuotasRestantes = (numberOfInstallments ?? 0) - (selectedCuota ?? 0);
          createdAt = (doc['createdAt'] as Timestamp).toDate();
          fechaUltimoPago = (doc['fechaUltimoPago'] as Timestamp).toDate();
          fechaNextPay =
              (_calculateNextPaymentDate(fechaUltimoPago, paymentFrequency));
          completado = doc['completado'] ?? false;
          clientName = doc['clientName'] ?? '';
        });
      } else {
        _showSnackBar(context.l10n.loanNotFound);
      }
    } catch (e) {
      _showSnackBar(context.l10n.loadError);
    }
  }

  Future<void> _updateCuotasPagadas(int cuotasPagadas) async {
    try {
      await FirebaseFirestore.instance
          .collection('loan')
          .doc(widget.loanId)
          .update({
        'cuotasPagadas': cuotasPagadas,
        'fechaUltimoPago': DateTime.now(),
      });
    } catch (e) {
      _showSnackBar(context.l10n.error);
    }
  }

  String formatFechaUltimoPago(DateTime? fecha) {
    if (fecha == null) {
      return context.l10n.noPay;
    }
    return DateFormat('dd-MM-yyyy').format(fecha);
  }

  void _confirmPayment() {
    if (selectedCuota == null || selectedCuota == 0) {
      SnackBarTop.showTopSnackBar(context, context.l10n.selectCuote);
      return;
    }

    // Si se selecciona la última cuota
    if (selectedCuota == numberOfInstallments) {
      // Actualiza las cuotas pagadas
      _updateCuotasPagadas(selectedCuota!);
      SnackBarTop.showTopSnackBar(context, context.l10n.confirmPay);

      setState(() {
        cuotasRestantes--;
        previousSelectedCuota = selectedCuota;

        // Marca el préstamo como completado
        _markLoanAsCompleted();
        context.go('/');
      });
    } else {
      // Si no es la última cuota, solo actualiza las cuotas pagadas
      _updateCuotasPagadas(selectedCuota!);
      SnackBarTop.showTopSnackBar(context, context.l10n.confirmPay);

      setState(() {
        cuotasRestantes--;
        previousSelectedCuota = selectedCuota;

        // No se completa el préstamo, solo se actualiza el estado
        context.go('/');
      });
    }
  }

  void _markLoanAsCompleted() {
    FirebaseFirestore.instance
        .collection('loan')
        .doc(widget.loanId)
        .update({'completado': true}).then((_) {
      //SnackBarTop.showTopSnackBar(context, 'El préstamo ha sido marcado como completado.');
    }).catchError((error) {
      _showSnackBar(context.l10n.error);
    });
  }

  Future<void> _renewLoan() async {
    try {
      await FirebaseFirestore.instance
          .collection('loan')
          .doc(widget.loanId)
          .update({'renovado': true});
      _showSnackBar(context.l10n.renewLoan);
      context.go('/createLoan/$clientName');
    } catch (e) {
      _showSnackBar(context.l10n.error);
    }
  }

  Widget _buildDetailText(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calcular el porcentaje de cuotas pagadas

    bool canRenewLoan =
        (selectedCuota != null && numberOfInstallments != null) &&
            (selectedCuota! / numberOfInstallments! > 0.7);
    if (totalAmount == null ||
        interestRate == null ||
        numberOfInstallments == null ||
        paymentFrequency == null) {
      return const Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.loanManagement),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            offset:
                const Offset(0, kToolbarHeight), // Desplazamiento hacia abajo
            onSelected: (String value) {
              if (value == 'imprimir') {
                context.push('/print');
              } else if (value == 'renovar' && canRenewLoan) {
                _renewLoan();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'imprimir',
                  child: Text('Imprimir recibo'),
                ),
                PopupMenuItem<String>(
                  value: 'renovar',

                  enabled:
                      canRenewLoan, // Desactiva la opción si no se puede renovar

                  child: Text(
                    'Renovar préstamo',
                    style: TextStyle(
                      color: canRenewLoan
                          ? Colors.black
                          : Colors.grey, // Cambia el color del texto
                    ),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (completado == true) ...[
                    Text(
                      context.l10n.completePay,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _renewLoan,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 24.0),
                          ),
                          child: Text(context.l10n.renew),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            context.go('/');
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 24.0),
                          ),
                          child: Text(context.l10n.cancel),
                        ),
                      ],
                    )
                  ] else ...[
                    Text(
                      context.l10n.paySelector,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: List.generate(numberOfInstallments!, (index) {
                        int cuota = index + 1;
                        return ChoiceChip(
                          label: Text('$cuota'),
                          selected: selectedCuota == cuota,
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected && cuotasRestantes > 0) {
                                if (cuota ==
                                    (numberOfInstallments! -
                                        cuotasRestantes +
                                        1)) {
                                  selectedCuota = cuota;
                                } else {
                                  SnackBarTop.showTopSnackBar(
                                      context, context.l10n.cuoteError);
                                }
                              }
                            });
                          },
                          selectedColor: Colors.teal,
                          backgroundColor: Colors.grey[300],
                          labelStyle: TextStyle(
                            color: selectedCuota == cuota
                                ? Colors.white
                                : Colors.black,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    _buildDetailText(context.l10n.loanPayed,
                        '${numberOfInstallments! - cuotasRestantes}/${numberOfInstallments!}'),
                    const Divider(),
                    const SizedBox(height: 10),
                    Text(
                      context.l10n.loanDetails,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal),
                    ),
                    const SizedBox(height: 20),
                    _buildDetailText(context.l10n.totalAmount,
                        '\$${totalAmount!.toStringAsFixed(2)}'),
                    const SizedBox(height: 10),
                    _buildDetailText(context.l10n.interestRate,
                        '\$${(totalAmount! * interestRate! / 100).toStringAsFixed(2)}'),
                    const SizedBox(height: 10),
                    _buildDetailText(context.l10n.totalToPay,
                        '\$${(totalAmount! + (totalAmount! * interestRate! / 100)).toStringAsFixed(2)}'),
                    const SizedBox(height: 10),
                    _buildDetailText(context.l10n.amountPerInstallment,
                        '\$${((totalAmount! + (totalAmount! * interestRate! / 100)) / numberOfInstallments!).toStringAsFixed(2)}'),
                    const SizedBox(height: 10),
                    _buildDetailText(context.l10n.payedAmount,
                        '\$${(totalAmount! + (totalAmount! * interestRate! / 100) - (cuotasRestantes * (totalAmount! + (totalAmount! * interestRate! / 100)) / numberOfInstallments!)).toStringAsFixed(2)}'),
                    const SizedBox(height: 10),
                    _buildDetailText(
                        context.l10n.paymentFrequency, paymentFrequency!),
                    const SizedBox(height: 10),
                    _buildDetailText(context.l10n.lastPay,
                        formatFechaUltimoPago(fechaUltimoPago)),
                    const SizedBox(height: 10),
                    _buildDetailText(
                        context.l10n.nextPay,
                        fechaNextPay != null
                            ? DateFormat('dd-MM-yyyy').format(fechaNextPay!)
                            : context.l10n.noPay),
                    const Divider(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _confirmPayment();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 24.0),
                          ),
                          child: Text(context.l10n.save),
                        ),
                        const SizedBox(width: 50),
                        ElevatedButton(
                          onPressed: () {
                            context.go('/');
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 24.0),
                          ),
                          child: Text(context.l10n.cancel),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
