import 'package:prestamos/domain/models/loan/loan.dart';

abstract class LoanProvider {
  Future<List<Loan>> getAllLoansByUser({required String userId});
  Future<Loan> getLoanById({required String id});
  Future<void> deleteLoan({required String id});
}
