// loan_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/loan/loan.dart';

class LoanRepository {
  final FirebaseFirestore firestore;

  LoanRepository(this.firestore);

  Future<String> addLoan(Loan loan) async {
    DocumentReference docRef =
        await firestore.collection('loan').add(loan.toJson());
    return docRef.id; // Retorna el ID del préstamo creado
  }

  Future<void> removeLoan(String loanId) async {
    await firestore.collection('loan').doc(loanId).delete();
  }
}
