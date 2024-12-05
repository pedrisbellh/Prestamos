import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'create_screen.dart';
import 'home_screen.dart';
import '../utils/snack_bar_top.dart';
import 'package:printing/printing.dart';
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

Future<void> _fetchLoanData() async {
  try {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('loan').doc(widget.loanId).get();
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
        completado = doc['completado'] ?? false; // Obtener el estado de completado
        clientName = doc['clientName'] ?? ''; // Obtener el nombre del cliente
        
        // Asegúrate de que estás recuperando la fecha del último pago
        // if (doc['fechaUltimoPago'] != null) {
        //   fechaUltimoPago = (doc['fechaUltimoPago'] as Timestamp).toDate();
        // } else {
        //   fechaUltimoPago = null; // O asigna una fecha por defecto si es necesario
        // }
      });
    } else {
      SnackBarTop.showTopSnackBar(context, 'Préstamo no encontrado.');
    }
  } catch (e) {
    print("Error al obtener los datos del préstamo: $e");
    SnackBarTop.showTopSnackBar(context, 'Error al cargar los datos del préstamo.');
  }
}

Future<void> _updateCuotasPagadas(int cuotasPagadas) async {
  try {
    await FirebaseFirestore.instance.collection('loan').doc(widget.loanId).update({
      'cuotasPagadas': cuotasPagadas,
      'fechaUltimoPago': DateTime.now(),
    });
  } catch (e) {
    print("Error al actualizar las cuotas pagadas: $e");
    SnackBarTop.showTopSnackBar(context, 'Error al actualizar las cuotas pagadas.');
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
    SnackBarTop.showTopSnackBar(context, 'Pago de la cuota $selectedCuota confirmado.');

    setState(() {
      cuotasRestantes--; 
      // Verificar si todas las cuotas han sido pagadas
       if (cuotasRestantes == 0 || selectedCuota == numberOfInstallments) {
        _markLoanAsCompleted(); // Marcar el préstamo como completado
      }
      _navigateToHomeScreen(); // Navegar a la pantalla principal
    });
  } else {
    SnackBarTop.showTopSnackBar(context, 'Por favor, seleccione una cuota para pagar.');
  }
}

void _markLoanAsCompleted() {
  // Aquí debes implementar la lógica para actualizar el campo 'completado' en la base de datos
  // Por ejemplo, si estás usando Firestore:
  FirebaseFirestore.instance
      .collection('loan')
      .doc(widget.loanId) // Asegúrate de tener el ID del préstamo
      .update({'completado': true}).then((_) {
        // Mostrar un mensaje de éxito
        //SnackBarTop.showTopSnackBar(context, 'El préstamo ha sido marcado como completado.');
      }).catchError((error) {
        // Manejar errores
        SnackBarTop.showTopSnackBar(context, 'Error al actualizar el préstamo: $error');
      });
}

  void _navigateToHomeScreen() {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (Route<dynamic> route) => false, // Elimina todas las rutas anteriores
      );
  }

  // Función para construir filas de información
pw.Row _buildInfoRow(String label, String value) {

  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.start,
    children: [
      pw.Text(label, style: const pw.TextStyle(fontSize: 14)),
      pw.SizedBox(width: 10), 
      pw.Expanded(
        child: pw.Text(value, style: pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.italic), softWrap: true),
      ),
    ],
  );
}

