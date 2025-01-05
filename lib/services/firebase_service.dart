import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestamos/models/client/client.dart';
import 'package:prestamos/models/company/company.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<Map<String, dynamic>>> getClient() async {
  List<Map<String, dynamic>> client = [];
  CollectionReference collectionReferenceClient = db.collection('client');

  try {
    QuerySnapshot queryClient = await collectionReferenceClient.get();
    for (var documento in queryClient.docs) {
      client.add(documento.data() as Map<String, dynamic>);
    }
  } catch (e) {
    print("Error al obtener clientes: $e");
  }

  return client;
}

Future<void> addClientToFirestore(
    String name,
    String phone,
    String emergencyContactName,
    String emergencyContactPhone,
    String address,
    String identityCard) async {
  CollectionReference collectionReferenceClient = db.collection('client');

  try {
    await collectionReferenceClient.add({
      'name': name,
      'phone': phone,
      'emergencyContactName': emergencyContactName,
      'emergencyContactPhone': emergencyContactPhone,
      'address': address,
      'identityCard': identityCard,
    });
  } catch (e) {
    print("Error al agregar cliente a Firestore: $e");
  }
}

Future<void> deleteClientFromFirestore(String clientName) async {
  try {
    await FirebaseFirestore.instance
        .collection('clients')
        .doc(clientName)
        .delete();
    print("Cliente eliminado: $clientName");
  } catch (e) {
    print("Error al eliminar cliente: $e");
    throw e;
  }
}

Future<Client?> getClientById(String clientId) async {
  try {
    final doc = await FirebaseFirestore.instance
        .collection('clients')
        .doc(clientId)
        .get();

    if (doc.exists) {
      return Client.fromJson(doc.data()!);
    }
  } catch (e) {
    print('Error al obtener el cliente: $e');
  }
  return null; // Retorna null si no se encuentra el cliente
}

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

Future<void> addCompanyToFirestore({
  required String name,
  required String address,
  required String phone,
  String? rcn,
  required String userId,
}) async {
  CollectionReference collectionReferenceCompany = db.collection('company');

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

Future<Company?> getCompanyFromFirestore(String userId) async {
  CollectionReference collectionReferenceCompany =
      FirebaseFirestore.instance.collection('company');

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

Future<void> deleteCompanyFromFirestore(String userId) async {
  CollectionReference collectionReferenceCompany =
      FirebaseFirestore.instance.collection('company');

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
