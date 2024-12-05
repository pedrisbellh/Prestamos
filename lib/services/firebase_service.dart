import 'package:cloud_firestore/cloud_firestore.dart';

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

Future<void> addClientToFirestore(String name, String phone, String emergencyContactName, String emergencyContactPhone, String address, String identityCard) async {
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
    await FirebaseFirestore.instance.collection('clients').doc(clientName).delete();
    print("Cliente eliminado: $clientName");
  } catch (e) {
    print("Error al eliminar cliente: $e");
    throw e; // Lanza el error para manejarlo en la UI si es necesario
  }
}

Future<void> deleteLoanForClient(String clientName, String userId) async {
  try {
    QuerySnapshot loanSnapshot = await FirebaseFirestore.instance
        .collection('loan')
        .where('clientName', isEqualTo: clientName)
        .where('userId', isEqualTo: userId) // Usar el userId pasado como parámetro
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
  required String userId, // Agregar userId
  required double amount,
  required double interestRate,
  required int numberOfInstallments,
  required String paymentFrequency,
  required int cuotasRestantes,
  bool completado = false,
  bool renovado = false,
}) async {
  DateTime createdAt = DateTime.now();

  DocumentReference docRef = await FirebaseFirestore.instance.collection('loan').add({
    'clientName': clientName,
    'userId': userId, // Guardar el userId
    'amount': amount,
    'interestRate': interestRate,
    'numberOfInstallments': numberOfInstallments,
    'paymentFrequency': paymentFrequency,
    'cuotasPagadas': 0, 
    'cuotasRestantes': cuotasRestantes,
    'createdAt': createdAt,
    'completado' : completado,
    'renovado' : renovado,
  });
  
  return docRef.id; // Devuelve el ID del préstamo
}





