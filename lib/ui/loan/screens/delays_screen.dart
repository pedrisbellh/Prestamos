import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prestamos/domain/models/client/client.dart';
import 'package:prestamos/ui/extensions/build_context_extension.dart';
import 'package:prestamos/ui/widgets/utils/snack_bar_top.dart';

class DelaysScreen extends StatefulWidget {
  const DelaysScreen({super.key});

  @override
  DelaysScreenState createState() => DelaysScreenState();
}

class DelaysScreenState extends State<DelaysScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Client> clientsWithLoans = []; // Lista de clientes con préstamos
  String? userId;
  bool isLoading = true; // Estado de carga

  @override
  void initState() {
    super.initState();
    userId = _auth.currentUser?.uid;
    _fetchClientsWithLoans();
  }

  Future<void> _fetchClientsWithLoans() async {
    String? userId = _auth.currentUser?.uid;

    if (userId != null) {
      try {
        DateTime now = DateTime.now().toUtc(); // Obtiene la fecha actual en UTC
        DateTime today =
            DateTime(now.year, now.month, now.day); // Trunca la hora

        // Obtener todos los préstamos del usuario que están atrasados
        QuerySnapshot loanSnapshot = await _firestore
            .collection('loan')
            .where('userId', isEqualTo: userId)
            .where('renovado', isEqualTo: false)
            .where('completado', isEqualTo: false)
            .get();

        // Filtrar los clientes cuyos préstamos están atrasados
        List<String> clientNames = [];
        for (var doc in loanSnapshot.docs) {
          Timestamp fechaNextPayTimestamp = doc['fechaNextPay'];
          DateTime fechaNextPay =
              fechaNextPayTimestamp.toDate().toUtc(); // Convierte a DateTime
          // Truncar la hora de fechaNextPay
          DateTime fechaNextPayTruncada =
              DateTime(fechaNextPay.year, fechaNextPay.month, fechaNextPay.day);
          // Comparar con la fecha actual
          if (fechaNextPayTruncada.isBefore(today)) {
            clientNames.add(doc['clientName']
                as String); // Agrega a la lista si está atrasado
          }
        }

        // Obtener todos los clientes del usuario
        QuerySnapshot clientSnapshot = await _firestore
            .collection('clients')
            .where('userId', isEqualTo: userId)
            .get();

        // Filtrar los clientes cuyos nombres están en la lista de clientNames
        setState(() {
          clientsWithLoans = clientSnapshot.docs
              .where((doc) => clientNames.contains(doc['name']))
              .map((doc) => Client.fromJson(doc.data() as Map<String, dynamic>))
              .toList();

          isLoading = false; // Cambiar el estado de carga
        });
      } catch (e) {
        // Manejo de errores
        print('Error al obtener clientes con préstamos atrasados: $e');

        setState(() {
          isLoading =
              false; // Cambiar el estado de carga incluso si hay un error
        });
      }
    }
  }

  void _showSnackBar(String message) {
    SnackBarTop.showTopSnackBar(context, message);
  }

  Widget _buildClientTile(Client client, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: ListTile(
        title: Text(client.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.account_balance_wallet,
                  color: Colors.red.shade900),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('loan')
                    .where('clientName', isEqualTo: client.name)
                    .where('userId', isEqualTo: userId)
                    .where('renovado', isEqualTo: false)
                    .get()
                    .then((querySnapshot) {
                  if (querySnapshot.docs.isNotEmpty) {
                    String loanId = querySnapshot.docs.first.id;

                    context.push('/viewLoan/$loanId');
                  } else {
                    _showSnackBar(context.l10n.noLoan);
                  }
                }).catchError((error) {
                  _showSnackBar(context.l10n.error);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atrasados'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
            )) // Mostrar el indicador de carga
          : clientsWithLoans.isEmpty
              ? const Center(
                  child: Text('No hay clientes con pagos atrasados.'))
              : ListView.builder(
                  itemCount: clientsWithLoans.length,
                  itemBuilder: (context, index) {
                    return _buildClientTile(clientsWithLoans[index], index);
                  },
                ),
    );
  }
}
