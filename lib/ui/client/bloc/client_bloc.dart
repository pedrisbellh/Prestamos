import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prestamos/data/repositories/client_repository.dart';
import 'client_event.dart';
import 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  final ClientRepository clientRepository;
  final String userId;

  ClientBloc(this.clientRepository, this.userId) : super(ClientInitial()) {
    on<LoadClients>((event, emit) async {
      emit(ClientLoading());
      try {
        final clients = await clientRepository.fetchClients(userId);
        emit(ClientLoaded(clients));
      } catch (e) {
        emit(ClientError('Error al cargar clientes: $e'));
      }
    });

    on<AddClient>((event, emit) async {
      try {
        await clientRepository.addClient(event.client);
        final clients = await clientRepository.fetchClients(userId);
        emit(ClientLoaded(clients));
      } catch (e) {
        emit(ClientError('Error al agregar cliente: $e'));
      }
    });

    on<RemoveClient>((event, emit) async {
      try {
        await clientRepository.removeClient(event.clientName, userId);
        final clients = await clientRepository.fetchClients(userId);
        emit(ClientLoaded(clients));
      } catch (e) {
        emit(ClientError('Error al eliminar cliente: $e'));
      }
    });

    on<SearchClients>((event, emit) async {
      if (state is ClientLoaded) {
        final allClients = (state as ClientLoaded).clients;
        final filteredClients = allClients
            .where((client) =>
                client.name.toLowerCase().contains(event.query.toLowerCase()))
            .toList();
        emit(ClientLoaded(filteredClients));
      }
    });
  }
}
