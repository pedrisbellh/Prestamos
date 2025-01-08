import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/client/client.dart';

class ClientRepository {
  final FirebaseFirestore firestore;

  ClientRepository(this.firestore);

  Future<List<Client>> fetchClients(String userId) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('clients')
        .where('userId', isEqualTo: userId) // Filtra por userId
        .get();
    return querySnapshot.docs
        .map((doc) => Client.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> addClient(Client client) async {
    await firestore.collection('clients').add(client.toJson());
  }

  Future<void> removeClient(String clientName, String userId) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('clients')
        .where('name', isEqualTo: clientName)
        .where('userId', isEqualTo: userId) // Filtra por userId
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String clientId = querySnapshot.docs.first.id;
      await firestore.collection('clients').doc(clientId).delete();
    } else {
      throw Exception('Cliente no encontrado o no autorizado para eliminar.');
    }
  }
}
