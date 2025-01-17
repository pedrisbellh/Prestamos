import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prestamos/ui/extensions/build_context_extension.dart';
import 'package:prestamos/ui/client/bloc/client_bloc.dart';
import 'package:prestamos/ui/client/bloc/client_event.dart';
import 'package:prestamos/ui/client/bloc/client_state.dart';

class ClientDetailsScreen extends StatefulWidget {
  final String clientId;

  const ClientDetailsScreen({
    super.key,
    required this.clientId,
  });

  @override
  State<ClientDetailsScreen> createState() => _ClientDetailsScreenState();
}

class _ClientDetailsScreenState extends State<ClientDetailsScreen> {
  Widget _clientInfo(IconData icon, String title, String subtitle) => ListTile(
        title: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.black54),
        ),
        leading: Icon(icon, color: Colors.teal),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      );

  @override
  void initState() {
    super.initState();
    context.read<ClientBloc>().add(LoadClientDetails(widget.clientId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.clientDetail),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<ClientBloc, ClientState>(
        listenWhen: (previous, current) => current is ClientError,
        listener: (context, state) {
          if (state is ClientError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ClientLoading) {
            return const Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
            ));
          } else if (state is ClientDetailsLoaded) {
            final client = state.client;
            return Container(
              height: double.infinity,
              color: Colors.grey[200],
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.clientContact,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal),
                        ),
                        const SizedBox(height: 16),
                        _clientInfo(
                            Icons.person, context.l10n.fullName, client.name),
                        _clientInfo(
                            Icons.phone, context.l10n.telephone, client.phone),
                        _clientInfo(
                            Icons.home, context.l10n.direction, client.address),
                        _clientInfo(
                          Icons.card_membership,
                          context.l10n.clientId,
                          client.identityCard,
                        ),
                        const Divider(),
                        const SizedBox(height: 16),
                        Text(
                          context.l10n.emergencyContact,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal),
                        ),
                        const SizedBox(height: 16),
                        _clientInfo(Icons.person, context.l10n.fullName,
                            client.emergencyContactName),
                        _clientInfo(
                          Icons.phone,
                          context.l10n.telephone,
                          client.emergencyContactPhone,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Center(
                child: Text('Error al cargar los detalles del cliente.'));
          }
        },
      ),
    );
  }
}
