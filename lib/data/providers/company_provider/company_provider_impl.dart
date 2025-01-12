import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestamos/data/providers/company_provider/company_provider.dart';
import 'package:prestamos/domain/models/company/company.dart';

class CompanyProviderImpl implements CompanyProvider {
  static const _collectionName = 'company';

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Future<void> deleteCompanyFromFirestore({required String userId}) async {
    CollectionReference collectionReferenceCompany =
        FirebaseFirestore.instance.collection(_collectionName);

    try {
      QuerySnapshot querySnapshot = await collectionReferenceCompany
          .where('userId', isEqualTo: userId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        await collectionReferenceCompany
            .doc(querySnapshot.docs.first.id)
            .delete();
        print("Empresa eliminada de Firestore");
      } else {
        print("No se encontró la empresa para eliminar.");
      }
    } catch (e) {
      print("Error al eliminar la empresa: $e");
      throw e;
    }
  }

  @override
  Future<Company?> getCompanyFromFirestore({required String userId}) async {
    CollectionReference collectionReferenceCompany =
        FirebaseFirestore.instance.collection(_collectionName);

    try {
      QuerySnapshot querySnapshot = await collectionReferenceCompany
          .where('userId', isEqualTo: userId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return Company.fromMap(
            querySnapshot.docs.first.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error al obtener la empresa: $e");
    }
    return null;
  }

  @override
  Future<void> addCompanyToFirestore({
    required String name,
    required String address,
    required String phone,
    String? rcn,
    required String userId,
  }) async {
    CollectionReference collectionReferenceCompany =
        db.collection(_collectionName);

    try {
      QuerySnapshot existingCompany = await collectionReferenceCompany
          .where('userId', isEqualTo: userId)
          .get();
      if (existingCompany.docs.isNotEmpty) {
        throw Exception('Este usuario ya tiene una empresa registrada.');
      }

      await collectionReferenceCompany.add({
        'name': name,
        'address': address,
        'phone': phone,
        'rcn': rcn,
        'userId': userId,
      });
      print("Empresa agregada a Firestore: $name");
    } catch (e) {
      print("Error al agregar empresa a Firestore: $e");
      throw e;
    }
  }
}
