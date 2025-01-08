import 'package:equatable/equatable.dart';
import 'package:prestamos/domain/models/client/client.dart';

abstract class ClientState extends Equatable {
  @override
  List<Object> get props => [];
}

class ClientInitial extends ClientState {}

class ClientLoading extends ClientState {}

class ClientLoaded extends ClientState {
  final List<Client> clients;

  ClientLoaded(this.clients);

  @override
  List<Object> get props => [clients];
}

class ClientError extends ClientState {
  final String message;

  ClientError(this.message);

  @override
  List<Object> get props => [message];
}

class ClientDetailsLoaded extends ClientState {
  final Client client;

  ClientDetailsLoaded(this.client);

  @override
  List<Object> get props => [client];
}
