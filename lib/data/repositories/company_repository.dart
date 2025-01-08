import 'package:firebase_auth/firebase_auth.dart';
import 'package:prestamos/data/services/firebase_service.dart';

class CompanyRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addCompany(
      String name, String address, String phone, String? rcn) async {
    String? userId = _auth.currentUser?.uid;

    // Lógica para agregar la empresa a Firestore
    await addCompanyToFirestore(
      name: name,
      address: address,
      phone: phone,
      rcn: rcn,
      userId: userId!,
    );
  }
}
