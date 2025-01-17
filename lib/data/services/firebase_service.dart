import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<void> deleteLoanForClient(String clientName, String userId) async {
  try {
    QuerySnapshot loanSnapshot = await FirebaseFirestore.instance
        .collection('loan')
        .where('clientName', isEqualTo: clientName)
        .where('userId', isEqualTo: userId)
        .get();

    for (var loanDoc in loanSnapshot.docs) {
      await loanDoc.reference.delete();
      print("Préstamo eliminado: ${loanDoc.id}");
    }
  } catch (e) {
    print("Error al eliminar préstamos: $e");
    throw e;
  }
}

Future<String> saveLoanToFirestore({
  required String clientName,
  required String userId,
  required double amount,
  required double interestRate,
  required int numberOfInstallments,
  required String paymentFrequency,
  required int cuotasRestantes,
  bool completado = false,
  bool renovado = false,
}) async {
  DateTime createdAt = DateTime.now();
  DateTime fechaUltimoPago = DateTime.now();

  DocumentReference docRef =
      await FirebaseFirestore.instance.collection('loan').add({
    'clientName': clientName,
    'userId': userId,
    'amount': amount,
    'interestRate': interestRate,
    'numberOfInstallments': numberOfInstallments,
    'paymentFrequency': paymentFrequency,
    'cuotasPagadas': 0,
    'cuotasRestantes': cuotasRestantes,
    'createdAt': createdAt,
    'fechaUltimoPago': fechaUltimoPago,
    'completado': completado,
    'renovado': renovado,
  });

  return docRef.id;
}
