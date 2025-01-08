import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestamos/domain/models/loan/loan.dart';
import 'package:prestamos/data/providers/loan_provider/loan_provider.dart';

class LoanProviderImpl implements LoanProvider {
  static const _collectionName = 'loan';

  @override
  Future<void> deleteLoan({required String id}) {
    // TODO: implement deleteClient
    throw UnimplementedError();
  }

  @override
  Future<List<Loan>> getAllLoansByUser({required String userId}) async {
    final query = FirebaseFirestore.instance
        .collection(_collectionName)
        .withConverter(
          fromFirestore: (json, _) => Loan.fromJson(json.data() ?? {}),
          toFirestore: (value, _) => value.toJson(),
        )
        .where('userId', isEqualTo: userId);

    return query
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
  }

  @override
  Future<Loan> getLoanById({required String id}) {
    // TODO: implement getClientById
    throw UnimplementedError();
  }
}
