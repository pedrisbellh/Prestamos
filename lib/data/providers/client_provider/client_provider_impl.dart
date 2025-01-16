import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestamos/domain/models/client/client.dart';
import 'package:prestamos/data/providers/client_provider/client_provider.dart';

class ClientProviderImpl implements ClientProvider {
  static const _collectionName = 'clients';

  final FirebaseFirestore db;
  ClientProviderImpl(this.db);

  @override
  Future<List<Client>> getAllClientsByUser({required String userId}) async {
    QuerySnapshot querySnapshot = await db
        .collection(_collectionName)
        .where('userId', isEqualTo: userId)
        .get();
    return querySnapshot.docs
        .map((doc) => Client.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addNewClient({required Client client}) async {
    await db.collection(_collectionName).add(client.toJson());
  }

  @override
  Future<void> deleteClient(
      {required String clientName, required String userId}) async {
    QuerySnapshot querySnapshot = await db
        .collection(_collectionName)
        .where('name', isEqualTo: clientName)
        .where('userId', isEqualTo: userId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String clientId = querySnapshot.docs.first.id;
      await db.collection(_collectionName).doc(clientId).delete();
    } else {
      throw Exception('Cliente no encontrado o no autorizado para eliminar.');
    }
  }

  @override
  Future<Client> getClientById({required String clientId}) async {
    DocumentSnapshot doc =
        await db.collection(_collectionName).doc(clientId).get();
    if (doc.exists) {
      return Client.fromJson(doc.data() as Map<String, dynamic>);
    } else {
      throw Exception('Cliente no encontrado');
    }
  }
}
