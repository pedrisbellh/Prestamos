import 'package:prestamos/domain/models/client/client.dart';

abstract class ClientProvider {
  Future<List<Client>> getAllClientsByUser({required String userId});
  Future<Client> getClientById({required String clientId});
  Future<void> deleteClient(
      {required String clientName, required String userId});
  Future<void> addNewClient({required Client client});
}
