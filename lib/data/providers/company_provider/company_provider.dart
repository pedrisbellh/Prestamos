import 'package:prestamos/domain/models/company/company.dart';

abstract class CompanyProvider {
  Future<void> deleteCompanyFromFirestore({required String userId});
  Future<Company?> getCompanyFromFirestore({required String userId});
  Future<void> addCompanyToFirestore(
      {required String name,
      required String address,
      required String phone,
      String? rcn,
      required String userId});
}
