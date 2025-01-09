import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prestamos/data/services/firebase_service.dart';
import 'package:prestamos/domain/models/loan/loan.dart';

class LoanRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> addLoan({
    required String clientName,
    required double amount,
    required double interestRate,
    required int numberOfInstallments,
    required String paymentFrequency,
  }) async {
    String userId = _auth.currentUser!.uid;
    return await saveLoanToFirestore(
      clientName: clientName,
      userId: userId,
      amount: amount,
      interestRate: interestRate,
      numberOfInstallments: numberOfInstallments,
      paymentFrequency: paymentFrequency,
      cuotasRestantes: numberOfInstallments,
    );
  }

  Future<List<Loan>> getLoans(String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('loan')
          .where('userId', isEqualTo: userId)
          .get();

      // Convertir los documentos a una lista de objetos Loan

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return Loan.fromJson(data);
      }).toList();
    } catch (e) {
      print("Error al obtener préstamos: $e");

      throw Exception('Error al obtener préstamos');
    }
  }
}
