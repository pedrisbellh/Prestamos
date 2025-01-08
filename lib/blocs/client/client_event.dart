import 'package:equatable/equatable.dart';
import 'package:prestamos/models/client/client.dart';

abstract class ClientEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadClients extends ClientEvent {}

class AddClient extends ClientEvent {
  final Client client;

  AddClient(this.client);

  @override
  List<Object> get props => [client];
}

class RemoveClient extends ClientEvent {
  final String clientName;

  RemoveClient(this.clientName);

  @override
  List<Object> get props => [clientName];
}

class SearchClients extends ClientEvent {
  final String query;

  SearchClients(this.query);

  @override
  List<Object> get props => [query];
}
