import 'package:firebase_auth/firebase_auth.dart';
import 'package:prestamos/data/services/firebase_service.dart';
import 'package:prestamos/domain/models/company/company.dart';

class CompanyRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addCompany(
      String name, String address, String phone, String? rcn) async {
    String? userId = _auth.currentUser?.uid;

    await addCompanyToFirestore(
      name: name,
      address: address,
      phone: phone,
      rcn: rcn,
      userId: userId!,
    );
  }

  Future<Company?> getCompany(String userId) async {
    return await getCompanyFromFirestore(userId);
  }
}
