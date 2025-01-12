import 'package:firebase_auth/firebase_auth.dart';
import 'package:prestamos/data/providers/company_provider/company_provider.dart';
import 'package:prestamos/domain/models/company/company.dart';

class CompanyRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CompanyProvider companyProvider;

  CompanyRepository(this.companyProvider);

  Future<void> addCompany(
      String name, String address, String phone, String? rcn) async {
    String? userId = _auth.currentUser?.uid;

    await companyProvider.addCompanyToFirestore(
      name: name,
      address: address,
      phone: phone,
      rcn: rcn,
      userId: userId!,
    );
  }

  Future<Company?> getCompany(String userId) async {
    return await companyProvider.getCompanyFromFirestore(userId: userId);
  }
}
