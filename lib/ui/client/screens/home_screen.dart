import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prestamos/ui/client/bloc/client_bloc.dart';
import 'package:prestamos/ui/client/bloc/client_event.dart';
import 'package:prestamos/ui/client/bloc/client_state.dart';
import 'package:prestamos/ui/extensions/build_context_extension.dart';
import 'package:prestamos/domain/models/company/company.dart';
import 'package:prestamos/data/repositories/client_repository.dart';
import 'package:prestamos/ui/widgets/validators/client_validator.dart';
import '../../widgets/utils/upper_case_text_formatter.dart';
import '../../widgets/utils/snack_bar_top.dart';
import '../../../domain/models/client/client.dart';
import '../../../data/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late ClientBloc clientBloc;

  final List<Client> clients = [];

  bool isLoading = true;
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emergencyContactNameController =
      TextEditingController();
  final TextEditingController emergencyContactPhoneController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = _auth.currentUser?.uid;
    clientBloc =
        ClientBloc(ClientRepository(FirebaseFirestore.instance), userId!);
    clientBloc.add(LoadClients());
  }

  void _showSnackBar(String message) {
    SnackBarTop.showTopSnackBar(context, message);
  }

  @override
  void dispose() {
    clientNameController.dispose();
    phoneNumberController.dispose();
    emergencyContactNameController.dispose();
    emergencyContactPhoneController.dispose();
    searchController.dispose();
    clientBloc.close();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      inputFormatters: [UpperCaseTextFormatter()],
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.teal),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.teal, width: 2.0),
        ),
      ),
      validator: validator,
      keyboardType: TextInputType.text,
      maxLines: null,
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d\s\+\-()]')),
      ],
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.teal),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.teal, width: 2.0),
        ),
      ),
      validator: validator,
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildMixtField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9#\s]')),
      ],
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.teal),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.teal, width: 2.0),
        ),
      ),
      validator: validator,
      maxLines: null,
    );
  }

  void _addClientDialog() {
    clientNameController.clear();
    phoneNumberController.clear();
    emergencyContactNameController.clear();
    emergencyContactPhoneController.clear();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController identityCardController =
        TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(context.l10n.addClient,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(
                    controller: clientNameController,
                    hintText: context.l10n.fullName,
                    validator: (value) =>
                        ClientValidation.validateName(value, context),
                  ),
                  const SizedBox(height: 10),
                  _buildNumberField(
                    controller: phoneNumberController,
                    hintText: context.l10n.telephone,
                    validator: (value) =>
                        ClientValidation.validatePhone(value, context),
                  ),
                  const SizedBox(height: 10),
                  _buildMixtField(
                    controller: addressController,
                    hintText: context.l10n.direction,
                    validator: (value) => value == null || value.isEmpty
                        ? context.l10n.emptyField
                        : null,
                  ),
                  const SizedBox(height: 10),
                  _buildNumberField(
                    controller: identityCardController,
                    hintText: context.l10n.clientId,
                    validator: (value) =>
                        ClientValidation.validateIdentityCard(value, context),
                  ),
                  const SizedBox(height: 20),
                  Text(context.l10n.emergencyContact,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: emergencyContactNameController,
                    hintText: context.l10n.fullName,
                    validator: (value) =>
                        ClientValidation.validateName(value, context),
                  ),
                  const SizedBox(height: 10),
                  _buildNumberField(
                    controller: emergencyContactPhoneController,
                    hintText: context.l10n.telephone,
                    validator: (value) =>
                        ClientValidation.validatePhone(value, context),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      String clientName = clientNameController.text;
                      String phoneNumber = phoneNumberController.text;
                      String emergencyContactName =
                          emergencyContactNameController.text;
                      String emergencyContactPhone =
                          emergencyContactPhoneController.text;
                      String address = addressController.text;
                      String identityCard = identityCardController.text;

                      if (!clients.any((client) => client.name == clientName)) {
                        final db = FirebaseFirestore.instance;
                        final doc = db
                            .collection('clients')
                            .withConverter(
                              fromFirestore: (json, _) =>
                                  Client.fromJson(json.data() ?? {}),
                              toFirestore: (value, options) => value.toJson(),
                            )
                            .doc();

                        await doc.set(
                          Client(
                            name: clientName,
                            phone: phoneNumber,
                            emergencyContactName: emergencyContactName,
                            emergencyContactPhone: emergencyContactPhone,
                            address: address,
                            identityCard: identityCard,
                            id: doc.id,
                            userId: userId,
                          ),
                        );

                        Navigator.of(context).pop();
                        clientBloc.add(LoadClients());
                        _showSnackBar(context.l10n.clientAdd);
                      } else {
                        _showSnackBar(context.l10n.existingClient);
                      }
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(context.l10n.acept),
                ),
                const SizedBox(width: 40),
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
              ],
            )
          ],
        );
      },
    );
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
              icon: const Icon(Icons.person),
              onPressed: () {
                final clientId = client.id;
                context.read<ClientBloc>().add(LoadClientDetails(clientId!));
                context.push('/clientDetails/$clientId');
              },
            ),
            IconButton(
              icon: const Icon(Icons.account_balance),
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
                      content: Text(context.l10n.deleteNote),
                      actions: [
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () {
                            clientBloc.add(RemoveClient(client.name));
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

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      context.go('/login');
    } catch (e) {
      _showSnackBar(context.l10n.error);
    }
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
            : Align(
                alignment: Alignment.centerLeft,
                child: Text(context.l10n.clientsManagement),
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
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert),
            offset: const Offset(0, 52),
            onSelected: (value) async {
              switch (value) {
                case 1:
                  String userId = FirebaseAuth.instance.currentUser!.uid;
                  Company? company = await getCompanyFromFirestore(userId);

                  if (company != null) {
                    context.push('/viewCompany/$userId');
                  } else {
                    context.push('/createCompany');
                  }
                  break;
                case 2:
                  context.push('/userPanel');
                  break;
                case 3:
                  _logout(context);
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 1,
                child: Text(context.l10n.viewCompany),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Text(context.l10n.accountDetails),
              ),
              PopupMenuItem<int>(
                value: 3,
                child: Text(context.l10n.logout),
              ),
            ],
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _addClientDialog,
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            heroTag: 'add_client',
            child: const Icon(Icons.person_add),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