Future<void> _printSummary(BuildContext context) async {
  final pdf = pw.Document();

  // Obtener datos del cliente
  String clientName = ''; 
  String clientAddress = ''; 
  String clientIdentityCard = '';

  try {
    DocumentSnapshot loanDoc = await FirebaseFirestore.instance.collection('loan').doc(widget.loanId).get();
    if (loanDoc.exists) {
      clientName = loanDoc['clientName'] ?? 'Cliente Desconocido'; // Obtener el nombre del cliente

      // Obtener la información del cliente usando el nombre
      QuerySnapshot clientDoc = await FirebaseFirestore.instance.collection('clients').where('name', isEqualTo: clientName).get();
      if (clientDoc.docs.isNotEmpty) {
        clientAddress = clientDoc.docs.first['address'] ?? 'Dirección no disponible';
        clientIdentityCard = clientDoc.docs.first['identityCard'] ?? 'Cédula no disponible';
      }
    }
  } catch (e) {
    print("Error al obtener la información del cliente: $e");
  }

  // Obtener la fecha actual
  String currentDate = DateTime.now().toLocal().toString().split(' ')[0]; // Formato: YYYY-MM-DD

  // Definir un tamaño de página personalizado
  const pageWidth = PdfPageFormat(58 * PdfPageFormat.mm, 165 * PdfPageFormat.mm);

pdf.addPage(
  pw.Page(
    pageFormat: pageWidth,
    build: (pw.Context context) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center, 
        children: [
          // Encabezado
          pw.Container(
            width: double.infinity, 
            padding: const pw.EdgeInsets.all(10),
            decoration: const pw.BoxDecoration(
              border: pw.Border(bottom: pw.BorderSide(width: 2, color: PdfColors.black)),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('Empresa', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.Text('Dirección de la Empresa', style: pw.TextStyle(fontSize: 12, fontStyle: pw.FontStyle.italic)),
                pw.Text('Teléfono: (123) 456-7890', style: pw.TextStyle(fontSize: 12, fontStyle: pw.FontStyle.italic)),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          
           // Título del recibo
                pw.Text('Cliente', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                
                // Información del cliente
                _buildInfoRow('Nombre:', clientName),
                _buildInfoRow('Dirección:', clientAddress),
                _buildInfoRow('Cédula:', clientIdentityCard),
                pw.SizedBox(height: 20),

                // Resumen de Pagos
                pw.Text('Préstamo', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),

                // Información de pagos
                _buildInfoRow('Monto:', '\$${totalAmount?.toStringAsFixed(2)}'),
                _buildInfoRow('Interés:', '${interestRate?.toStringAsFixed(2)}%'),
                _buildInfoRow('Prestado:', createdAt != null ? createdAt!.toLocal().toString().split(' ')[0] : 'Fecha no disponible'),
                _buildInfoRow('Cuotas:', '${numberOfInstallments! - cuotasRestantes}/${numberOfInstallments!}'),
                _buildInfoRow('Pago:', paymentFrequency!),
          
          // Pie de página
          pw.SizedBox(height: 20),
          pw.Container(
            width: double.infinity, 
            padding: const pw.EdgeInsets.all(10),
            decoration: const pw.BoxDecoration(
              border: pw.Border(top: pw.BorderSide(width: 2, color: PdfColors.black)),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center, 
              children: [
                pw.Text(
                  'Gracias por su preferencia',
                  style: pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.italic),
                ),
                pw.Text(
                  'Fecha de Emisión: $currentDate',
                  style: pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      );
    },
  ),
);

  // Mostrar vista previa del PDF
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}

// Método para renovar el préstamo
  Future<void> _renewLoan() async {
    try {
      await FirebaseFirestore.instance.collection('loan').doc(widget.loanId).update({'renovado': true});
      SnackBarTop.showTopSnackBar(context, 'El préstamo ha sido renovado.');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SecondScreen(clientName: clientName!)),
        (Route<dynamic> route) => false, // Elimina todas las rutas anteriores
      );
    } catch (e) {
      print("Error al renovar el préstamo: $e");
      SnackBarTop.showTopSnackBar(context, 'Error al renovar el préstamo.');
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
    if (totalAmount == null || interestRate == null || numberOfInstallments == null || paymentFrequency == null) {
      return const Center(child: CircularProgressIndicator()); // Muestra un indicador de carga mientras se obtienen los datos
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Pagos'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.print, color: Colors.white),
        //     onPressed: () => _printSummary(context),
        //   ),
        // ],
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
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                          ),
                          child: const Text('Renovar'),
                        ),
                        const SizedBox(width: 20), // Espacio entre botones
                        ElevatedButton(
                          onPressed: () {
                            _printSummary(context);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                          ),
                          child: const Text('Imprimir Recibo'),
                        ),
                      ],
                    )
                  ] else ...[
                    // Si el préstamo no está completado
                    const Text(
                      'Marcador de Pagos:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                              if (selected && cuotasRestantes > 0 && cuota == (numberOfInstallments! - cuotasRestantes + 1)) {
                                selectedCuota = cuota;
                              } 
                            });
                          },
                          selectedColor: Colors.teal,
                          backgroundColor: Colors.grey[300],
                          labelStyle: TextStyle(
                            color: selectedCuota == cuota ? Colors.white : Colors.black,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    _buildDetailText('Cuotas Pagadas:', '${numberOfInstallments! - cuotasRestantes}/${numberOfInstallments!}'),
                    const SizedBox(height: 20),
                    _buildDetailText('Cantidad a Pagar:', '\$${(totalAmount! + (totalAmount! * interestRate! / 100)).toStringAsFixed(2)}'),
                    const SizedBox(height: 20),
                    _buildDetailText('Cantidad Pagada:', '\$${(totalAmount! + (totalAmount! * interestRate! / 100) - (cuotasRestantes * (totalAmount! + (totalAmount! * interestRate! / 100)) / numberOfInstallments!)).toStringAsFixed(2)}'),
                    const SizedBox(height: 20),
                    _buildDetailText('Frecuencia de Pago:', paymentFrequency!),
                    const SizedBox(height: 20),
                    _buildDetailText('Ultimo Pago:', formatFechaUltimoPago(fechaUltimoPago)),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _confirmPayment,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                          ),
                          child: const Text('Guardar'),
                        ),
                        const SizedBox(width: 20), // Espacio entre botones
                        ElevatedButton(
                          onPressed: () {
                            _printSummary(context);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                          ),
                          child: const Text('Imprimir Recibo'),
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