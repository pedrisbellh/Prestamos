import 'package:prestamos/domain/models/client/client.dart';

abstract class ClientProvider {
  Future<List<Client>> getAllClientsByUser({required String userId});
  Future<Client> getClientById({required String id});
  Future<void> deleteClient({required String id});
}
