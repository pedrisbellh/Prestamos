import 'package:prestamos/data/providers/client_provider/client_provider_impl.dart';
import '../../domain/models/client/client.dart';

class ClientRepository {
  final ClientProviderImpl clientProvider;

  ClientRepository(this.clientProvider);

  Future<List<Client>> fetchClients(String userId) async {
    return await clientProvider.getAllClientsByUser(userId: userId);
  }

  Future<void> addClient(Client client) async {
    await clientProvider.addNewClient(client: client);
  }

  Future<void> removeClient(String clientName, String userId) async {
    await clientProvider.deleteClient(clientName: clientName, userId: userId);
  }

  Future<Client> getClientById(String clientId) async {
    return await clientProvider.getClientById(clientId: clientId);
  }
}
