import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_loan_screen.dart';
import 'home_screen.dart';
import '/utils/snack_bar_top.dart';
import 'package:intl/intl.dart';
import '/screens/print_screen.dart';

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
  double? totalAmount; // Monto total del préstamo
  double? interestRate; // Tasa de interés
  int? numberOfInstallments; // Número de cuotas
  String? paymentFrequency; // Frecuencia de pago
  int? selectedCuota; // Cuota seleccionada
  late int cuotasRestantes; // Cuotas restantes por pagar
  DateTime? createdAt; // Fecha de creacion del prestamo
  DateTime? fechaUltimoPago; //Fecha del pago de la ultima cuota
  bool? completado; // Estado del préstamo
  String? clientName; // Nombre del cliente

  @override
  void initState() {
    super.initState();
    _fetchLoanData(); // Cargar los datos del préstamo
  }

  // Método para mostrar SnackBar
  void _showSnackBar(String message) {
    SnackBarTop.showTopSnackBar(context, message);
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
          fechaUltimoPago = (doc['createdAt'] as Timestamp).toDate();
          completado =
              doc['completado'] ?? false; // Obtener el estado de completado
          clientName = doc['clientName'] ?? ''; // Obtener el nombre del cliente

          // Asegúrate de que estás recuperando la fecha del último pago
          // if (doc['fechaUltimoPago'] != null) {
          //   fechaUltimoPago = (doc['fechaUltimoPago'] as Timestamp).toDate();
          // } else {
          //   fechaUltimoPago = null; // O asigna una fecha por defecto si es necesario
          // }
        });
      } else {
        _showSnackBar('Préstamo no encontrado.');
      }
    } catch (e) {
      _showSnackBar('Error al cargar los datos del préstamo.');
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
      _showSnackBar('Error al actualizar las cuotas pagadas.');
    }
  }

  String formatFechaUltimoPago(DateTime? fecha) {
    if (fecha == null) {
      return 'No hay pagos realizados';
    }
    // Formato deseado: "2024-12-02"
    return DateFormat('yyyy-MM-dd').format(fecha);
  }

  void _confirmPayment() {
    if (selectedCuota != null) {
      // Lógica para confirmar el pago
      _updateCuotasPagadas(selectedCuota!);
      SnackBarTop.showTopSnackBar(
          context, 'Pago de la cuota $selectedCuota confirmado.');

      setState(() {
        cuotasRestantes--;
        // Verificar si todas las cuotas han sido pagadas
        if (cuotasRestantes == 0 || selectedCuota == numberOfInstallments) {
          _markLoanAsCompleted(); // Marcar el préstamo como completado
        }
        _navigateToHomeScreen(); // Navegar a la pantalla principal
      });
    } else {
      SnackBarTop.showTopSnackBar(
          context, 'Por favor, seleccione una cuota para pagar.');
    }
  }

  void _markLoanAsCompleted() {
    FirebaseFirestore.instance
        .collection('loan')
        .doc(widget.loanId)
        .update({'completado': true}).then((_) {
      // Mostrar un mensaje de éxito
      //SnackBarTop.showTopSnackBar(context, 'El préstamo ha sido marcado como completado.');
    }).catchError((error) {
      // Manejar errores
      _showSnackBar('Error al actualizar el préstamo: $error');
    });
  }

  void _navigateToHomeScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (Route<dynamic> route) => false, // Elimina todas las rutas anteriores
    );
  }

  Future<void> _renewLoan() async {
    try {
      await FirebaseFirestore.instance
          .collection('loan')
          .doc(widget.loanId)
          .update({'renovado': true});
      _showSnackBar('El préstamo ha sido renovado.');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => CreateLoanScreen(clientName: clientName!)),
      );
    } catch (e) {
      _showSnackBar('Error al renovar el préstamo.');
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
    // Asegurar que los datos estén cargados antes de construir la UI
    if (totalAmount == null ||
        interestRate == null ||
        numberOfInstallments == null ||
        paymentFrequency == null) {
      return const Center(
          child:
              CircularProgressIndicator()); // Muestra un indicador de carga mientras se obtienen los datos
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Pagos'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.print, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrintScreen(),
                ),
              );
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
                    // Si el préstamo está completado
                    const Text(
                      'El pago del préstamo ha sido completado.',
                      style: TextStyle(fontSize: 18),
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
                          child: const Text('Renovar'),
                        ),
                        const SizedBox(width: 20), // Espacio entre botones
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 24.0),
                          ),
                          child: const Text('Cancelar'),
                        ),
                      ],
                    )
                  ] else ...[
                    // Si el préstamo no está completado
                    const Text(
                      'Marcador de Pagos:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                              if (selected &&
                                  cuotasRestantes > 0 &&
                                  cuota ==
                                      (numberOfInstallments! -
                                          cuotasRestantes +
                                          1)) {
                                selectedCuota = cuota;
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
                    _buildDetailText('Cuotas Pagadas:',
                        '${numberOfInstallments! - cuotasRestantes}/${numberOfInstallments!}'),
                    const SizedBox(height: 20),
                    _buildDetailText('Cantidad Prestada:',
                        '\$${totalAmount!.toStringAsFixed(2)}'),
                    const SizedBox(height: 20),
                    _buildDetailText('Tasa de Interés:',
                        '\$${(totalAmount! * interestRate! / 100).toStringAsFixed(2)}'),
                    const SizedBox(height: 20),
                    _buildDetailText('Cantidad a Pagar:',
                        '\$${(totalAmount! + (totalAmount! * interestRate! / 100)).toStringAsFixed(2)}'),
                    const SizedBox(height: 20),
                    _buildDetailText('Cantidad Pagada:',
                        '\$${(totalAmount! + (totalAmount! * interestRate! / 100) - (cuotasRestantes * (totalAmount! + (totalAmount! * interestRate! / 100)) / numberOfInstallments!)).toStringAsFixed(2)}'),
                    const SizedBox(height: 20),
                    _buildDetailText('Frecuencia de Pago:', paymentFrequency!),
                    const SizedBox(height: 20),
                    _buildDetailText(
                        'Ultimo Pago:', formatFechaUltimoPago(fechaUltimoPago)),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _confirmPayment,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 24.0),
                          ),
                          child: const Text('Guardar'),
                        ),
                        const SizedBox(width: 20), // Espacio entre botones
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 24.0),
                          ),
                          child: const Text('Cancelar'),
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
