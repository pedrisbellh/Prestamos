import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestamos/models/client/client.dart';
import 'package:prestamos/providers/client/client_provider.dart';

class ClientProviderImpl implements ClientProvider {
  static const _collectionName = 'clients';

  @override
  Future<void> deleteClient({required String id}) {
    // TODO: implement deleteClient
    throw UnimplementedError();
  }

  @override
  Future<List<Client>> getAllClientsByUser({required String userId}) async {
    final query = FirebaseFirestore.instance
        .collection(_collectionName)
        .withConverter(
          fromFirestore: (json, _) => Client.fromJson(json.data() ?? {}),
          toFirestore: (value, _) => value.toJson(),
        )
        .where('userId', isEqualTo: userId);

    return query
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
  }

  @override
  Future<Client> getClientById({required String id}) {
    // TODO: implement getClientById
    throw UnimplementedError();
  }
}
