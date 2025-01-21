import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prestamos/data/providers/client_provider/client_provider_impl.dart';
import 'package:prestamos/data/services/firebase_service.dart';
import 'package:prestamos/ui/client/bloc/client_bloc.dart';
import 'package:prestamos/ui/client/bloc/client_event.dart';
import 'package:prestamos/ui/client/bloc/client_state.dart';
import 'package:prestamos/ui/extensions/build_context_extension.dart';
import 'package:prestamos/data/repositories/client_repository.dart';
import '../../widgets/utils/snack_bar_top.dart';
import '../../../domain/models/client/client.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoansScreen extends StatefulWidget {
  const LoansScreen({super.key});

  @override
  LoansScreenState createState() => LoansScreenState();
}

class LoansScreenState extends State<LoansScreen> {
  late ClientBloc clientBloc;

  final List<Client> clients = [];

  bool isLoading = true;
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = _auth.currentUser?.uid;
    clientBloc = ClientBloc(
      ClientRepository(ClientProviderImpl(FirebaseFirestore.instance)),
      userId!,
    );
    clientBloc.add(LoadClients());
  }

  void _showSnackBar(String message) {
    SnackBarTop.showTopSnackBar(context, message);
  }

  @override
  void dispose() {
    searchController.dispose();
    clientBloc.close();
    super.dispose();
  }

  Widget _buildClientTile(Client client, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: ListTile(
        title: Text(client.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.add_box),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('loan')
                    .where('clientName', isEqualTo: client.name)
                    .where('userId', isEqualTo: userId)
                    .where('renovado', isEqualTo: false)
                    .get()
                    .then((querySnapshot) {
                  if (querySnapshot.docs.isNotEmpty) {
                    _showSnackBar(context.l10n.existLoan);
                  } else {
                    context.push('/createLoan/${client.name}');
                  }
                }).catchError((error) {
                  _showSnackBar(context.l10n.error);
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.account_balance_wallet),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('loan')
                    .where('clientName', isEqualTo: client.name)
                    .where('userId', isEqualTo: userId)
                    //.where('completado', isEqualTo: false)
                    .where('renovado', isEqualTo: false)
                    .get()
                    .then((querySnapshot) {
                  if (querySnapshot.docs.isNotEmpty) {
                    String loanId = querySnapshot.docs.first.id;

                    context.push('/viewLoan/$loanId');
                  } else {
                    _showSnackBar(context.l10n.noLoan);
                  }
                }).catchError((error) {
                  _showSnackBar(context.l10n.error);
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(context.l10n.deleteClient),
                      content: const Text(
                          'NOTA: Se eliminará el préstamo asociado a este cliente, pero no se eliminará el cliente'),
                      actions: [
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () {
                            deleteLoanForClient(client.name, userId!);
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(context.l10n.acept),
                        ),
                        const SizedBox(width: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(context.l10n.cancel),
                        ),
                        const SizedBox(width: 10),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: searchController,
                onChanged: (value) {
                  clientBloc.add(SearchClients(value));
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: context.l10n.searchClient,
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
              )
            : const Align(
                alignment: Alignment.centerLeft,
                child: Text('Gestión de Préstamos'),
              ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.clear : Icons.search),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  isSearching = false;
                  searchController.clear();
                  clientBloc.add(LoadClients());
                } else {
                  isSearching = true;
                }
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<ClientBloc, ClientState>(
        bloc: clientBloc,
        builder: (context, state) {
          if (state is ClientLoading) {
            return const Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
            ));
          } else if (state is ClientLoaded) {
            final clients = state.clients;

            final filteredClients = isSearching
                ? clients
                    .where((client) => client.name
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase()))
                    .toList()
                : clients;

            return filteredClients.isEmpty
                ? Center(child: Text(context.l10n.noFoundClients))
                : ListView.builder(
                    itemCount: filteredClients.length,
                    itemBuilder: (context, index) {
                      return _buildClientTile(filteredClients[index], index);
                    },
                  );
          } else if (state is ClientError) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text(context.l10n.noFoundClients));
        },
      ),
    );
  }
}
